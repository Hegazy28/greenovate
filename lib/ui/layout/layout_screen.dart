import 'package:flutter/material.dart';
import 'package:greenovate/core/constants/app_assets.dart';
import 'package:greenovate/core/constants/app_colors.dart';
import 'package:greenovate/ui/layout/crops_screen.dart';
import 'package:greenovate/ui/layout/home_screen.dart';
import 'package:greenovate/ui/layout/manual_screen.dart';
import 'package:local_auth/local_auth.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticated = false;
  bool _isLoading = true;
  String? _errorMessage;
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    HomeScreen(),
    ManualScreen(),
    CropsScreen(),
  ];

  Future<void> _authenticateUser() async {
    try {
      final bool canAuthenticate =
          await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Authentication not available on this device';
          _isAuthenticated = true; // Bypass auth if not supported
        });
        return;
      }

      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Authenticate to access the app',
        options: const AuthenticationOptions(
          biometricOnly: false,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      setState(() {
        _isAuthenticated = didAuthenticate;
        _isLoading = false;
        _errorMessage = didAuthenticate ? null : 'Authentication failed';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Authentication error occurred';
      });
    }
  }

  Future<void> _retryAuthentication() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    await _authenticateUser();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authenticateUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return _buildAuthGate();
    }

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: BottomNavigationBar(
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.black,
          currentIndex: _currentIndex,
          onTap: (value) => setState(() => _currentIndex = value),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.primary,
          items: const [
            BottomNavigationBarItem(
              
                icon: ImageIcon(AssetImage(AppAssets.sensors)), label: "Sensors"),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(AppAssets.manual)), label: "Manual"),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage(AppAssets.crops)), label: "Crops"),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
    );
  }

  Widget _buildAuthGate() {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 20),
              Text(
                'Secure Access',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _errorMessage ?? 'Verify your identity to continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.black.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 30),
              if (_isLoading)
                CircularProgressIndicator(color: AppColors.primary)
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  onPressed: _retryAuthentication,
                  child: const Text(
                    'Authenticate',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
