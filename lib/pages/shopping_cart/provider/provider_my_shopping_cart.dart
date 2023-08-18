import 'dart:async';

import 'package:soccer/pages/shopping_cart/provider/provider_client.dart';
import 'package:soccer/user_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/shopping_cart_model.dart';
import 'constants.dart';

class ProviderShoppingCart {
  ProviderShoppingCart();
  final Supabase _supabase = Supabase.instance;
  final _client = ProviderClient();
  final UserPreferences _prefs = UserPreferences();

  List<ShoppingCartModel> _shoppingCarts = [];
  final _shoppingCartsStreamController =
      StreamController<List<ShoppingCartModel>>.broadcast();
  Function(List<ShoppingCartModel>) get shoppingCartsSink =>
      _shoppingCartsStreamController.sink.add;
  Stream<List<ShoppingCartModel>> get shoppingCartsStream =>
      _shoppingCartsStreamController.stream;
  //SHOPPING CART
  Future getShoppingCarts({required int idUser}) async {
    final Map<String, dynamic> params = {'_id_user': idUser};
    final List<dynamic> response =
        await _client.get(api: 'get_shopping_carts_by_user', params: params);

    ShoppingCartsModel exercisesResponse =
        ShoppingCartsModel.fromJson(response);
    _shoppingCarts = exercisesResponse.shoppingCarts;
    shoppingCartsSink(_shoppingCarts);
  }

  Future addShoppingCart({required ShoppingCartModel shoppingCart}) async {
    final Map<String, dynamic> params = {
      'name': shoppingCart.name,
      'products': {}
    };

    await _supabase.client.from('shopping_cart').insert(params);

    final List<dynamic> response = await _supabase.client
        .from('shopping_cart')
        .select()
        .limit(1)
        .order('id', ascending: false);
    final int shoppingCartId = response.first["id"];
    _addShoppingCart(userId: _prefs.userId, shoppingCartId: shoppingCartId);
  }

  Future _addShoppingCart(
      {required int userId, required int shoppingCartId}) async {
    final Map<String, dynamic> paramsUser = {
      'user_id': userId,
      'shoppincart_id': shoppingCartId
    };
    await _supabase.client.from('shoppingcart_user').insert(paramsUser);
  }

  Future<int> shareShoppingCart(
      {required int shoppingCartId, required String userName}) async {
    final List<dynamic> response =
        await _supabase.client.from('user').select('id').eq('name', userName);

    if (response.isNotEmpty) {
      final int userId = response.first['id'];
      final List<dynamic> newResponse = await _supabase.client
          .from('shoppingcart_user')
          .select('id')
          .eq('user_id', userId)
          .eq('shoppincart_id', shoppingCartId);
      if (userId == _prefs.userId) {
        return Constants.CODE_MY_ACCOUNT;
      } else if (newResponse.isNotEmpty) {
        return Constants.CODE_ALREADY_ADDED;
      } else {
        _addShoppingCart(userId: userId, shoppingCartId: shoppingCartId);
        return Constants.CODE_SUCCESFUL;
      }
    } else {
      return Constants.CODE_NOT_FOUND;
    }
  }

  //PRODUCTS

  Future addProduct({required ShoppingCartModel shoppingCart}) async {
    final Map<String, dynamic> json = shoppingCart.json();
    final String id = shoppingCart.shoppingCartId.toString();
    _client.update(table: 'shopping_cart', id: id, params: {'products': json});
  }

  Future deleteProduct(
      {required ShoppingCartModel shoppingCart,
      required ProductModel product}) async {
    shoppingCart.deleteProduct(product: product);
    final Map<String, dynamic> json = shoppingCart.json();
    final String id = shoppingCart.shoppingCartId.toString();

    _client.update(table: 'shopping_cart', id: id, params: {'products': json});
  }
}
