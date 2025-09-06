import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/teacher_news/presentation/pages/teacher_news_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/schedule/presentation/pages/schedule_page.dart';
import '../features/announcements/presentation/pages/announcements_page.dart';
import '../core/services/auth_service.dart';
import '../config/localization.dart';

// Router Provider
final appRouterProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);
  
  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authService.currentUser != null;
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';
      
      // If not logged in and not on auth pages, redirect to login
      if (!isLoggedIn && !isLoggingIn && !isRegistering) {
        return '/login';
      }
      
      // If logged in and on auth pages, redirect to dashboard
      if (isLoggedIn && (isLoggingIn || isRegistering)) {
        return '/dashboard';
      }
      
      return null;
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      
      // Main App Routes
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
        routes: [
          // Schedule Routes
          GoRoute(
            path: 'schedule',
            name: 'schedule',
            builder: (context, state) => const SchedulePage(),
          ),
          
          // Announcements Routes
          GoRoute(
            path: 'announcements',
            name: 'announcements',
            builder: (context, state) => const AnnouncementsPage(),
          ),
          
          // Teacher News Routes
          GoRoute(
            path: 'teacher-news',
            name: 'teacher-news',
            builder: (context, state) => const TeacherNewsPage(),
          ),
          
          // Settings Routes
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'الصفحة غير موجودة',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'عذراً، الصفحة التي تبحث عنها غير موجودة',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/dashboard'),
              child: const Text('العودة للرئيسية'),
            ),
          ],
        ),
      ),
    ),
  );
});

// Navigation Extensions
extension AppRouterExtension on BuildContext {
  void goToLogin() => go('/login');
  void goToRegister() => go('/register');
  void goToDashboard() => go('/dashboard');
  void goToSchedule() => go('/dashboard/schedule');
  void goToAnnouncements() => go('/dashboard/announcements');
  void goToTeacherNews() => go('/dashboard/teacher-news');
  void goToSettings() => go('/dashboard/settings');
  
  void pushLogin() => push('/login');
  void pushRegister() => push('/register');
  void pushSchedule() => push('/dashboard/schedule');
  void pushAnnouncements() => push('/dashboard/announcements');
  void pushTeacherNews() => push('/dashboard/teacher-news');
  void pushSettings() => push('/dashboard/settings');
}

