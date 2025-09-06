import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/localization.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_button.dart';
import '../../../../core/widgets/logo_widget.dart';
import '../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final authState = ref.watch(authProvider);

    ref.listen<AsyncValue<void>>(authProvider, (previous, next) {
      next.whenOrNull(
        data: (data) {
          if (data != null) {
            context.goToDashboard();
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: AppColors.error,
            ),
          );
        },
      );
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 60.h),
                
                // Logo
                const LogoWidget(),
                
                SizedBox(height: 48.h),
                
                // Title
                Text(
                  AppLocalizations.translate('login', locale),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 8.h),
                
                Text(
                  AppLocalizations.translate('app_subtitle', locale),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.grey600,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 48.h),
                
                // Email Field
                CustomTextField(
                  controller: _emailController,
                  labelText: AppLocalizations.translate('email', locale),
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.translate('required_field', locale);
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return AppLocalizations.translate('invalid_email', locale);
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 16.h),
                
                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  labelText: AppLocalizations.translate('password', locale),
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outlined,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.translate('required_field', locale);
                    }
                    if (value.length < 6) {
                      return AppLocalizations.translate('password_too_short', locale);
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 8.h),
                
                // Forgot Password
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement forgot password
                    },
                    child: Text(
                      AppLocalizations.translate('forgot_password', locale),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 32.h),
                
                // Login Button
                LoadingButton(
                  onPressed: _handleLogin,
                  isLoading: authState.isLoading,
                  child: Text(
                    AppLocalizations.translate('login', locale),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // Alternative Login
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.grey300,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'أو',
                        style: TextStyle(
                          color: AppColors.grey500,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.grey300,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 24.h),
                
                // Username & National ID Login
                OutlinedButton(
                  onPressed: _showUsernameLoginDialog,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    'تسجيل الدخول بالاسم والرقم القومي',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                SizedBox(height: 32.h),
                
                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.translate('dont_have_account', locale),
                      style: TextStyle(
                        color: AppColors.grey600,
                        fontSize: 14.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.goToRegister(),
                      child: Text(
                        AppLocalizations.translate('register', locale),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref.read(authProvider.notifier).signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  void _showUsernameLoginDialog() {
    final usernameController = TextEditingController();
    final nationalIdController = TextEditingController();
    final locale = ref.read(localeProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.translate('login', locale)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: usernameController,
              labelText: AppLocalizations.translate('username', locale),
              prefixIcon: Icons.person_outlined,
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              controller: nationalIdController,
              labelText: AppLocalizations.translate('national_id', locale),
              keyboardType: TextInputType.number,
              prefixIcon: Icons.credit_card_outlined,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.translate('cancel', locale)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(authProvider.notifier).signInWithUsernameAndNationalId(
                username: usernameController.text.trim(),
                nationalId: nationalIdController.text.trim(),
              );
            },
            child: Text(AppLocalizations.translate('login', locale)),
          ),
        ],
      ),
    );
  }
}

