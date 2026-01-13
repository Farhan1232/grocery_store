// Signup Screen
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:third/controller/auth_controller.dart';

class SignupScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final authController = Get.find<AuthController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up'), backgroundColor: Colors.orange, elevation: 0),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Create Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Sign up to get started', style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 30),
            _buildTextField(nameController, 'Full Name', Icons.person),
            SizedBox(height: 20),
            _buildTextField(emailController, 'Email', Icons.email),
            SizedBox(height: 20),
            _buildTextField(phoneController, 'Phone', Icons.phone),
            SizedBox(height: 20),
            _buildTextField(passwordController, 'Password', Icons.lock, isPassword: true),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                if (await authController.register(nameController.text, emailController.text, passwordController.text, phoneController.text)) {
                  Get.back();
                }
              },
              child: Padding(padding: EdgeInsets.all(16), child: Text('SIGN UP', style: TextStyle(fontSize: 16))),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
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

