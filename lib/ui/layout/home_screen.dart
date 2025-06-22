import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenovate/core/constants/app_colors.dart';
import 'package:greenovate/core/constants/app_styles.dart';
import 'package:greenovate/core/models/sensor_model.dart';
import 'package:greenovate/core/widgets/arc.dart';
import 'package:greenovate/firebase/firebase_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double selectedValue = 0.0;
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: AppColors.bgColor),
      child: SafeArea(
        child: Column(
          children: [
            BounceInDown(
              child: Container(
                clipBehavior: Clip.antiAlias,
                height: 380.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40)),
                    color: AppColors.primary),
                child: SafeArea(
                  child: StreamBuilder<Object>(
                    stream: FirebaseHelper.listenToData(
                                  SensorModel.Sensors[_selectedIndex].path),
                    builder: (context, snapshot) {
                      return CircularArc(
                        progress: snapshot.hasData
                            ? snapshot.data as double
                            : 0.0,
                        unit: SensorModel.Sensors[_selectedIndex].unit,
                      );
                    }
                  ),
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
                            ? AppColors.primary
                            : Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    width: 150.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: 55.h,
                            width: 55.w,
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
                              fontSize: 18.sp),
                          textAlign: TextAlign.end,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StreamBuilder<double>(
                              stream: FirebaseHelper.listenToData(
                                  SensorModel.Sensors[index].path),
                              builder: (context, snapshot) {
                                 
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator(
                                    color: AppColors.white,
                                  );
                                }
                                // if (snapshot.connectionState ==
                                //     ConnectionState.waiting) {
                                //   return Text(
                                //     "No data",
                                //     style: AppStyles.sairaCondensed24white
                                //         .copyWith(
                                //             fontSize: 30,
                                //             color: _selectedIndex == index
                                //                 ? Colors.white
                                //                 : Colors.black),
                                //   );
                                // }
                                // Assuming snapshot.data is the value you want to display
                                //print("Data: ${snapshot.data!}");
                                return Text(
                                  "${snapshot.data!}",
                                  style: AppStyles.sairaCondensed24white
                                      .copyWith(
                                          fontSize: 30,
                                          color: _selectedIndex == index
                                              ? Colors.white
                                              : Colors.black),
                                );
                              },
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
      ),
    );
  }
}
