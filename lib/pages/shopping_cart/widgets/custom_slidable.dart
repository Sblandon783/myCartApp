import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/shopping_cart_model.dart';

class CustomSlidable extends StatefulWidget {
  final ProductModel product;
  final Function updateCheckBox;
  final Function({required ProductModel product}) deleteMe;
  final Function({required ProductModel product}) editMe;

  const CustomSlidable({
    Key? key,
    required this.product,
    required this.updateCheckBox,
    required this.deleteMe,
    required this.editMe,
  }) : super(key: key);

  @override
  CustomSlidableState createState() => CustomSlidableState();
}

class CustomSlidableState extends State<CustomSlidable> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _generateSlider();

  Widget _containerFlex({required Widget child}) => Flexible(
        flex: 1,
        child: Container(
          alignment: Alignment.centerLeft,
          width: double.infinity,
          child: child,
        ),
      );

  Widget _generateSlider() {
    return GestureDetector(
      onTap: () =>
          {}, //Alerts.example(context: context, exercise: widget.products),
      child: Column(
        children: [
          Slidable(
            key: const ValueKey(0),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) =>
                      widget.deleteMe(product: widget.product),
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                ),
                SlidableAction(
                  onPressed: (context) =>
                      widget.editMe(product: widget.product),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                )
              ],
            ),
            child: SizedBox(
              height: 60.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _checkBox(),
                  _containerFlex(
                      child: Text(
                    widget.product.name,
                    textAlign: TextAlign.center,
                  )),
                  _containerFlex(
                      child: Text(
                    widget.product.count.toString(),
                    textAlign: TextAlign.center,
                  )),
                  _containerFlex(
                      child: Text(
                    '₡${widget.product.price.toString()}',
                    textAlign: TextAlign.center,
                  ))
                ],
              ),
            ),
          ),
          const Divider(color: Colors.grey, thickness: 0.5, height: 1.0),
        ],
      ),
    );
  }

  Widget _checkBox() {
    return SizedBox(
      width: 50.0,
      child: GestureDetector(
          onTap: () {
            widget.updateCheckBox();
            setState(() => widget.product.selected = !widget.product.selected);
          },
          child: widget.product.selected
              ? const Icon(
                  Icons.check_box,
                  size: 40.0,
                  color: Colors.blue,
                )
              : const Icon(
                  Icons.check_box_outline_blank_rounded,
                  size: 40.0,
                  color: Colors.grey,
                )),
    );
  }
}
