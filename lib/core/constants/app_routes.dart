import 'package:flutter/material.dart';
import 'package:greenovate/ui/layout/home_screen.dart';
import 'package:greenovate/ui/login_screen.dart';

class AppRoutes {
  static Route login() {
    return MaterialPageRoute(
      builder: (context) => LoginScreen(),
    );
  }

   static Route home() {
    return MaterialPageRoute(
      builder: (context) => HomeScreen(),
    );
  }


  //  static Route manaual() {
  //   return MaterialPageRoute(
  //     builder: (context) => LoginScreen(),
  //   );
  // }

  //  static Route sensors() {
  //   return MaterialPageRoute(
  //     builder: (context) => LoginScreen(),
  //   );
  // }
  //  static Route details() {
  //   return MaterialPageRoute(
  //     builder: (context) => CropsDetails(),
  //   );
  // }
}
