import 'dart:convert';

import 'package:zeus_app/src/core/services/http_service.dart';

import '../../../core/utils/app_constants.dart';
import '../models/product_model.dart';

class ProductService {
  final HttpService httpService;

  ProductService({required this.httpService});

  Future<List<ProductModel>> getAllProduct() async {
    final json = await httpService.getJson(url: '${ApiConsts.path}/produtos');
    return List<ProductModel>.from(
        jsonDecode(json).map((e) => ProductModel.fromMap(e)));
  }

  Future<ProductModel> getProduct({required String id}) async {
    final json =
        await httpService.getJson(url: '${ApiConsts.path}/produtos/$id');
    return ProductModel.fromMap(jsonDecode(json));
  }

  Future<void> postProduct({
    required Map<String, dynamic> newProduct,
  }) async {
    await httpService.postJson(
      url: '${ApiConsts.path}/produtos',
      postBody: json.encode(newProduct),
    );
  }

  Future<void> deleteProduct({
    required String id,
  }) async {
    await httpService.deleteJson(url: '${ApiConsts.path}/produtos/$id');
  }

  Future<void> putProduct(
      {required String id, required Map<String, dynamic> newProduct}) async {
    await httpService.putJson(
      url: '${ApiConsts.path}/produtos/$id',
      postBody: json.encode(newProduct),
    );
  }
}
