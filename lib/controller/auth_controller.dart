// Controllers
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:third/login_screen.dart';
import 'package:third/services/Api_services.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var userId = 0.obs;
  var userName = ''.obs;
  
  Future<bool> register(String name, String email, String password, String phone) async {
    try {
      final result = await ApiService.register(name, email, password, phone);
      if (result['success']) {
        Get.snackbar('Success', 'Registration successful!', backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      }
      Get.snackbar('Error', result['message'], backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Registration failed', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }
  
  Future<bool> login(String email, String password) async {
    try {
      final result = await ApiService.login(email, password);
      if (result['success']) {
        isLoggedIn.value = true;
        userId.value = result['data']['id'];
        userName.value = result['data']['name'];
        return true;
      }
      Get.snackbar('Error', result['message'], backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Login failed', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }
  
  void logout() {
    isLoggedIn.value = false;
    userId.value = 0;
    userName.value = '';
    Get.offAll(() => LoginScreen());
  }
}

class CartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;
  
  void addToCart(Map<String, dynamic> product) {
    // Convert price to double if it's a string
    final price = product['price'] is String 
        ? double.parse(product['price'].toString()) 
        : (product['price'] as num).toDouble();
    
    // Convert id to int if it's a string
    final id = product['id'] is String 
        ? int.parse(product['id'].toString()) 
        : product['id'] as int;
    
    var existingIndex = cartItems.indexWhere((item) => item['id'] == id);
    if (existingIndex >= 0) {
      cartItems[existingIndex]['quantity']++;
    } else {
      cartItems.add({
        'id': id,
        'name': product['name'],
        'price': price,
        'image': product['image'],
        'description': product['description'] ?? '',
        'quantity': 1
      });
    }
    Get.snackbar('Added', '${product['name']} added to cart', backgroundColor: Colors.green, colorText: Colors.white);
  }
  
  void removeFromCart(int index) {
    cartItems.removeAt(index);
  }
  
  void updateQuantity(int index, int quantity) {
    if (quantity <= 0) {
      cartItems.removeAt(index);
    } else {
      cartItems[index]['quantity'] = quantity;
    }
  }
  
  double get total {
    return cartItems.fold(0.0, (sum, item) {
      final price = item['price'] is String 
          ? double.parse(item['price'].toString()) 
          : (item['price'] as num).toDouble();
      final quantity = item['quantity'] as int;
      return sum + (price * quantity);
    });
  }
  
  void clearCart() {
    cartItems.clear();
  }
}

class ProductController extends GetxController {
  var products = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }
  
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final data = await ApiService.getProducts();
      products.value = data.cast<Map<String, dynamic>>();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load products', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => Get.off(() => LoginScreen()));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange, Colors.deepOrange],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant_menu, size: 100, color: Colors.white),
              SizedBox(height: 20),
              Text('Women Accessories App', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

