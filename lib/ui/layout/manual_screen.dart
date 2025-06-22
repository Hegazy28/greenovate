import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenovate/core/constants/app_assets.dart';
import 'package:greenovate/core/constants/app_colors.dart';
import 'package:greenovate/core/constants/app_styles.dart';
import 'package:greenovate/core/models/actuators_model.dart';
import 'package:greenovate/firebase/firebase_helper.dart';

class ManualScreen extends StatefulWidget {
  const ManualScreen({super.key});

  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  late List<int> act;
  final List<Actuator> _actuators = [
    MultiStageActuator(
      name: "Grow Lights",
      image: AppAssets.lightAct,
      stages: [
        Stage("Off", "Off"),
        Stage("Stage1", "Half Red Spectrum"),
        Stage("Stage2", "Half Blue & Red Spectrum"),
        Stage("Stage3", "Full Red Spectrum"),
        Stage("Stage4", "Full Spectrum"),
      ],
    ),
    SimpleActuator(
      name: "Water Pump",
      image: AppAssets.pumpAct,
      stages: [
        Stage("off", "false"),
        Stage("on", "true"),
      ],
    ),
    SimpleActuator(
      name: "Fan",
      image: AppAssets.fanAct,
      stages: [
        Stage("off", "false"),
        Stage("on", "true"),
      ],
    ),
    MultiStageActuator(
      name: "Curtain",
      image: AppAssets.curtainAct,
      stages: [
        Stage("Up", "Going Up"),
        Stage("Down", "Going Down"),
        Stage("Stop", "Stopped"),
      ],
    ),
    SimpleActuator(
      name: "Air Conditioning",
      image: AppAssets.airAct,
      stages: [
        Stage("off", "false"),
        Stage("on", "true"),
      ],
    ),
    SimpleActuator(
      name: "Nozzle",
      image: AppAssets.nozzleAct,
      stages: [
        Stage("off", "false"),
        Stage("on", "true"),
      ],
    ),
  ];

  void _toggleManualMode(bool value) {
    setState(() {
      act[1] = value == true ? 1 : 0;
      int acts = int.parse(act.join(''));
      //   print(" Actssssssssssssss  $acts");
      FirebaseHelper.updateDevices(acts);
    });
  }

  void _resetActuators(bool value) {
    setState(() {
      FirebaseHelper.updateDevices(11000000);
    });
  }

  void _changeActuatorState(int index, [bool? value]) {
    act[index] = value == true ? 1 : 0;
    int acts = int.parse(act.join(''));
    // print(" Actssssssssssssss  $acts");
    FirebaseHelper.updateDevices(acts);
  }

  void _selectGrowLightStage(int stageIndex, Actuator actuator) {
    if (actuator.name == "Grow Lights") {
      final growLights = _actuators[0] as MultiStageActuator;
      growLights.selectStage(stageIndex);
      if (stageIndex == 0) {
        act[2] = 0;
      } else if (stageIndex == 1) {
        act[2] = 1;
      } else if (stageIndex == 2) {
        act[2] = 2;
      } else if (stageIndex == 3) {
        act[2] = 3;
      } else {
        act[2] = 4;
      }
    } else {
      final growLights = _actuators[3] as MultiStageActuator;
      growLights.selectStage(stageIndex);
      if (stageIndex == 0) {
        act[5] = 1;
      } else if (stageIndex == 1) {
        act[5] = 2;
      } else {
        act[5] = 0;
      }
    }
    int acts = int.parse(act.join(''));

    FirebaseHelper.updateDevices(acts);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: StreamBuilder<List<int>>(
            stream: FirebaseHelper.listenToDeviceChanges(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              }
              //  print("888888888888888888888888 ${snapshot.data![0]}");
              act = snapshot.data!;
              // print("888888888888888888888888 ${act}");
              return Column(
                children: [
                  Container(
                    height: 60.h,
                    padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24.r),
                        bottomRight: Radius.circular(24.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Manual Controls',
                          style: AppStyles.sairaCondensed16white.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Switch.adaptive(
                          value: snapshot.data![1] == 1, //_manualModeEnabled200
                          onChanged: _toggleManualMode,
                          trackOutlineColor:
                              WidgetStateProperty.all(Colors.transparent),
                          trackOutlineWidth: WidgetStatePropertyAll(4),
                          activeColor: Colors.white,
                          activeTrackColor: Colors.green,
                          inactiveTrackColor: AppColors.solidGray,
                          inactiveThumbColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: snapshot.data![1] == 1
                        ? _buildControlsGrid()
                        : _buildDisabledState(),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget _buildControlsGrid() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _actuators.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          mainAxisSpacing: 6.h,
          crossAxisSpacing: 6.w,
        ),
        itemBuilder: (context, index) {
          final actuator = _actuators[index];
          return _buildActuatorCard(actuator, index);
        },
      ),
    );
  }

  Widget _buildActuatorCard(Actuator actuator, int index) {
    return StreamBuilder<List<int>>(
        stream: FirebaseHelper.listenToDeviceChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            color: snapshot.data![index + 2] != 0
                ? AppColors.activeColor
                : AppColors.white,
            child: InkWell(
              borderRadius: BorderRadius.circular(20.r),
              splashColor: AppColors.primary,
              onTap: () => actuator is MultiStageActuator
                  ? _showStageSelectionDialog(actuator)
                  : _changeActuatorState(
                      index + 2, snapshot.data![index + 2] != 1),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Image.asset(
                        actuator.image,
                        color: snapshot.data![index + 2] != 0
                            ? AppColors.white
                            : AppColors.black,
                        width: 85.w,
                        height: 85.h,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      actuator.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: snapshot.data![index + 2] != 0
                            ? AppColors.white
                            : AppColors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    if (actuator is MultiStageActuator)
                      _buildStageIndicator(actuator)
                    else
                      Switch.adaptive(
                        value: snapshot.data![index + 2] ==
                            1, // Assuming 1 means ON
                        onChanged: (value) =>
                            _changeActuatorState(index + 2, value),
                        activeColor: Colors.white,
                        trackOutlineColor: WidgetStateProperty.all(Colors.grey),
                        inactiveTrackColor: AppColors.bgColor,
                        inactiveThumbColor: Colors.black,
                      ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildStageIndicator(MultiStageActuator actuator) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        actuator.stages[actuator.currentStage].name,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  void _showStageSelectionDialog(MultiStageActuator actuator) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.activeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Light Mode',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.h),
                ...actuator.stages.map((stage) {
                  return ListTile(
                    title: Text(
                      stage.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                    subtitle: stage.description != null
                        ? Text(
                            stage.description!,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12.sp,
                            ),
                          )
                        : null,
                    trailing:
                        actuator.currentStage == actuator.stages.indexOf(stage)
                            ? Icon(Icons.check, color: Colors.white)
                            : null,
                    onTap: () {
                      _selectGrowLightStage(
                          actuator.stages.indexOf(stage), actuator);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDisabledState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.touch_app, size: 60.w, color: Colors.grey.shade600),
          SizedBox(height: 16.h),
          Text(
            'Enable manual mode to control devices',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => _toggleManualMode(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Enable Manual Mode',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
