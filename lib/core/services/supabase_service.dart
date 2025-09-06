import 'package:supabase_flutter/supabase_flutter.dart';
import '../../config/supabase_config.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();
  
  SupabaseService._();

  SupabaseClient get client => SupabaseConfig.client;

  // Table names
  static const String studentsTable = 'students';
  static const String studentsPendingTable = 'students_pending';
  static const String lessonsTable = 'lessons';
  static const String attendanceTable = 'attendance';
  static const String announcementsTable = 'announcements';

  // Auth operations
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: metadata,
    );
  }

  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  User? get currentUser => client.auth.currentUser;
  String? get currentUserId => currentUser?.id;

  // Auth state stream
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // Database operations
  Future<List<Map<String, dynamic>>> getTable({
    required String table,
    String? select,
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    try {
      var query = client.from(table).select(select ?? '*');

      // Apply filters
      if (filters != null) {
        filters.forEach((key, value) {
          if (value != null) {
            query = query.eq(key, value);
          }
        });
      }

      // Apply ordering
      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }

      // Apply limit
      if (limit != null) {
        query = query.limit(limit);
      }

      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('فشل في جلب البيانات: $e');
    }
  }

  Future<Map<String, dynamic>?> getRecord({
    required String table,
    required String id,
    String? select,
  }) async {
    try {
      final response = await client
          .from(table)
          .select(select ?? '*')
          .eq('id', id)
          .single();
      return response;
    } catch (e) {
      if (e.toString().contains('PGRST116')) {
        return null; // Record not found
      }
      throw Exception('فشل في جلب السجل: $e');
    }
  }

  Future<Map<String, dynamic>> insertRecord({
    required String table,
    required Map<String, dynamic> data,
    String? select,
  }) async {
    try {
      final response = await client
          .from(table)
          .insert(data)
          .select(select ?? '*')
          .single();
      return response;
    } catch (e) {
      throw Exception('فشل في إدراج السجل: $e');
    }
  }

  Future<Map<String, dynamic>> updateRecord({
    required String table,
    required String id,
    required Map<String, dynamic> data,
    String? select,
  }) async {
    try {
      final response = await client
          .from(table)
          .update(data)
          .eq('id', id)
          .select(select ?? '*')
          .single();
      return response;
    } catch (e) {
      throw Exception('فشل في تحديث السجل: $e');
    }
  }

  Future<void> deleteRecord({
    required String table,
    required String id,
  }) async {
    try {
      await client.from(table).delete().eq('id', id);
    } catch (e) {
      throw Exception('فشل في حذف السجل: $e');
    }
  }

  // Real-time subscriptions
  RealtimeChannel subscribeToTable({
    required String table,
    required void Function(Map<String, dynamic>) onInsert,
    required void Function(Map<String, dynamic>) onUpdate,
    required void Function(Map<String, dynamic>) onDelete,
  }) {
    return client
        .channel('$table-changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: table,
          callback: (payload) => onInsert(payload.newRecord),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: table,
          callback: (payload) => onUpdate(payload.newRecord),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: table,
          callback: (payload) => onDelete(payload.oldRecord),
        )
        .subscribe();
  }

  // Storage operations
  Future<String> uploadFile({
    required String bucket,
    required String path,
    required List<int> fileBytes,
    String? contentType,
  }) async {
    try {
      await client.storage.from(bucket).uploadBinary(
        path,
        fileBytes,
        fileOptions: FileOptions(
          contentType: contentType,
          upsert: true,
        ),
      );
      return client.storage.from(bucket).getPublicUrl(path);
    } catch (e) {
      throw Exception('فشل في رفع الملف: $e');
    }
  }

  Future<void> deleteFile({
    required String bucket,
    required String path,
  }) async {
    try {
      await client.storage.from(bucket).remove([path]);
    } catch (e) {
      throw Exception('فشل في حذف الملف: $e');
    }
  }

  // Error handling
  String getErrorMessage(dynamic error) {
    if (error is PostgrestException) {
      switch (error.code) {
        case 'PGRST301':
          return 'ليس لديك صلاحية للوصول إلى هذه البيانات';
        case 'PGRST116':
          return 'البيانات غير موجودة';
        case '23505':
          return 'البيانات موجودة بالفعل';
        case '23503':
          return 'لا يمكن حذف هذا السجل لأنه مرتبط ببيانات أخرى';
        case '23514':
          return 'البيانات المدخلة غير صحيحة';
        case '42501':
          return 'ليس لديك صلاحية لتنفيذ هذه العملية';
        default:
          return 'حدث خطأ: ${error.message}';
      }
    }
    return 'حدث خطأ غير متوقع';
  }
}
