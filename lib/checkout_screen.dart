// Checkout Screen with Map
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:third/controller/auth_controller.dart';
import 'package:third/services/Api_services.dart';
import 'package:third/thank_you_screen.dart';

class CheckoutScreen extends StatelessWidget {
  final cartController = Get.find<CartController>();
  final authController = Get.find<AuthController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout'), backgroundColor: Colors.orange),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Delivery Location', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, size: 50, color: Colors.orange),
                    SizedBox(height: 8),
                    Text('Latitude: 31.4693° N', style: TextStyle(fontSize: 16)),
                    Text('Longitude: 74.3515° E', style: TextStyle(fontSize: 16)),
                    Text('Sialkot, Pakistan', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text('Order Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            ...cartController.cartItems.map((item) {
              // Convert price to double safely
              final price = item['price'] is String 
                  ? double.parse(item['price'].toString()) 
                  : (item['price'] as num).toDouble();
              final quantity = item['quantity'] as int;
              
              return Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${item['name']} x$quantity'),
                    Text('\$${(price * quantity).toStringAsFixed(2)}'),
                  ],
                ),
              );
            }).toList(),
            Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('\$${cartController.total.toStringAsFixed(2)}', style: TextStyle(fontSize: 24, color: Colors.orange, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final items = cartController.cartItems.map((item) => {
                  'product_id': item['id'],
                  'quantity': item['quantity'],
                  'price': item['price']
                }).toList();
                
                final result = await ApiService.placeOrder(authController.userId.value, items, cartController.total);
                
                if (result['success']) {
                  cartController.clearCart();
                  Get.off(() => ThankYouScreen());
                } else {
                  Get.snackbar('Error', 'Failed to place order', backgroundColor: Colors.red, colorText: Colors.white);
                }
              },
              child: Padding(padding: EdgeInsets.all(16), child: Text('PLACE ORDER', style: TextStyle(fontSize: 16))),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
