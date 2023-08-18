class ShoppingCartsModel {
  List<ShoppingCartModel> shoppingCarts;

  ShoppingCartsModel({required this.shoppingCarts});

  factory ShoppingCartsModel.fromJson(dynamic response) => ShoppingCartsModel(
        shoppingCarts: response.isNotEmpty
            ? List<ShoppingCartModel>.from(
                response.map((x) => ShoppingCartModel.fromJson(x)))
            : [],
      );
}

class ShoppingCartModel {
  int shoppingCartId;
  String name;
  List<ProductModel> products;
  double totalPrice;
  ShoppingCartModel(
      {required this.shoppingCartId,
      required this.name,
      required this.products,
      required this.totalPrice});

  factory ShoppingCartModel.fromJson(Map<String, dynamic> json) {
    double price = 0;
    List<ProductModel> products = _getProducts(value: json["products"]);

    for (var product in products) {
      price = price + product.price;
    }
    return ShoppingCartModel(
      shoppingCartId: json["shoppingcart_id"] ?? -1,
      name: json["name"] ?? '',
      products: products,
      totalPrice: price,
    );
  }

  void setTotalPrice() {
    double price = 0;
    for (var product in products) {
      price = price + product.price;
    }
    totalPrice = price;
  }

  bool addProduct({required ProductModel product}) {
    Map<String, dynamic> jsonProducts = json();
    if (jsonProducts.containsKey(product.name)) {
      return false;
    } else {
      products.add(product);
      return true;
    }
  }

  void deleteProduct({required ProductModel product}) =>
      products.remove(product);

  editProduct({required ProductModel product}) {
    for (var i = 0; i < products.length; i++) {
      if (products[i] == product) {
        print("object");
      }
    }
  }

  Map<String, dynamic> json() {
    Map<String, dynamic> json = {};
    for (var product in products) {
      json[product.name] = [product.count, product.price];
    }
    return json;
  }
}

List<ProductModel> _getProducts({required Map<String, dynamic> value}) {
  List<ProductModel> products = [];
  for (var element in value.entries) {
    String name = element.key;

    List<dynamic> data = element.value;
    ProductModel product =
        ProductModel(name: name, count: data[0], price: data[1]);
    products.add(product);
  }
  return products;
}

class ProductModel {
  String name;
  int count;
  int price;
  bool selected = false;

  ProductModel({
    required this.name,
    required this.count,
    required this.price,
  });
}
