import 'package:flutter/material.dart';
import 'package:soccer/pages/shopping_cart/widgets/views/shopping_cart_details_view.dart';
import 'package:soccer/user_preferences.dart';

import '../custom_widgets/custom_button_exit.dart';
import 'models/shopping_cart_model.dart';
import 'provider/provider_my_shopping_cart.dart';
import 'widgets/dialogs/add_product_shopping_cart.dart';
import 'widgets/dialogs/alerts.dart';

class ShoppingCartView extends StatefulWidget {
  static const id = 'Watch_shopping_cart';

  const ShoppingCartView({Key? key}) : super(key: key);

  @override
  ShoppingCartViewState createState() => ShoppingCartViewState();
}

class ShoppingCartViewState extends State<ShoppingCartView> {
  final ProviderShoppingCart _provider = ProviderShoppingCart();
  final UserPreferences _prefs = UserPreferences();

  @override
  void initState() {
    super.initState();
    _getShoppingCart();
  }

  void _getShoppingCart() => _provider.getShoppingCarts(idUser: _prefs.userId);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text("MY SHOPPING CARTS"),
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.only(right: 0),
            child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back)),
          ),
          actions: [CustomButtonExit()],
        ),
        body: Container(
          color: const Color.fromARGB(255, 238, 238, 238),
          child: StreamBuilder(
              stream: _provider.shoppingCartsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<ShoppingCartModel>> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.isNotEmpty
                      ? _generateGridView(
                          shoppinCarts: snapshot.data ?? [],
                        )
                      : const Text("Not data");
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _alertAddShoppingCart,
          tooltip: 'Add to shopping cart',
          child: const Icon(
            Icons.add,
            size: 20.0,
          ),
        ),
      ),
    );
  }

  Widget _generateGridView({required List<ShoppingCartModel> shoppinCarts}) =>
      CustomScrollView(primary: false, slivers: <Widget>[
        SliverGrid.count(
          childAspectRatio: 1.3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: shoppinCarts
              .map((ShoppingCartModel shoppingCart) =>
                  _generateCard(shoppingCart: shoppingCart))
              .toList(),
        ),
      ]);

  Widget _generateCard({required ShoppingCartModel shoppingCart}) =>
      GestureDetector(
        onTap: () => _shoppingCartSelected(shoppingCart: shoppingCart),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 150.0,
              width: 160.0,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      height: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child:
                            Image.asset('assets/card2.png', fit: BoxFit.cover),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 5.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: _generateText(
                                text: shoppingCart.name.toUpperCase(),
                                fontSize: 12.0),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "CART VALUE".toUpperCase(),
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 5.0, bottom: 5.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '₡${shoppingCart.totalPrice.toString().toUpperCase()}',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _generateText({required String text, double fontSize = 12.0}) => Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
        textAlign: TextAlign.center,
      );

  void _alertAddShoppingCart() {
    final ShoppingCartModel shopppingCart = ShoppingCartModel(
        name: '', products: [], shoppingCartId: -1, totalPrice: 0);
    Alerts.generateAlert(
        content: AddProductShoppingCart(shoppingCart: shopppingCart),
        context: context,
        onPressed: () => _addShoppingCart(shoppingCart: shopppingCart),
        texButton: "ADD");
  }

  void _addShoppingCart({required ShoppingCartModel shoppingCart}) async {
    await _provider.addShoppingCart(shoppingCart: shoppingCart);
    _getShoppingCart();
    setState(() {});
    Navigator.pop(context);
  }

  void _shoppingCartSelected({required ShoppingCartModel shoppingCart}) {
    final route = MaterialPageRoute(
        builder: (context) => ShoppingCartDetailsView(
              shoppingCart: shoppingCart,
              provider: _provider,
            ));
    Navigator.push(context, route);
  }
}
