import 'package:flutter/material.dart';
import 'package:greenovate/core/constants/app_colors.dart';

class Customtextfield extends StatefulWidget {
  const Customtextfield({
    super.key,
    required this.lable,
    required this.prefixIcon,
    this.suffixIcon,
    required this.type,
  });
  final String lable;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final TextInputType type ;

  @override
  State<Customtextfield> createState() => _CustomtextfieldState();
}

class _CustomtextfieldState extends State<Customtextfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        color: AppColors.white,
      ),
      
      cursorColor: AppColors.solidGray,
      keyboardType:widget.type,
      decoration: InputDecoration(
        
        prefixIcon: Icon(
          widget.prefixIcon,
          color: AppColors.solidGray,
        ),
        suffixIcon: Icon(
          widget.suffixIcon,
          color: AppColors.solidGray,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.solidGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.solidGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.solidGray),
        ),
        labelText: widget.lable,
        labelStyle: TextStyle(
          color: AppColors.solidGray,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.solidGray),
        ),
      ),
    );
  }
}
