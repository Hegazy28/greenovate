import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenovate/core/constants/app_colors.dart';
import 'package:greenovate/core/constants/app_styles.dart';
import 'package:greenovate/core/models/crops_data.dart';

class CropsScreen extends StatefulWidget {
  const CropsScreen({super.key});

  @override
  State<CropsScreen> createState() => _CropsScreenState();
}

class _CropsScreenState extends State<CropsScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: AppColors.bgColor),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              height: 60.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(24.r),
                      bottomLeft: Radius.circular(24.r)),
                  color: AppColors.primary),
              child: Center(
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: 'Selected Crop : ',
                        style: AppStyles.sairaCondensed24white
                            .copyWith(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: 'Tomato', style: AppStyles.sairaCondensed24white),
                  ]),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: FadeInUp(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: AppColors.solidGray,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: GridView.builder(
                    itemCount: CropsData.crops.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.7, crossAxisCount: 2),
                    itemBuilder: (context, index) => Container(
                      clipBehavior: Clip.antiAlias,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: AppColors.primary),
                      child: Column(
                        children: [
                          Expanded(
                              child:
                                  Image.asset(CropsData.crops[index]["image"])),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            CropsData.crops[index]["name"],
                            style: AppStyles.sairaCondensed16white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
