import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/shopping_cart_model.dart';

class TopSection extends StatelessWidget {
  final ShoppingCartModel shoppingCart;

  const TopSection({super.key, required this.shoppingCart});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170.0,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 140,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade600,
                  Colors.blue.shade400,
                  Colors.blue.shade300,
                  Colors.blue.shade200,
                  Colors.blue.shade100,
                  // Color.fromARGB(255, 238, 238, 238)
                  // Color.fromARGB(255, 238, 238, 238),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          _generateCardTeam(),
        ],
      ),
    );
  }

  Widget _generateCardTeam() {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Center(
        child: SizedBox(
          height: double.infinity,
          width: 250.0,
          child: _generateLogo(),
        ),
      ),
    );
  }

  Widget _generateLogo() {
    List<int> selected = _getProductSelected();
    int totalSelected = selected[0];
    int totalSelectedPrice = selected[1];
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _generateContentCard(),
            Text(
              shoppingCart.name.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue.shade800,
                fontWeight: FontWeight.w800,
                fontSize: 15.0,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Icon(Icons.check, color: Colors.blue),
                    Text(
                      totalSelected.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue.shade400,
                        fontWeight: FontWeight.normal,
                        fontSize: 12.0,
                      ),
                    ),
                    Text(
                      '₡$totalSelectedPrice',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.shopping_cart, color: Colors.green),
                    Text(
                      shoppingCart.products.length.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.green.shade400,
                        fontWeight: FontWeight.normal,
                        fontSize: 12.0,
                      ),
                    ),
                    Text(
                      '₡${shoppingCart.totalPrice}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<int> _getProductSelected() {
    int totalSelected = 0;
    int totalSelectedPrice = 0;
    for (var product in shoppingCart.products) {
      if (product.selected) {
        totalSelected++;
        totalSelectedPrice = totalSelectedPrice + product.price;
      }
    }
    return [totalSelected, totalSelectedPrice];
  }

  Widget _generateContentCard() => Container(
      alignment: Alignment.center,
      child: const Padding(
        padding: EdgeInsets.only(bottom: 5.0),
        child: Icon(Icons.shopping_bag_rounded, size: 40.0),
      ));

  Image imageFromBase64String({required String image}) => Image.memory(
        base64Decode(image),
        fit: BoxFit.cover,
        height: 100.0,
      );

  Uint8List dataFromBase64String(String base64String) =>
      base64Decode(base64String);

  String base64String(Uint8List data) => base64Encode(data);
}
