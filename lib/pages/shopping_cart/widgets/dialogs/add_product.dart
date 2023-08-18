import 'package:flutter/material.dart';

import '../../models/shopping_cart_model.dart';

class AddProduct extends StatefulWidget {
  final ProductModel product;
  const AddProduct({Key? key, required this.product}) : super(key: key);

  @override
  AddProductState createState() => AddProductState();
}

class AddProductState extends State<AddProduct> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _countController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _listenners();
  }

  void _listenners() {
    _nameController.text = widget.product.name.toString();
    _priceController.text = widget.product.price.toString();
    _countController.text = widget.product.count.toString();
    _nameController
        .addListener(() => widget.product.name = _nameController.text);
    _priceController.addListener(
        () => widget.product.price = int.parse(_priceController.text));
    _countController.addListener(
        () => widget.product.count = int.parse(_countController.text));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.close),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  widget.product.name.isEmpty ? "Add Product" : "Edit Product",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              _generateTextField(
                  text: 'Name', controller: _nameController, isNum: false),
              _generateTextField(
                  text: 'Price', controller: _priceController, isNum: true),
              _generateTextField(
                  text: 'Count', controller: _countController, isNum: true),
            ],
          ),
        )
      ],
    );
  }

  Widget _generateTextField({
    required String text,
    required TextEditingController controller,
    required bool isNum,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextField(
        controller: controller,
        obscureText: false,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: Text(text),
        ),
        maxLines: 1,
        minLines: 1,
        keyboardType: isNum ? TextInputType.number : null,
      ),
    );
  }
}
