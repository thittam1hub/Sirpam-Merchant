package com.vendoros.app

import android.Manifest
import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothSocket
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.io.OutputStream
import java.util.UUID
import java.util.concurrent.Executors

/**
 * Bluetooth (SPP / RFCOMM) transport for 58 mm and 80 mm ESC/POS receipt
 * printers — the class of hardware every Indian tea shop actually owns.
 *
 * The Dart side stays platform-agnostic: it hands over raw ESC/POS bytes and
 * gets back a boolean. Every failure is reported instead of thrown so the app
 * can fall back to a PDF and never lose a bill.
 */
object ThermalPrinter {
    private const val CHANNEL = "vendoros/printer"
    const val PERMISSION_REQUEST = 9911
    private val SPP: UUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")

    private val io = Executors.newSingleThreadExecutor()
    private val main = Handler(Looper.getMainLooper())

    private var socket: BluetoothSocket? = null
    private var stream: OutputStream? = null
    private var connectedAddress: String = ""

    private var activity: Activity? = null
    private var pendingPermission: MethodChannel.Result? = null

    fun attach(host: Activity?) {
        activity = host
    }

    /** Called from the activity's permission callback; resolves the Dart future. */
    fun onPermissionResult(context: Context) {
        val pending = pendingPermission ?: return
        pendingPermission = null
        pending.success(hasPermission(context))
    }

    fun bind(messenger: BinaryMessenger, context: Context) {
        MethodChannel(messenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isSupported" -> result.success(adapter(context) != null)
                "hasPermission" -> result.success(hasPermission(context))
                "requestPermission" -> requestPermission(context, result)
                "bondedDevices" -> bondedDevices(context, result)
                "connectedAddress" -> result.success(connectedAddress)
                "connect" -> {
                    val address = call.argument<String>("address").orEmpty()
                    connect(context, address, result)
                }
                "write" -> {
                    val bytes = call.argument<ByteArray>("bytes")
                    write(bytes, result)
                }
                "disconnect" -> {
                    close()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun adapter(context: Context): BluetoothAdapter? =
        BluetoothAdapter.getDefaultAdapter()
            ?: (context.getSystemService(Context.BLUETOOTH_SERVICE) as? android.bluetooth.BluetoothManager)?.adapter

    private fun hasPermission(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return true
        return ContextCompat.checkSelfPermission(context, Manifest.permission.BLUETOOTH_CONNECT) ==
            PackageManager.PERMISSION_GRANTED
    }

    /**
     * Android 12+ needs a runtime grant before a paired printer can even be
     * listed. Asking here keeps the vendor inside the printer screen instead
     * of sending them to system settings.
     */
    private fun requestPermission(context: Context, result: MethodChannel.Result) {
        if (hasPermission(context)) {
            result.success(true)
            return
        }
        val host = activity
        if (host == null || Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
            result.success(false)
            return
        }
        pendingPermission?.success(false)
        pendingPermission = result
        ActivityCompat.requestPermissions(
            host,
            arrayOf(Manifest.permission.BLUETOOTH_CONNECT, Manifest.permission.BLUETOOTH_SCAN),
            PERMISSION_REQUEST
        )
    }

    private fun bondedDevices(context: Context, result: MethodChannel.Result) {
        val adapter = adapter(context)
        if (adapter == null || !hasPermission(context)) {
            result.success(emptyList<Map<String, String>>())
            return
        }
        try {
            val devices = adapter.bondedDevices.map {
                mapOf("name" to (it.name ?: it.address), "address" to it.address)
            }
            result.success(devices)
        } catch (e: SecurityException) {
            result.success(emptyList<Map<String, String>>())
        }
    }

    private fun connect(context: Context, address: String, result: MethodChannel.Result) {
        val adapter = adapter(context)
        if (adapter == null || address.isEmpty() || !hasPermission(context)) {
            result.success(false)
            return
        }
        io.execute {
            var ok = false
            try {
                close()
                val device = adapter.getRemoteDevice(address)
                val s = device.createRfcommSocketToServiceRecord(SPP)
                adapter.cancelDiscovery()
                s.connect()
                socket = s
                stream = s.outputStream
                connectedAddress = address
                ok = true
            } catch (e: Exception) {
                close()
            }
            main.post { result.success(ok) }
        }
    }

    private fun write(bytes: ByteArray?, result: MethodChannel.Result) {
        val out = stream
        if (bytes == null || out == null) {
            result.success(false)
            return
        }
        io.execute {
            var ok = false
            try {
                out.write(bytes)
                out.flush()
                ok = true
            } catch (e: Exception) {
                close()
            }
            main.post { result.success(ok) }
        }
    }

    private fun close() {
        try {
            stream?.close()
        } catch (_: Exception) {
        }
        try {
            socket?.close()
        } catch (_: Exception) {
        }
        stream = null
        socket = null
        connectedAddress = ""
    }
}
