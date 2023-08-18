import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShareShoppingCart extends StatefulWidget {
  final Function({required String userName}) onTap;
  const ShareShoppingCart({Key? key, required this.onTap}) : super(key: key);

  @override
  ShareShoppingCartState createState() => ShareShoppingCartState();
}

class ShareShoppingCartState extends State<ShareShoppingCart> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "Share Shopping Cart",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: TextField(
                  controller: _nameController,
                  obscureText: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Username'),
                  ),
                  maxLines: 1,
                  minLines: 1,
                ),
              ),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () =>
                          widget.onTap(userName: _nameController.text),
                      child: const Text("Share")))
            ],
          ),
        )
      ],
    );
  }
}
