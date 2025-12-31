import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:carbon_krishi_app/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _loaderRotation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _loaderRotation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _initAndNavigate();
  }

  Future<void> _initAndNavigate() async {
    try {
      await _prepareGpsServices().timeout(const Duration(seconds: 6));
    } catch (_) {
      // ignore errors/timeouts
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.registration);
  }

  Future<void> _prepareGpsServices() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      final backendBase = Uri.parse('http://127.0.0.1:8000');
      final ndviUri = backendBase.replace(
        path: '/api/satellite/ndvi',
        queryParameters: {
          'latitude': pos.latitude.toString(),
          'longitude': pos.longitude.toString(),
        },
      );

      final resp = await http.get(ndviUri).timeout(const Duration(seconds: 4));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setDouble('last_latitude', pos.latitude);
        await prefs.setDouble('last_longitude', pos.longitude);
        if (data.containsKey('ndvi')) {
          final ndvi = (data['ndvi'] is num)
              ? (data['ndvi'] as num).toDouble()
              : double.tryParse(data['ndvi'].toString()) ?? 0.0;
          await prefs.setDouble('last_ndvi', ndvi);
        }
        await prefs.setString('last_ndvi_payload', jsonEncode(data));
      }
    } catch (e) {
      // swallow any errors
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF143A2A), Color(0xFF5F8F63)],
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha((0.14 * 255).toInt()),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.eco,
                          size: 44,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'CarbonTracker',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'AI-Powered Environmental Monitoring',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 4),
                Column(
                  children: [
                    RotationTransition(
                      turns: _loaderRotation,
                      child: const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Preparing GPS services...',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
