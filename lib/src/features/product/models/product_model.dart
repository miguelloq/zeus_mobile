import 'dart:convert';

enum ProductType { racao, remedio, brinquedo, outro }

class ProductModel {
  final String? id;
  final String name;
  final ProductType productType;
  final double quantity;
  final double price;
  final DateTime purchaseTime;
  final DateTime? lastEditTime;
  ProductModel({
    this.id,
    required this.name,
    required this.productType,
    required this.quantity,
    required this.price,
    required this.purchaseTime,
    this.lastEditTime,
  });

  String get typeVisualise {
    switch (productType) {
      case ProductType.racao:
        return 'Ração';
      case ProductType.brinquedo:
        return 'Brinquedo';
      case ProductType.remedio:
        return 'Remédio';
      case ProductType.outro:
        return 'Outros';
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'productType': productType.toString(),
      'quantity': quantity,
      'price': price,
      'purchaseTime': purchaseTime.millisecondsSinceEpoch,
      'lastEditTime': lastEditTime,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    double returnAlwaysDouble({required dynamic input}) {
      if (input is int) {
        return input.toDouble();
      } else if (input is double) {
        return input;
      } else {
        return 0.0;
      }
    }

    ProductType enumTransform({required String input}) {
      switch (input) {
        case 'racao':
          return ProductType.racao;
        case 'outro':
          return ProductType.outro;
        case 'remedio':
          return ProductType.remedio;
        case 'brinquedo':
          return ProductType.brinquedo;
        default:
          throw Exception('Tipo do brinquedo é desconhecido');
      }
    }

    return ProductModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      name: map['name'] as String,
      productType: enumTransform(input: (map['type'] as String)),
      price: returnAlwaysDouble(input: map['price']),
      quantity: returnAlwaysDouble(input: map['quantity']),
      purchaseTime: DateTime.parse(map['purchaseTime']),
      lastEditTime: map['lastEditTime'] == ""
          ? null
          : DateTime.parse(map['lastEditTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  ProductModel copyWith({
    String? id,
    String? name,
    ProductType? productType,
    double? quantity,
    double? price,
    DateTime? purchaseTime,
    DateTime? lastEditTime,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      productType: productType ?? this.productType,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      purchaseTime: purchaseTime ?? this.purchaseTime,
      lastEditTime: lastEditTime ?? this.lastEditTime,
    );
  }
}
