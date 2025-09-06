import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../models/student_model.dart';

// Auth State Provider
final authProvider = AsyncNotifierProvider<AuthNotifier, void>(() {
  return AuthNotifier();
});

class AuthNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // Initialize auth state
    return null;
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Sign in with username and national ID
  Future<void> signInWithUsernameAndNationalId({
    required String username,
    required String nationalId,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithUsernameAndNationalId(
        username: username,
        nationalId: nationalId,
      );
      
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Register new student
  Future<void> registerStudent({
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
    state = const AsyncValue.loading();
    
    try {
      final authService = ref.read(authServiceProvider);
      await authService.registerStudent(
        fullName: fullName,
        username: username,
        nationalId: nationalId,
        studentPhone: studentPhone,
        parentPhone: parentPhone,
        stage: stage,
        age: age,
        center: center,
        email: email,
        password: password,
      );
      
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signOut();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    state = const AsyncValue.loading();
    
    try {
      final authService = ref.read(authServiceProvider);
      await authService.resetPassword(email);
      
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final authService = ref.read(authServiceProvider);
      await authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// Current Student Provider
final currentStudentProvider = FutureProvider<Student?>((ref) async {
  final authService = ref.read(authServiceProvider);
  final userId = authService.currentUserId;
  
  if (userId == null) return null;
  
  return await authService.getStudentById(userId);
});

// Student Status Provider
final studentStatusProvider = Provider<String?>((ref) {
  final studentAsync = ref.watch(currentStudentProvider);
  return studentAsync.when(
    data: (student) => student?.status,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Is Student Approved Provider
final isStudentApprovedProvider = Provider<bool>((ref) {
  final status = ref.watch(studentStatusProvider);
  return status == 'approved';
});

