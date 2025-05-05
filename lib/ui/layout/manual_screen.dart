import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:greenovate/core/constants/app_assets.dart';
import 'package:greenovate/core/constants/app_colors.dart';
import 'package:greenovate/core/constants/app_styles.dart';
import 'package:greenovate/core/models/actuators_model.dart';

class ManualScreen extends StatefulWidget {
  const ManualScreen({super.key});

  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen> {
  bool _manualModeEnabled = false;
  String? espData ;
  final List<Actuator> _actuators = [
    MultiStageActuator(
      name: "Grow Lights",
      image: AppAssets.lightAct,
      stages: [
        Stage("Off", "Off"),
        Stage("Blue", "Blue Spectrum"),
        Stage("Red", "Red Spectrum"),
        Stage("Full", "Full Spectrum"),
        Stage("UV", "UV Boost"),
      ],
    ),
    SimpleActuator(
      name: "Water Pump",
      image: AppAssets.pumpAct,
    ),
    SimpleActuator(
      name: "Fan",
      image: AppAssets.fanAct,
    ),
    SimpleActuator(
      name: "Curtain",
      image: AppAssets.curtainAct,
    ),
    SimpleActuator(
      name: "Air Conditioning",
      image: AppAssets.airAct,
    ),
    SimpleActuator(
      name: "Nozzle",
      image: AppAssets.nozzleAct,
    ),
  ];

  void _toggleManualMode(bool value) {
    setState(() {
      _manualModeEnabled = value;
      if (!value) {
        for (var actuator in _actuators) {
          actuator.reset();
        }
      }
    });
  }

  void _changeActuatorState(int index, [bool? value]) {
    if (!_manualModeEnabled) return;
    setState(() {
     
      if (value != null) {
        _actuators[index].setState(value);
      } else {
        _actuators[index].toggle();
      }
       espData =  _actuators.map((e) => e.isOn ? "1" : "0").join();
      print(espData);
    });
  }

  void _selectGrowLightStage(int stageIndex) {
    final growLights = _actuators[0] as MultiStageActuator;
    setState(() => growLights.selectStage(stageIndex));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            
            Container(
              height: 60.h,
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
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
                    value: _manualModeEnabled,
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
              child: _manualModeEnabled
                  ? _buildControlsGrid()
                  : _buildDisabledState(),
            ),
          ],
        ),
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      color: actuator.isOn ? AppColors.activeColor : AppColors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        splashColor: AppColors.primary,
        onTap: () => actuator is MultiStageActuator
            ? _showStageSelectionDialog(actuator)
            : _changeActuatorState(index, !actuator.isOn),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset(
                  actuator.image,
                  color: actuator.isOn ? AppColors.white : AppColors.black,
                  width: 85.w,
                  height: 85.h,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                actuator.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: actuator.isOn ? AppColors.white : AppColors.black,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              if (actuator is MultiStageActuator)
                _buildStageIndicator(actuator)
              else
                Switch.adaptive(
                  value: actuator.isOn,
                  onChanged: (value) => _changeActuatorState(index, value),
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
  }

  Widget _buildStageIndicator(MultiStageActuator actuator) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        actuator.currentStageName,
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
                      _selectGrowLightStage(actuator.stages.indexOf(stage));
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
