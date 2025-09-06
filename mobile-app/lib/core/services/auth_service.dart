import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/student_model.dart';
import 'supabase_service.dart';

// Auth State Provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  return SupabaseService.instance.authStateChanges;
});

// Current User Provider
final currentUserProvider = Provider<User?>((ref) {
  return SupabaseService.instance.currentUser;
});

// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class AuthService {
  final SupabaseService _supabaseService = SupabaseService.instance;

  // Current user
  User? get currentUser => _supabaseService.currentUser;
  String? get currentUserId => currentUser?.id;

  // Auth state stream
  Stream<AuthState> get authStateChanges => _supabaseService.authStateChanges;

  // Sign in with email and password
  Future<AuthResponse> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseService.signInWithPassword(
        email: email,
        password: password,
      );

      // Check if user is approved
      if (response.user != null) {
        final student = await getStudentById(response.user!.id);
        if (student == null || student.status != 'approved') {
          await signOut();
          throw AuthException('الحساب غير موافق عليه بعد');
        }
      }

      return response;
    } catch (e) {
      throw AuthException(_getAuthErrorMessage(e));
    }
  }

  // Sign in with username and national ID
  Future<AuthResponse> signInWithUsernameAndNationalId({
    required String username,
    required String nationalId,
  }) async {
    try {
      // Find student by username and national ID
      final student = await _findStudentByCredentials(username, nationalId);
      if (student == null) {
        throw AuthException('بيانات الدخول غير صحيحة');
      }

      if (student.status != 'approved') {
        throw AuthException('الحساب غير موافق عليه بعد');
      }

      // Sign in with email (if available) or create account
      if (student.email.isNotEmpty) {
        // Generate a temporary password for existing email
        // In production, you should handle this differently
        throw AuthException('يرجى استخدام البريد الإلكتروني وكلمة المرور');
      } else {
        throw AuthException('يرجى إنشاء حساب جديد');
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('حدث خطأ في تسجيل الدخول');
    }
  }

  // Register new student
  Future<AuthResponse> registerStudent({
    required String fullName,
    required String username,
    required String nationalId,
    required String studentPhone,
    required String parentPhone,
    required String stage,
    required int age,
    required String center,
    required String email,
    required String password,
  }) async {
    try {
      // Check if username already exists
      final existingStudent = await _findStudentByUsername(username);
      if (existingStudent != null) {
        throw AuthException('اسم المستخدم مستخدم بالفعل');
      }

      // Check if national ID already exists
      final existingNationalId = await _findStudentByNationalId(nationalId);
      if (existingNationalId != null) {
        throw AuthException('الرقم القومي مستخدم بالفعل');
      }

      // Create student document in pending collection first
      final studentPending = StudentPending(
        id: '', // Will be set after user creation
        fullName: fullName,
        username: username,
        nationalId: nationalId,
        studentPhone: studentPhone,
        parentPhone: parentPhone,
        stage: stage,
        age: age,
        center: center,
        email: email,
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Create Supabase Auth user
      final response = await _supabaseService.signUp(
        email: email,
        password: password,
        metadata: {
          'full_name': fullName,
          'username': username,
          'national_id': nationalId,
          'student_phone': studentPhone,
          'parent_phone': parentPhone,
          'stage': stage,
          'age': age,
          'center': center,
        },
      );

      if (response.user == null) {
        throw AuthException('فشل في إنشاء الحساب');
      }

      // Update student pending with user ID
      final updatedStudentPending = studentPending.copyWith(id: response.user!.id);
      
      await _supabaseService.insertRecord(
        table: SupabaseService.studentsPendingTable,
        data: updatedStudentPending.toJson(),
      );

      return response;
    } catch (e) {
      throw AuthException(_getAuthErrorMessage(e));
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _supabaseService.signOut();
  }

  // Get student by ID
  Future<Student?> getStudentById(String id) async {
    try {
      final data = await _supabaseService.getRecord(
        table: SupabaseService.studentsTable,
        id: id,
      );
      
      if (data != null) {
        return Student.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get pending student by ID
  Future<StudentPending?> getPendingStudentById(String id) async {
    try {
      final data = await _supabaseService.getRecord(
        table: SupabaseService.studentsPendingTable,
        id: id,
      );
      
      if (data != null) {
        return StudentPending.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Find student by username
  Future<Student?> _findStudentByUsername(String username) async {
    try {
      final data = await _supabaseService.getTable(
        table: SupabaseService.studentsTable,
        filters: {'username': username},
        limit: 1,
      );
      
      if (data.isNotEmpty) {
        return Student.fromJson(data.first);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Find student by national ID
  Future<Student?> _findStudentByNationalId(String nationalId) async {
    try {
      final data = await _supabaseService.getTable(
        table: SupabaseService.studentsTable,
        filters: {'national_id': nationalId},
        limit: 1,
      );
      
      if (data.isNotEmpty) {
        return Student.fromJson(data.first);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Find student by credentials
  Future<Student?> _findStudentByCredentials(String username, String nationalId) async {
    try {
      final data = await _supabaseService.getTable(
        table: SupabaseService.studentsTable,
        filters: {
          'username': username,
          'national_id': nationalId,
        },
        limit: 1,
      );
      
      if (data.isNotEmpty) {
        return Student.fromJson(data.first);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Update student profile
  Future<void> updateStudentProfile(Student student) async {
    try {
      await _supabaseService.updateRecord(
        table: SupabaseService.studentsTable,
        id: student.id,
        data: student.toJson(),
      );
    } catch (e) {
      throw AuthException('فشل في تحديث الملف الشخصي');
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw AuthException('يجب تسجيل الدخول أولاً');
      }

      // Update password using Supabase
      await _supabaseService.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      throw AuthException(_getAuthErrorMessage(e));
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabaseService.client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw AuthException(_getAuthErrorMessage(e));
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw AuthException('يجب تسجيل الدخول أولاً');
      }

      // Delete student document
      await _supabaseService.deleteRecord(
        table: SupabaseService.studentsTable,
        id: user.id,
      );

      // Delete user account
      await _supabaseService.client.auth.admin.deleteUser(user.id);
    } catch (e) {
      throw AuthException(_getAuthErrorMessage(e));
    }
  }

  // Get auth error message
  String _getAuthErrorMessage(dynamic e) {
    if (e is AuthException) {
      return e.message;
    }
    
    final errorMessage = e.toString().toLowerCase();
    
    if (errorMessage.contains('user not found') || errorMessage.contains('invalid login credentials')) {
      return 'المستخدم غير موجود أو بيانات الدخول غير صحيحة';
    } else if (errorMessage.contains('email already registered')) {
      return 'البريد الإلكتروني مستخدم بالفعل';
    } else if (errorMessage.contains('password')) {
      return 'كلمة المرور غير صحيحة أو ضعيفة';
    } else if (errorMessage.contains('email')) {
      return 'البريد الإلكتروني غير صحيح';
    } else if (errorMessage.contains('disabled')) {
      return 'الحساب معطل';
    } else if (errorMessage.contains('too many requests')) {
      return 'محاولات كثيرة جداً، حاول لاحقاً';
    } else if (errorMessage.contains('network')) {
      return 'مشكلة في الاتصال بالإنترنت';
    } else {
      return 'حدث خطأ غير متوقع: $e';
    }
  }
}

// Auth Exception
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  
  @override
  String toString() => message;
}

