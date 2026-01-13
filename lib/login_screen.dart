// Login Screen
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:third/controller/auth_controller.dart';
import 'package:third/home_screen.dart';
import 'package:third/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authController = Get.put(AuthController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 50),
              Icon(Icons.restaurant_menu, size: 80, color: Colors.orange),
              SizedBox(height: 30),
              Text('Welcome Back!', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Login to your account', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)),
              SizedBox(height: 40),
              _buildTextField(emailController, 'Email', Icons.email),
              SizedBox(height: 20),
              _buildTextField(passwordController, 'Password', Icons.lock, isPassword: true),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (await authController.login(emailController.text, passwordController.text)) {
                    Get.offAll(() => HomeScreen());
                  }
                },
                child: Padding(padding: EdgeInsets.all(16), child: Text('LOGIN', style: TextStyle(fontSize: 16))),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.to(() => SignupScreen()),
                child: Text('Don\'t have an account? Sign Up', style: TextStyle(color: Colors.orange)),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.orange),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
