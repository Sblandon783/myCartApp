import 'package:flutter/material.dart';

import '../../models/shopping_cart_model.dart';

class AddProductShoppingCart extends StatefulWidget {
  final ShoppingCartModel shoppingCart;
  const AddProductShoppingCart({Key? key, required this.shoppingCart})
      : super(key: key);

  @override
  AddProductShoppingCartState createState() => AddProductShoppingCartState();
}

class AddProductShoppingCartState extends State<AddProductShoppingCart> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _listenners();
  }

  void _listenners() {
    _nameController.text = widget.shoppingCart.name.toString();
    _nameController
        .addListener(() => widget.shoppingCart.name = _nameController.text);
  }

  @override
  void dispose() {
    _nameController.dispose();
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
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "Add Shopping Cart",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              _generateTextField(
                  text: 'Name', controller: _nameController, isNum: false),
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
