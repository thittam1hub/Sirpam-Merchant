/// Backend endpoint for the server-confirmed soundbox.
///
/// The anon key is a publishable key: it grants nothing on its own — every
/// endpoint it can reach re-checks a provider signature, a webhook token or a
/// device key inside the database function itself.
class SupabaseConfig {
  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://wweqscxogeybgbybvapn.supabase.co',
  );

  static const anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind3ZXFzY3hvZ2V5YmdieWJ2YXBuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODg0OTA5NjksImV4cCI6MjEwNDA2Njk2OX0.sC8tKptUcWkYbt7ciSoM_eUPqgHCyBoAwTcC-ClxBoM',
  );

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;

  static Uri rpc(String name) => Uri.parse('$url/rest/v1/rpc/$name');
}
