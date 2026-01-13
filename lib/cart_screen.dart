// Cart Screen
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:third/checkout_screen.dart';
import 'package:third/controller/auth_controller.dart';

class CartScreen extends StatelessWidget {
  final cartController = Get.find<CartController>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Cart'), backgroundColor: Colors.orange),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(child: Text('Your cart is empty', style: TextStyle(fontSize: 18, color: Colors.grey)));
        }
        
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                padding: EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  // Convert price to double safely
                  final price = item['price'] is String 
                      ? double.parse(item['price'].toString()) 
                      : (item['price'] as num).toDouble();
                  
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(image: NetworkImage(item['image']), fit: BoxFit.cover),
                        ),
                      ),
                      title: Text(item['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('\$${price.toStringAsFixed(2)}', style: TextStyle(color: Colors.orange)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () => cartController.updateQuantity(index, item['quantity'] - 1),
                          ),
                          Text('${item['quantity']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: Icon(Icons.add_circle, color: Colors.green),
                            onPressed: () => cartController.updateQuantity(index, item['quantity'] + 1),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -4))],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('\$${cartController.total.toStringAsFixed(2)}', style: TextStyle(fontSize: 24, color: Colors.orange, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.to(() => CheckoutScreen()),
                    child: Padding(padding: EdgeInsets.all(16), child: Text('PROCEED TO CHECKOUT', style: TextStyle(fontSize: 16))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: Size(double.infinity, 0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
