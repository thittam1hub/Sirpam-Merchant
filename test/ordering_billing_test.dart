import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendoros/core/storage/local_store.dart';
import 'package:vendoros/features/billing/domain/bill.dart';
import 'package:vendoros/features/expenses/domain/expense.dart';
import 'package:vendoros/features/ledger/application/ledger_controller.dart';
import 'package:vendoros/features/ledger/domain/sale.dart';
import 'package:vendoros/features/orders/application/order_controller.dart';
import 'package:vendoros/features/orders/domain/order.dart';
import 'package:vendoros/features/orders/domain/shop_config.dart';
import 'package:vendoros/features/printing/domain/escpos.dart';
import 'package:vendoros/features/printing/domain/receipt.dart';

ShopOrder _order(int token, OrderStatus status) => ShopOrder(
      id: 'o$token',
      token: token,
      lines: const [
        OrderLine(productId: 'p1', name: 'Tea', pricePaise: 1000, qty: 2),
      ],
      createdAt: DateTime(2026, 1, 2, 9).millisecondsSinceEpoch,
      updatedAt: DateTime(2026, 1, 2, 9).millisecondsSinceEpoch,
      status: status,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  _dayCloseSnapshotTests();
  _upiAutoSettleTests();
  group('order lifecycle', () {
    test('only legal transitions are allowed', () {
      expect(canTransition(OrderStatus.placed, OrderStatus.preparing), isTrue);
      expect(canTransition(OrderStatus.preparing, OrderStatus.served), isTrue);
      expect(canTransition(OrderStatus.served, OrderStatus.paid), isTrue);
      expect(canTransition(OrderStatus.paid, OrderStatus.preparing), isFalse);
      expect(canTransition(OrderStatus.cancelled, OrderStatus.served), isFalse);
    });

    test('tokens restart each trading day', () {
      final day = dayKey(DateTime(2026, 1, 2));
      final orders = [_order(1, OrderStatus.paid), _order(2, OrderStatus.paid)];
      expect(nextToken(orders, day), 3);
      expect(nextToken(orders, dayKey(DateTime(2026, 1, 3))), 1);
    });

    test('subtotal follows the lines', () {
      expect(_order(1, OrderStatus.placed).subtotalPaise, 2000);
      expect(_order(1, OrderStatus.placed).itemCount, 2);
    });
  });

  group('bill math', () {
    test('discount never pushes the bill negative', () {
      expect(
          BillMath.discount(subtotalPaise: 1000, flatPaise: 5000), 1000);
      expect(
          BillMath.discount(subtotalPaise: 1000, percent: 10), 100);
    });

    test('tax applies after discount and rounding lands on the rupee', () {
      final totals = BillMath.compute(
        subtotalPaise: 10000,
        discountFlatPaise: 500,
        taxPercent: 5,
      );
      expect(totals.discountPaise, 500);
      expect(totals.taxPaise, 475);
      expect(totals.totalPaise % 100, 0);
      expect(totals.subtotalPaise - totals.discountPaise + totals.taxPaise +
          totals.roundingPaise, totals.totalPaise);
    });

    test('rounding delta follows the 50 paise rule', () {
      expect(BillMath.roundingDelta(1049), -49);
      expect(BillMath.roundingDelta(1050), 50);
      expect(BillMath.roundingDelta(1000), 0);
    });

    test('split tenders settle the balance to zero', () {
      const payments = [
        BillPayment(mode: SaleMode.cash, amountPaise: 6000),
        BillPayment(mode: SaleMode.upi, amountPaise: 3000),
        BillPayment(mode: SaleMode.credit, amountPaise: 1000),
      ];
      expect(BillMath.balance(10000, payments), 0);
      expect(BillMath.balance(12000, payments), 2000);
    });

    test('bill numbers increment per day', () {
      final day = dayKey(DateTime(2026, 1, 2));
      final bill = Bill(
        id: 'b1',
        orderId: 'o1',
        number: BillMath.number(day, 1),
        day: day,
        sequence: 1,
        ts: 0,
        subtotalPaise: 1000,
        totalPaise: 1000,
      );
      expect(nextBillSequence([bill], day), 2);
      expect(nextBillSequence([bill], dayKey(DateTime(2026, 1, 3))), 1);
    });
  });

  group('receipt', () {
    ReceiptData data() => const ReceiptData(
          shopName: 'Sirpam Tea',
          billNumber: 'B-1',
          dateText: '02/01/26 09:00',
          lines: [ReceiptLine(name: 'Tea', qty: 2, totalPaise: 2000)],
          subtotalPaise: 2000,
          totalPaise: 2000,
          tenders: [ReceiptTender(label: 'Cash', amountPaise: 2000)],
          labels: ReceiptLabels(
            bill: 'Bill',
            token: 'Token',
            table: 'Table',
            subtotal: 'Subtotal',
            discount: 'Discount',
            tax: 'GST',
            rounding: 'Rounding',
            total: 'Total',
            paid: 'Paid',
            balance: 'Balance',
            reprint: 'Reprint',
            thanks: 'Thanks',
          ),
        );

    test('text receipt fits the roll width', () {
      final text = ReceiptText.render(data(), PaperWidth.mm58);
      for (final line in text.split('\n')) {
        expect(line.length, lessThanOrEqualTo(columnsFor(PaperWidth.mm58)));
      }
      expect(text, contains('Tea'));
      expect(text, contains('Total'));
    });

    test('escpos output is initialised and cut', () {
      final bytes = EscPos.receipt(data(), PaperWidth.mm80);
      expect(bytes.take(2), [0x1B, 0x40]);
      expect(bytes.length, greaterThan(40));
    });
  });

  test('menu url carries the table', () {
    const shop = ShopConfig(slug: 'sirpam', menuBaseUrl: 'https://x.app/');
    expect(shop.menuUrl(0), 'https://x.app/m/sirpam');
    expect(shop.menuUrl(4), 'https://x.app/m/sirpam?t=4');
  });
}

void _dayCloseSnapshotTests() {
  test('day close keeps its reconciliation snapshot across a reload', () {
    const close = DayClose(
      day: '2026-01-09',
      expectedCashPaise: 250000,
      countedCashPaise: 249000,
      ts: 1700000000000,
      ordersTaken: 42,
      ordersCancelled: 2,
      billedPaise: 310000,
      discountPaise: 1500,
      taxPaise: 4000,
      upiPaise: 60000,
      creditPaise: 5000,
      expensePaise: 90000,
      lastToken: 42,
      variancePosted: true,
    );
    final back = DayClose.tryFromJson(close.toJson())!;
    expect(back.differencePaise, -1000);
    expect(back.ordersTaken, 42);
    expect(back.discountPaise, 1500);
    expect(back.lastToken, 42);
    expect(back.variancePosted, isTrue);
  });
}

void _upiAutoSettleTests() {
  group('UPI auto-settlement matching', () {
    test('matches exactly one open order on the rounded total', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await LocalStore.init();
      final container = ProviderContainer(
          overrides: [localStoreProvider.overrideWithValue(store)]);
      addTearDown(container.dispose);
      final orders = container.read(orderProvider.notifier);
      final a = await orders.placeOrder(lines: const [
        OrderLine(productId: 'p1', name: 'Tea', pricePaise: 1000, qty: 2),
      ]);
      await orders.placeOrder(lines: const [
        OrderLine(productId: 'p2', name: 'Vadai', pricePaise: 1500, qty: 1),
      ]);

      expect(orders.matchingOpenOrders(2000).single.id, a.id);
      expect(orders.matchingOpenOrders(9999), isEmpty);

      // Two open orders of the same amount stay ambiguous — no auto-settle.
      await orders.placeOrder(lines: const [
        OrderLine(productId: 'p3', name: 'Coffee', pricePaise: 2000, qty: 1),
      ]);
      expect(orders.matchingOpenOrders(2000).length, 2);
      expect(await orders.settleFromUpiPayment(2000), isNull);
      expect(await orders.settleFromUpiPayment(0), isNull);
    });

    test('a unique match becomes a paid UPI bill', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await LocalStore.init();
      final container = ProviderContainer(
          overrides: [localStoreProvider.overrideWithValue(store)]);
      addTearDown(container.dispose);
      final orders = container.read(orderProvider.notifier);
      final order = await orders.placeOrder(lines: const [
        OrderLine(productId: 'p1', name: 'Tea', pricePaise: 1200, qty: 1),
      ]);
      final bill = await orders.settleFromUpiPayment(1200);
      expect(bill, isNotNull);
      expect(bill!.totalPaise, 1200);
      expect(bill.payments.single.mode, SaleMode.upi);
      expect(
          container.read(orderProvider).orderById(order.id)!.status,
          OrderStatus.paid);
      expect(container.read(ledgerProvider).sales.first.amountPaise, 1200);
    });
  });

  group('merchant ordering rules', () {
    test('service and payment rules survive a round-trip', () {
      const cfg = ShopConfig(
        serviceMode: 'self',
        payMode: 'before',
        allowCallStaff: false,
        allowRequestBill: true,
      );
      final back = ShopConfig.fromJson(cfg.toJson());
      expect(back.serviceMode, 'self');
      expect(back.payMode, 'before');
      expect(back.allowCallStaff, isFalse);
      expect(back.allowRequestBill, isTrue);
    });

    test('unknown rules fall back to table service, pay after', () {
      final cfg = ShopConfig.fromJson({'serviceMode': 'moon', 'payMode': 'later'});
      expect(cfg.serviceMode, 'table');
      expect(cfg.payMode, 'after');
    });
  });
}
