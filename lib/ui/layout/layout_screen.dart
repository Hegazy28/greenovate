import 'package:flutter/material.dart';
import 'package:greenovate/core/constants/app_assets.dart';
import 'package:greenovate/core/constants/app_colors.dart';
import 'package:greenovate/ui/layout/crops_screen.dart';
import 'package:greenovate/ui/layout/home_screen.dart';
import 'package:greenovate/ui/layout/manual_screen.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _curentIndex = 0;
  final List<Widget> taps = [
    HomeScreen(),
    ManualScreen(),
    CropsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: BottomNavigationBar(
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.black,
          currentIndex: _curentIndex,
          onTap: (value) {
            setState(() {
              _curentIndex = value;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.primary,
          items: [
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(AppAssets.sensors)), label: "Home"),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(AppAssets.manual)), label: "Manual"),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(AppAssets.crops)), label: "Crops"),
          ],
        ),
      ),
      body:  IndexedStack(
        index:_curentIndex ,
        children: taps,
      )
      
      
       
    );
  }
}
