

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenovate/core/constants/app_colors.dart';
import 'package:greenovate/core/constants/app_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.prefixIcon,
    this.elevation,
    required this.onTap,
  });
  final String text ;
  final Color backgroundColor ;
  final Color textColor ;
  final String? prefixIcon;
  final double? elevation;
  final VoidCallback onTap ;

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      
              style: ElevatedButton.styleFrom(
                elevation: elevation,
                backgroundColor: backgroundColor,
                minimumSize: Size(360.w, 50.h),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: AppColors.black,
                    width: 1.w,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              onPressed: onTap,
              child: 
               prefixIcon != null ? 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    prefixIcon!,
                    
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(text,style: AppStyles.sairaCondensed16white.copyWith(fontSize: 20.sp,color:textColor )),
                ],
              ): Text(text,style: AppStyles.sairaCondensed16white.copyWith(fontSize: 20.sp,color:textColor )),
            );
  }
}