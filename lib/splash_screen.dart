import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scan_qr/location.dart';
import 'package:scan_qr/qr_code.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buttonContent(
              'Location',
              onTap: () {
                Get.to(
                  () => LocationDetail(),
                );
              },
            ),
            _buttonContent(
              'Scanner',
              onTap: () {
                Get.to(
                  () => QrCodeScanner(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonContent(String title, {required Function() onTap}) {
    return InkWell(
      onTap: () => onTap.call(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 200,
        width: 200,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
