import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/app_colors.dart';
import '../../../../config/localization.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_button.dart';
import '../../../../core/widgets/logo_widget.dart';
import '../../../../models/student_model.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _studentPhoneController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  String _selectedStage = EducationStage.middle.value;
  String _selectedCenter = LearningCenter.main.value;
  int _selectedAge = 15;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _nationalIdController.dispose();
    _studentPhoneController.dispose();
    _parentPhoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.translate('register_success', locale)),
                backgroundColor: AppColors.success,
              ),
            );
            context.goToLogin();
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
      appBar: AppBar(
        title: Text(AppLocalizations.translate('register', locale)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goToLogin(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                const LogoWidget(),
                
                SizedBox(height: 24.h),
                
                // Title
                Text(
                  AppLocalizations.translate('register', locale),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 8.h),
                
                Text(
                  'املأ البيانات التالية لإنشاء حساب جديد',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.grey600,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 32.h),
                
                // Full Name
                CustomTextField(
                  controller: _fullNameController,
                  labelText: AppLocalizations.translate('full_name', locale),
                  prefixIcon: Icons.person_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.translate('required_field', locale);
                    }
                    if (value.length < 5) {
                      return 'الاسم يجب أن يكون 5 أحرف على الأقل';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 16.h),
                
                // Username
                CustomTextField(
                  controller: _usernameController,
                  labelText: AppLocalizations.translate('username', locale),
                  prefixIcon: Icons.alternate_email_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.translate('required_field', locale);
                    }
                    if (value.length < 3) {
                      return 'اسم المستخدم يجب أن يكون 3 أحرف على الأقل';
                    }
                    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                      return 'اسم المستخدم يجب أن يحتوي على أحرف وأرقام فقط';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 16.h),
                
                // National ID
                CustomTextField(
                  controller: _nationalIdController,
                  labelText: AppLocalizations.translate('national_id', locale),
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.credit_card_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.translate('required_field', locale);
                    }
                    if (value.length < 10) {
                      return 'الرقم القومي يجب أن يكون 10 أرقام على الأقل';
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 16.h),
                
                // Student Phone
                CustomTextField(
                  controller: _studentPhoneController,
                  labelText: AppLocalizations.translate('student_phone', locale),
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.translate('required_field', locale);
                    }
                    if (!RegExp(r'^[0-9+\-\s()]+$').hasMatch(value)) {
                      return AppLocalizations.translate('invalid_phone', locale);
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 16.h),
                
                // Parent Phone
                CustomTextField(
                  controller: _parentPhoneController,
                  labelText: AppLocalizations.translate('parent_phone', locale),
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.translate('required_field', locale);
                    }
                    if (!RegExp(r'^[0-9+\-\s()]+$').hasMatch(value)) {
                      return AppLocalizations.translate('invalid_phone', locale);
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 16.h),
                
                // Education Stage
                DropdownButtonFormField<String>(
                  value: _selectedStage,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.translate('education_stage', locale),
                    prefixIcon: const Icon(Icons.school_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: EducationStage.values.map((stage) {
                    return DropdownMenuItem(
                      value: stage.value,
                      child: Text(
                        locale.languageCode == 'ar' ? stage.arabicName : stage.englishName,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStage = value!;
                    });
                  },
                ),
                
                SizedBox(height: 16.h),
                
                // Age
                CustomTextField(
                  controller: TextEditingController(text: _selectedAge.toString()),
                  labelText: AppLocalizations.translate('age', locale),
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.cake_outlined,
                  readOnly: true,
                  onTap: () => _showAgePicker(),
                ),
                
                SizedBox(height: 16.h),
                
                // Learning Center
                DropdownButtonFormField<String>(
                  value: _selectedCenter,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.translate('learning_center', locale),
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: LearningCenter.values.map((center) {
                    return DropdownMenuItem(
                      value: center.value,
                      child: Text(
                        locale.languageCode == 'ar' ? center.arabicName : center.englishName,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCenter = value!;
                    });
                  },
                ),
                
                SizedBox(height: 16.h),
                
                // Email
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
                
                // Password
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
                
                SizedBox(height: 16.h),
                
                // Confirm Password
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: AppLocalizations.translate('confirm_password', locale),
                  obscureText: _obscureConfirmPassword,
                  prefixIcon: Icons.lock_outlined,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.translate('required_field', locale);
                    }
                    if (value != _passwordController.text) {
                      return AppLocalizations.translate('passwords_dont_match', locale);
                    }
                    return null;
                  },
                ),
                
                SizedBox(height: 32.h),
                
                // Register Button
                LoadingButton(
                  onPressed: _handleRegister,
                  isLoading: authState.isLoading,
                  child: Text(
                    AppLocalizations.translate('register', locale),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.translate('already_have_account', locale),
                      style: TextStyle(
                        color: AppColors.grey600,
                        fontSize: 14.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.goToLogin(),
                      child: Text(
                        AppLocalizations.translate('login', locale),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 16.h),
                
                // Status Info
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.info.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.info,
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'بعد التسجيل ستكون الحالة: «بانتظار الموافقة»',
                          style: TextStyle(
                            color: AppColors.info,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref.read(authProvider.notifier).registerStudent(
          fullName: _fullNameController.text.trim(),
          username: _usernameController.text.trim(),
          nationalId: _nationalIdController.text.trim(),
          studentPhone: _studentPhoneController.text.trim(),
          parentPhone: _parentPhoneController.text.trim(),
          stage: _selectedStage,
          age: _selectedAge,
          center: _selectedCenter,
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

  void _showAgePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.translate('age', ref.read(localeProvider))),
        content: SizedBox(
          height: 200.h,
          child: ListView.builder(
            itemCount: 50,
            itemBuilder: (context, index) {
              final age = index + 10;
              return ListTile(
                title: Text(age.toString()),
                selected: age == _selectedAge,
                onTap: () {
                  setState(() {
                    _selectedAge = age;
                  });
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

