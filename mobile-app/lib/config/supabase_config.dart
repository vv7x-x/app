import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://zrxgvzhikiyqyhxprmwc.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpyeGd2emhpa2l5cXloeHBybXdjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcxNDc4NDQsImV4cCI6MjA3MjcyMzg0NH0.7j34n9nchrmxroqdXI6LZLzARiSeYiPQrAOuzZVmong';

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
}
