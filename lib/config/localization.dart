import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// Locale Provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('ar')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('locale') ?? 'ar';
    state = Locale(localeCode);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }
}

class AppLocalizations {
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('ar'), // Arabic
    Locale('en'), // English
  ];

  // Arabic Translations
  static const Map<String, String> ar = {
    // App Name
    'app_name': 'أحمد سامي - سبشيال وان',
    'app_subtitle': 'منصة إدارة حضور الطلاب',

    // Authentication
    'login': 'تسجيل الدخول',
    'register': 'تسجيل حساب جديد',
    'logout': 'خروج',
    'email': 'البريد الإلكتروني',
    'password': 'كلمة المرور',
    'confirm_password': 'تأكيد كلمة المرور',
    'forgot_password': 'نسيت كلمة المرور؟',
    'dont_have_account': 'ليس لديك حساب؟',
    'already_have_account': 'لديك حساب بالفعل؟',
    'login_success': 'تم تسجيل الدخول بنجاح',
    'login_error': 'خطأ في تسجيل الدخول',
    'register_success': 'تم إنشاء الحساب بنجاح',
    'register_error': 'خطأ في إنشاء الحساب',

    // Registration Form
    'full_name': 'الاسم الكامل',
    'username': 'اسم المستخدم',
    'national_id': 'الرقم القومي / شهادة الميلاد',
    'student_phone': 'هاتف الطالب',
    'parent_phone': 'هاتف ولي الأمر',
    'education_stage': 'المرحلة التعليمية',
    'age': 'العمر',
    'learning_center': 'المركز التعليمي',
    'select_stage': 'اختر المرحلة',
    'select_center': 'اختر المركز',
    'elementary': 'ابتدائي',
    'middle': 'إعدادي',
    'high': 'ثانوي',
    'university': 'جامعي',

    // Dashboard
    'dashboard': 'لوحة التحكم',
    'welcome': 'مرحباً',
    'attendance_qr': 'كود الحضور',
    'lesson_schedule': 'جداول الدروس',
    'announcements': 'الإعلانات',
    'teacher_news': 'أخبار المدرس',
    'settings': 'الإعدادات',

    // QR Code
    'qr_code': 'كود QR',
    'show_to_teacher': 'اعرض هذا الكود للمدرس',
    'refresh_qr': 'تحديث الكود',
    'download_qr': 'حفظ الكود',

    // Schedule
    'schedule': 'الجدول',
    'subject': 'المادة',
    'date': 'التاريخ',
    'time': 'الوقت',
    'center': 'المركز',
    'no_schedule': 'لا توجد جداول متاحة',
    'search_schedule': 'بحث في الجداول',

    // Announcements
    'announcement': 'إعلان',
    'no_announcements': 'لا توجد إعلانات جديدة',
    'search_announcements': 'بحث في الإعلانات',
    'important': 'مهم',
    'general': 'عام',
    'exam': 'امتحان',
    'assignment': 'واجب',

    // Settings
    'theme': 'المظهر',
    'language': 'اللغة',
    'notifications': 'الإشعارات',
    'about': 'حول التطبيق',
    'version': 'الإصدار',
    'light_mode': 'الوضع الفاتح',
    'dark_mode': 'الوضع المظلم',
    'system_mode': 'وضع النظام',
    'arabic': 'العربية',
    'english': 'English',

    // Common
    'save': 'حفظ',
    'cancel': 'إلغاء',
    'confirm': 'تأكيد',
    'delete': 'حذف',
    'edit': 'تعديل',
    'search': 'بحث',
    'filter': 'تصفية',
    'clear': 'مسح',
    'loading': 'جاري التحميل...',
    'error': 'خطأ',
    'success': 'نجح',
    'warning': 'تحذير',
    'info': 'معلومات',
    'retry': 'إعادة المحاولة',
    'no_data': 'لا توجد بيانات',
    'network_error': 'خطأ في الاتصال',
    'try_again': 'حاول مرة أخرى',

    // Validation
    'required_field': 'هذا الحقل مطلوب',
    'invalid_email': 'البريد الإلكتروني غير صحيح',
    'password_too_short': 'كلمة المرور قصيرة جداً',
    'passwords_dont_match': 'كلمات المرور غير متطابقة',
    'invalid_phone': 'رقم الهاتف غير صحيح',
    'invalid_national_id': 'الرقم القومي غير صحيح',
    'username_taken': 'اسم المستخدم مستخدم بالفعل',
    'email_taken': 'البريد الإلكتروني مستخدم بالفعل',

    // Status
    'pending_approval': 'بانتظار الموافقة',
    'approved': 'موافق عليه',
    'rejected': 'مرفوض',
    'active': 'نشط',
    'inactive': 'غير نشط',

    // Notifications
    'account_approved': 'تم الموافقة على حسابك',
    'account_rejected': 'تم رفض حسابك',
    'new_announcement': 'إعلان جديد',
    'schedule_changed': 'تم تغيير الجدول',
    'attendance_recorded': 'تم تسجيل الحضور',

    // Centers
    'center_main': 'المركز الرئيسي',
    'center_university': 'مركز الجامعة',
    'center_residential': 'مركز الأحياء السكنية',
    'center_downtown': 'مركز وسط البلد',
    'center_suburbs': 'مركز الضواحي',
  };

  // English Translations
  static const Map<String, String> en = {
    // App Name
    'app_name': 'Ahmed Sami - Special One',
    'app_subtitle': 'Student Attendance Management Platform',

    // Authentication
    'login': 'Login',
    'register': 'Create Account',
    'logout': 'Logout',
    'email': 'Email',
    'password': 'Password',
    'confirm_password': 'Confirm Password',
    'forgot_password': 'Forgot Password?',
    'dont_have_account': "Don't have an account?",
    'already_have_account': 'Already have an account?',
    'login_success': 'Login successful',
    'login_error': 'Login failed',
    'register_success': 'Account created successfully',
    'register_error': 'Account creation failed',

    // Registration Form
    'full_name': 'Full Name',
    'username': 'Username',
    'national_id': 'National ID / Birth Certificate',
    'student_phone': 'Student Phone',
    'parent_phone': 'Parent Phone',
    'education_stage': 'Education Stage',
    'age': 'Age',
    'learning_center': 'Learning Center',
    'select_stage': 'Select Stage',
    'select_center': 'Select Center',
    'elementary': 'Elementary',
    'middle': 'Middle School',
    'high': 'High School',
    'university': 'University',

    // Dashboard
    'dashboard': 'Dashboard',
    'welcome': 'Welcome',
    'attendance_qr': 'Attendance QR',
    'lesson_schedule': 'Lesson Schedule',
    'announcements': 'Announcements',
    'teacher_news': 'Teacher News',
    'settings': 'Settings',

    // QR Code
    'qr_code': 'QR Code',
    'show_to_teacher': 'Show this code to teacher',
    'refresh_qr': 'Refresh QR',
    'download_qr': 'Download QR',

    // Schedule
    'schedule': 'Schedule',
    'subject': 'Subject',
    'date': 'Date',
    'time': 'Time',
    'center': 'Center',
    'no_schedule': 'No schedule available',
    'search_schedule': 'Search schedule',

    // Announcements
    'announcement': 'Announcement',
    'no_announcements': 'No new announcements',
    'search_announcements': 'Search announcements',
    'important': 'Important',
    'general': 'General',
    'exam': 'Exam',
    'assignment': 'Assignment',

    // Settings
    'theme': 'Theme',
    'language': 'Language',
    'notifications': 'Notifications',
    'about': 'About',
    'version': 'Version',
    'light_mode': 'Light Mode',
    'dark_mode': 'Dark Mode',
    'system_mode': 'System Mode',
    'arabic': 'العربية',
    'english': 'English',

    // Common
    'save': 'Save',
    'cancel': 'Cancel',
    'confirm': 'Confirm',
    'delete': 'Delete',
    'edit': 'Edit',
    'search': 'Search',
    'filter': 'Filter',
    'clear': 'Clear',
    'loading': 'Loading...',
    'error': 'Error',
    'success': 'Success',
    'warning': 'Warning',
    'info': 'Info',
    'retry': 'Retry',
    'no_data': 'No data available',
    'network_error': 'Network error',
    'try_again': 'Try again',

    // Validation
    'required_field': 'This field is required',
    'invalid_email': 'Invalid email address',
    'password_too_short': 'Password is too short',
    'passwords_dont_match': 'Passwords do not match',
    'invalid_phone': 'Invalid phone number',
    'invalid_national_id': 'Invalid national ID',
    'username_taken': 'Username is already taken',
    'email_taken': 'Email is already taken',

    // Status
    'pending_approval': 'Pending Approval',
    'approved': 'Approved',
    'rejected': 'Rejected',
    'active': 'Active',
    'inactive': 'Inactive',

    // Notifications
    'account_approved': 'Your account has been approved',
    'account_rejected': 'Your account has been rejected',
    'new_announcement': 'New announcement',
    'schedule_changed': 'Schedule has changed',
    'attendance_recorded': 'Attendance recorded',

    // Centers
    'center_main': 'Main Center',
    'center_university': 'University Center',
    'center_residential': 'Residential Center',
    'center_downtown': 'Downtown Center',
    'center_suburbs': 'Suburbs Center',
  };

  static String translate(String key, Locale locale) {
    final translations = locale.languageCode == 'ar' ? ar : en;
    return translations[key] ?? key;
  }
}

