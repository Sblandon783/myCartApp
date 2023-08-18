import 'package:flutter/material.dart';

import '../../../../user_preferences.dart';
import '../../../custom_widgets/custom_button_exit.dart';
import '../../models/shopping_cart_model.dart';
import '../../provider/constants.dart';
import '../../provider/provider_my_shopping_cart.dart';
import '../custom_slidable.dart';
import '../dialogs/add_product.dart';
import '../dialogs/alerts.dart';
import '../dialogs/share_shopping_cart.dart';
import '../top_section.dart';

class ShoppingCartDetailsView extends StatefulWidget {
  static const id = '/routine_view';
  final ShoppingCartModel shoppingCart;
  final ProviderShoppingCart provider;

  const ShoppingCartDetailsView(
      {Key? key, required this.shoppingCart, required this.provider})
      : super(key: key);

  @override
  ShoppingCartDetailsViewState createState() => ShoppingCartDetailsViewState();
}

class ShoppingCartDetailsViewState extends State<ShoppingCartDetailsView> {
  final UserPreferences _prefs = UserPreferences();
  final Map<int, String> _messages = {
    Constants.CODE_NOT_FOUND: "Not exist account name",
    Constants.CODE_MY_ACCOUNT: "It's your account name",
    Constants.CODE_SUCCESFUL: "Shopping cart to shared",
    Constants.CODE_ALREADY_ADDED: "Shopping Cart is sharing with you"
  };
  @override
  void initState() {
    _prefs.pageId = ShoppingCartDetailsView.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text("My Shopping Cart".toUpperCase()),
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.only(right: 0),
            child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back)),
          ),
          actions: [_share(), CustomButtonExit()],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _alertAddProduct,
          tooltip: 'Add product',
          child: const Icon(
            Icons.add,
            size: 20.0,
          ),
        ),
        body: Container(
          color: const Color.fromARGB(255, 238, 238, 238),
          child: Column(
            children: [
              TopSection(shoppingCart: widget.shoppingCart),
              const SizedBox(height: 30.0),
              widget.shoppingCart.products.isEmpty
                  ? const Center(child: Text("No products available"))
                  : Container(
                      color: Colors.blue,
                      width: double.infinity,
                      height: 50.0,
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(width: 40, height: 40),
                          _containerFlex(
                              child: const Text(
                            "Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                          _containerFlex(
                              child: const Text(
                            "Count",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )),
                          _containerFlex(
                              child: const Text(
                            "Price",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ))
                        ],
                      ),
                    ),
              Flexible(child: _generateGridView())
            ],
          ),
        ),
      ),
    );
  }

  Widget _generateGridView() => SingleChildScrollView(
        child: Column(
          children: widget.shoppingCart.products
              .map((ProductModel product) => CustomSlidable(
                    product: product,
                    updateCheckBox: _updateCheckBox,
                    deleteMe: _deleteProduct,
                    editMe: _alertEditProduct,
                  ))
              .toList(),
        ),
      );

  _updateCheckBox() => setState(() {});

  Widget _containerFlex({required Widget child}) => Flexible(
        flex: 1,
        child: Container(
          alignment: Alignment.centerLeft,
          width: double.infinity,
          child: child,
        ),
      );

  void _alertAddProduct() {
    final ProductModel product = ProductModel(count: 0, price: 0, name: '');
    Alerts.generateAlert(
        content: AddProduct(product: product),
        context: context,
        onPressed: () => _addProduct(product: product),
        texButton: "ADD");
  }

  void _addProduct({required ProductModel product}) async {
    if (!widget.shoppingCart.addProduct(product: product)) {
      _snackBar(message: "You should use another product's name");
      return;
    }
    widget.provider.addProduct(shoppingCart: widget.shoppingCart);
    widget.shoppingCart.setTotalPrice();
    setState(() {});
    Navigator.pop(context);
  }

  void _deleteProduct({required ProductModel product}) {
    widget.provider
        .deleteProduct(shoppingCart: widget.shoppingCart, product: product);
    setState(() {});
  }

  void _alertEditProduct({required ProductModel product}) {
    Alerts.generateAlert(
        content: AddProduct(product: product),
        context: context,
        onPressed: () => _editProduct(product: product),
        texButton: "EDIT");
  }

  void _editProduct({required ProductModel product}) {
    widget.shoppingCart.editProduct(product: product);
    widget.provider.addProduct(shoppingCart: widget.shoppingCart);
    setState(() {});
    Navigator.pop(context);
  }

  Widget _share() {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0),
      child: GestureDetector(
        onTap: _alertShare,
        child: const Icon(Icons.share_rounded),
      ),
    );
  }

  void _alertShare() {
    Alerts.generateAlert(
        content: ShareShoppingCart(onTap: onTapShare), context: context);
  }

  void onTapShare({required String userName}) async {
    final int code = await widget.provider.shareShoppingCart(
        shoppingCartId: widget.shoppingCart.shoppingCartId, userName: userName);
    final String message = _messages[code] ?? '';
    _snackBar(message: message);
    _close();
  }

  void _close() => Navigator.pop(context);

  void _snackBar({required String message}) {
    SnackBar snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
