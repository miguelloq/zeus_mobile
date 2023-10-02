import 'package:mobx/mobx.dart';
import 'package:zeus_app/src/core/services/local_storage_service.dart';
import 'package:zeus_app/src/features/product/services/product_service.dart';

import '../models/product_model.dart';

part 'product_vm.g.dart';

enum VMState { error, loaded, idle, loading }

enum VisibleOption { sevenDays, thirtyDays, all }

class ProductVM = _ProductVM with _$ProductVM;

abstract class _ProductVM with Store {
  final LocalStorageService localStorageService;
  double productsTotalPrice;
  List<ProductModel> products;
  List<ProductModel> visibleProducts;
  ProductService productService;
  VisibleOption currentVisibility;

  _ProductVM({
    required this.productService,
    required this.localStorageService,
  })  : products = [],
        visibleProducts = [],
        productsTotalPrice = 0,
        currentVisibility = VisibleOption.sevenDays;

  @observable
  VMState screenState = VMState.idle;

  @observable
  String? errorMessage;

  @action
  void changeState({required VMState newState}) {
    if (screenState == VMState.error && newState != VMState.error) {
      errorMessage = null;
    }
    screenState = newState;
  }

  List<ProductModel> _filterLastDays(
      {required List<ProductModel> list, required int? daysNumber}) {
    DateTime currentDate = DateTime.now();
    List<ProductModel> filtredList = list;
    if (daysNumber != null) {
      DateTime limitDate = currentDate.subtract(Duration(days: daysNumber));

      filtredList = list.where((product) {
        return product.purchaseTime.isAfter(limitDate) &&
            product.purchaseTime.isBefore(currentDate);
      }).toList();
    }

    filtredList.sort((a, b) => b.purchaseTime.compareTo(a.purchaseTime));

    return filtredList;
  }

  void _changeVisibility({required VisibleOption newOption}) {
    currentVisibility = newOption;
    switch (currentVisibility) {
      case (VisibleOption.sevenDays):
        visibleProducts = _filterLastDays(list: products, daysNumber: 7);
        break;
      case (VisibleOption.thirtyDays):
        visibleProducts = _filterLastDays(list: products, daysNumber: 30);
        break;
      case (VisibleOption.all):
        visibleProducts = _filterLastDays(list: products, daysNumber: null);
        break;
    }
  }

  void _changeTotalValue() {
    double auxPrice = 0;
    for (var racao in visibleProducts) {
      auxPrice += racao.price;
    }
    productsTotalPrice = auxPrice;
  }

  void updateVisibility({VisibleOption? newOption}) {
    changeState(newState: VMState.loading);
    if (newOption != null) {
      _changeVisibility(newOption: newOption);
    } else {
      _changeVisibility(newOption: currentVisibility);
    }
    _changeTotalValue();
    if (visibleProducts.isEmpty) {
      changeState(newState: VMState.idle);
    } else {
      changeState(newState: VMState.loaded);
    }
  }

  Future<ProductModel> getProduct({required String id}) {
    return productService.getProduct(id: id);
  }

  Future<void> updateProducts() async {
    changeState(newState: VMState.loading);
    try {
      products = await productService.getAllProduct();
      updateVisibility();
    } catch (e) {
      errorMessage = e.toString();
      changeState(newState: VMState.error);
    }
  }
}
