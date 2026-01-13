// Thank You Screen
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:third/home_screen.dart';

class ThankYouScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 100, color: Colors.green),
              SizedBox(height: 24),
              Text('Thank You!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('Your order has been placed successfully', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.grey)),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Get.offAll(() => HomeScreen()),
                child: Padding(padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16), child: Text('BACK TO HOME', style: TextStyle(fontSize: 16))),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}