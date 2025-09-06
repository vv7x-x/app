import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/app_colors.dart';

class LogoWidget extends StatelessWidget {
  final double? size;
  final bool showSubtitle;
  final Color? textColor;

  const LogoWidget({
    super.key,
    this.size,
    this.showSubtitle = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Icon
        Container(
          width: size ?? 80.w,
          height: size ?? 80.w,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.school,
            color: Colors.white,
            size: (size ?? 80.w) * 0.5,
          ),
        ),
        
        if (showSubtitle) ...[
          SizedBox(height: 16.h),
          
          // App Name
          Text(
            'أحمد سامي',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: textColor ?? AppColors.primary,
              fontFamily: 'ArefRuqaa',
            ),
          ),
          
          SizedBox(height: 4.h),
          
          // Subtitle
          Text(
            'سبشيال وان',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: textColor ?? AppColors.secondary,
              fontFamily: 'ArefRuqaa',
            ),
          ),
          
          SizedBox(height: 8.h),
          
          // Description
          Text(
            'منصة إدارة حضور الطلاب',
            style: TextStyle(
              fontSize: 14.sp,
              color: textColor ?? AppColors.grey600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

class LogoIconWidget extends StatelessWidget {
  final double? size;
  final Color? color;

  const LogoIconWidget({
    super.key,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? 40.w,
      height: size ?? 40.w,
      decoration: BoxDecoration(
        color: color ?? AppColors.primary,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(
        Icons.school,
        color: Colors.white,
        size: (size ?? 40.w) * 0.5,
      ),
    );
  }
}

