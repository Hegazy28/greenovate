import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenovate/core/constants/app_assets.dart';
import 'package:greenovate/core/constants/app_colors.dart';
import 'package:greenovate/core/constants/app_routes.dart';
import 'package:greenovate/core/constants/app_styles.dart';
import 'package:greenovate/core/widgets/customTextField.dart';
import 'package:greenovate/core/widgets/custom_button.dart';
import 'package:greenovate/core/widgets/custom_text_span.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.loginBg),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                  minWidth: MediaQuery.of(context).size.width,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      Row(),
                      SizedBox(
                          width: 300.w,
                          height: 300.h,
                          child: Image.asset(AppAssets.logo)),
                      Text(
                        'Welcome Back',
                        style: AppStyles.sairaCondensed24white,
                      ),
                      SizedBox(height: 4),
                      Text('Login to your account',
                          style: AppStyles.sairaCondensed24white),
                      SizedBox(height: 16),
                      Customtextfield(
                        type: TextInputType.emailAddress,
                        lable: 'Email',
                        prefixIcon: Icons.email_rounded,
                      ),
                      SizedBox(height: 16),
                      Customtextfield(
                        type: TextInputType.visiblePassword,
                        lable: 'Password',
                        prefixIcon: Icons.lock_rounded,
                        suffixIcon: Icons.visibility_off_rounded,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomTextSpan(
                            onTap: () {},
                            postText: 'Forget Password ?',
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      CustomButton(
                        onTap: () => Navigator.push(context, AppRoutes.home()),
                        backgroundColor: AppColors.primaryGreen,
                        text: 'Login',
                        textColor: AppColors.white,
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
