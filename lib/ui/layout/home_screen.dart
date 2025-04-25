import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenovate/core/constants/app_colors.dart';
import 'package:greenovate/core/constants/app_styles.dart';
import 'package:greenovate/core/models/sensor_model.dart';
import 'package:greenovate/core/widgets/arc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10 ),
      decoration: BoxDecoration(color: AppColors.bgColor),
      child: Column(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            height: 380.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40)),
                color: AppColors.primary),
            child: SafeArea(
              child: CircularArc(
                progress: SensorModel.Sensors[_selectedIndex].value,
                unit: SensorModel.Sensors[_selectedIndex].unit,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Row(
              children: [
                Text(
                  'Show Sensor status',
                  style: AppStyles.sairaCondensed16white.copyWith(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                width: 20.w,
              ),
              itemCount: SensorModel.Sensors.length,
              padding: EdgeInsets.symmetric(horizontal: 10),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  _selectedIndex = index;
                  setState(() {});
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: _selectedIndex == index
                          ? Color(0xff46634D)
                          : Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  width: 200.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 70.h,
                          width: 70.w,
                          child: Image.asset(
                            SensorModel.Sensors[index].image,
                            color: _selectedIndex == index
                                ? Colors.white
                                : Colors.black,
                          )),
                      Text(
                        SensorModel.Sensors[index].name,
                        style: AppStyles.sairaCondensed16white.copyWith(
                            color: _selectedIndex == index
                                ? Colors.white
                                : Colors.black,
                            fontSize: 20.sp),
                        textAlign: TextAlign.end,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${SensorModel.Sensors[index].value}",
                            style: AppStyles.sairaCondensed24white.copyWith(
                                fontSize: 40,
                                color: _selectedIndex == index
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          Text(SensorModel.Sensors[index].unit,
                              style: AppStyles.sairaCondensed24white.copyWith(
                                  fontSize: 30,
                                  color: _selectedIndex == index
                                      ? Colors.white
                                      : Colors.black)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
