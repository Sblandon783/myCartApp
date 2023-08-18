import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

class ProviderClient {
  ProviderClient();

  final Supabase _supabase = Supabase.instance;

  Future<List> get(
      {required String api, required Map<String, dynamic> params}) async {
    final List<dynamic> response =
        await _supabase.client.rpc(api, params: params);
    print('API: $api -- params: $params');
    return response;
  }

  Future<List> update(
      {required String table,
      required Map<String, dynamic> params,
      required String id}) async {
    final List<dynamic> response =
        await _supabase.client.from(table).update(params).eq('id', id) ?? [];
    print('API: $table -- id $id -- params: $params');
    return response;
  }
}
