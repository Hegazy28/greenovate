import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenovate/core/constants/app_colors.dart';
import 'package:greenovate/core/models/sensor_model.dart';

class SensorCard extends StatelessWidget {
  const SensorCard({super.key,  required this.model});
  final SensorModel model;
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      height: 500.h,
      width: 500.w,
      decoration: BoxDecoration(
        color: Color(0xff6ECF77),
        
        
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.black,
          width: 1.w,
        ),
       
      ),
     
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 80.h,
              width: 80.w,
              child: Image.asset(model.image)),
              SizedBox(width: 4,),
            Text(model.name,textAlign: TextAlign.end,),
          ],
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     Text("${model.value}"),
        //     Text(model.unit),
        //   ],
        // ),
      ],),);
  }
}