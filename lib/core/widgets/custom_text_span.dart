
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:greenovate/core/constants/app_styles.dart';

class CustomTextSpan extends StatelessWidget {
  const CustomTextSpan({super.key ,  this.preText ='' , required this.postText,required this.onTap});
  final String? preText ;
  final String? postText ;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(
                text: preText,
                style: AppStyles.sairaCondensed16white,
                children: [
                  TextSpan(
                    text: postText,
                    style: AppStyles.sairaCondensed16white,
                    recognizer: TapGestureRecognizer()
                      ..onTap = onTap,
                  ),
                ],
              ));
  }
}