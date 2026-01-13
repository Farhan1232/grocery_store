// Home Screen with Auto-scrolling Banner
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:third/cart_screen.dart';
import 'package:third/controller/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final productController = Get.put(ProductController());
  final cartController = Get.put(CartController());
  final searchController = TextEditingController();
  final PageController pageController = PageController();
  Timer? timer;
  int currentPage = 0;
  
  final bannerImages = [
'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800',
'https://images.unsplash.com/photo-1519744792095-2f2205e87b6f?w=800', 
'https://images.unsplash.com/photo-1617038260897-b52a8c2e04a8?w=800' 

  ];
  
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      if (currentPage < bannerImages.length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      pageController.animateToPage(currentPage, duration: Duration(milliseconds: 350), curve: Curves.easeIn);
    });
  }
  
  @override
  void dispose() {
    timer?.cancel();
    pageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Women Accessories'),
        backgroundColor: Colors.orange,
        elevation: 0,
        actions: [
          Obx(() => Stack(
            children: [
              IconButton(icon: Icon(Icons.shopping_cart), onPressed: () => Get.to(() => CartScreen())),
              if (cartController.cartItems.length > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text('${cartController.cartItems.length}', style: TextStyle(color: Colors.white, fontSize: 10)),
                  ),
                ),
            ],
          )),
          IconButton(icon: Icon(Icons.logout), onPressed: () => Get.find<AuthController>().logout()),
        ],
      ),
      body: Column(
        children: [
          // Auto-scrolling Banner
          Container(
            height: 200,
            child: PageView.builder(
              controller: pageController,
              itemCount: bannerImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(image: NetworkImage(bannerImages[index]), fit: BoxFit.cover),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
                  ),
                );
              },
            ),
          ),
          
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search for food...',
                  prefixIcon: Icon(Icons.search, color: Colors.orange),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                onChanged: (value) => setState(() {}),
              ),
            ),
          ),
          
          // Product List
          Expanded(
            child: Obx(() {
              if (productController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              
              var filteredProducts = productController.products.where((p) =>
                p['name'].toString().toLowerCase().contains(searchController.text.toLowerCase())
              ).toList();
              
              return GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 16, mainAxisSpacing: 16),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return _buildProductCard(product);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProductCard(Map<String, dynamic> product) {
    // Convert price to double safely
    final price = product['price'] is String 
        ? double.parse(product['price'].toString()) 
        : (product['price'] as num).toDouble();
    
    return GestureDetector(
      onTap: () => _showProductDetails(product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  image: DecorationImage(image: NetworkImage(product['image']), fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4),
                  Text('\$${price.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, color: Colors.orange, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showProductDetails(Map<String, dynamic> product) {
    // Convert price to double safely
    final price = product['price'] is String 
        ? double.parse(product['price'].toString()) 
        : (product['price'] as num).toDouble();
    
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(image: NetworkImage(product['image']), fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 20),
            Text(product['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(product['description'] ?? 'Women Accessories', style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 16),
            Text('\$${price.toStringAsFixed(2)}', style: TextStyle(fontSize: 28, color: Colors.orange, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                cartController.addToCart(product);
                Get.back();
              },
              child: Padding(padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16), child: Text('ADD TO CART', style: TextStyle(fontSize: 16))),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
