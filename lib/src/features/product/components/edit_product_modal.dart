// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';
import 'package:zeus_app/src/features/product/models/product_model.dart';

import '../services/product_service.dart';
import '../vm/product_vm.dart';

class AuxDropDown {
  final String value;
  final String visibleValue;
  AuxDropDown({
    required this.value,
    required this.visibleValue,
  });
}

editProductModal({
  required BuildContext context,
  required double height,
  required double width,
  required GlobalKey<FormState> formKey,
  required String editProductId,
  required Function updateProducts,
}) {
  showModalBottomSheet(
    isScrollControlled: true,
    shape: const BeveledRectangleBorder(),
    enableDrag: false,
    context: context,
    builder: (BuildContext context) => _editProductWidget(
        height: height,
        width: width,
        formKey: formKey,
        editProductid: editProductId,
        updateProducts: updateProducts),
  );
}

class _editProductWidget extends StatefulWidget {
  final double height;
  final double width;
  final GlobalKey<FormState> formKey;
  final String editProductid;
  final Function updateProducts;

  const _editProductWidget(
      {super.key,
      required this.height,
      required this.width,
      required this.formKey,
      required this.editProductid,
      required this.updateProducts});

  @override
  State<_editProductWidget> createState() => _editProductWidgetState();
}

class _editProductWidgetState extends State<_editProductWidget> {
  late final ProductService productService;
  late final ProductVM productVM;
  late Future<ProductModel> editProduct;

  String? textName;
  String? textPrice;
  String? textQuantity;
  DateTime? chosenDate;
  final List<AuxDropDown> auxDropDowns = [
    AuxDropDown(value: 'Ração', visibleValue: ProductType.racao.toString()),
    AuxDropDown(
        value: 'Brinquedo', visibleValue: ProductType.brinquedo.toString()),
    AuxDropDown(value: 'Remédio', visibleValue: ProductType.remedio.toString()),
    AuxDropDown(value: 'Outros', visibleValue: ProductType.outro.toString()),
  ];
  String? dropdownValue;

  @override
  void initState() {
    productService = context.read<ProductService>();
    productVM = context.read<ProductVM>();
    editProduct = productService.getProduct(id: widget.editProductid);
    super.initState();
  }

  void _showDatePicker(
      {required DateTime parameterDate, required DateTime chosenDate}) {
    showDatePicker(
            context: context,
            initialDate: chosenDate,
            firstDate: parameterDate.subtract(const Duration(days: 50)),
            lastDate: parameterDate.add(const Duration(days: 50)))
        .then((value) {
      if (value != null) {
        setState(() {
          chosenDate = value;
        });
      }
    });
  }

  void dropDownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {});
    }
  }

  Future<void> _putProduct({
    required String editProductId,
    required String name,
    required double price,
    required String type,
    required DateTime creationDate,
    required double quantity,
  }) async {
    try {
      await productService.putProduct(id: editProductId, newProduct: {
        'name': name,
        'type': type,
        'price': price,
        'quantity': quantity,
        'purchaseTime': creationDate.toUtc().toIso8601String()
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error em editar compra. $e",
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: editProduct,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("Erro em obter as informações do produto editado "),
          );
        } else {
          String inititalName = snapshot.data!.name;
          String initialPrice = snapshot.data!.price.toString();
          String initialQuantity = snapshot.data!.quantity.toString();
          DateTime initialChosenDate = snapshot.data!.purchaseTime;
          String initialDropdownValue = snapshot.data!.productType.name;
          return Form(
            key: widget.formKey,
            child: SafeArea(
              child: ListView(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 32,
                        ),
                      )
                    ],
                  ),
                  Text(
                    'Edite uma compra!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        TextFormField(
                          onChanged: (value) {
                            textName = value;
                          },
                          initialValue: inititalName,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            labelText: 'Nome',
                            labelStyle: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            prefixIcon: const Icon(Icons.abc_rounded),
                          ),
                          validator: Validatorless.multiple([
                            Validatorless.required(
                                'O campo nome é obrigatório.'),
                            Validatorless.between(3, 24,
                                'O nome deve ter o tamanho entre 3 e 24 caracteres.'),
                          ]),
                        ),
                        const SizedBox(height: 25),
                        TextFormField(
                          onChanged: (value) {
                            textQuantity = value;
                          },
                          initialValue: initialQuantity,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            labelText: 'Quantidade(Somente numeros e ponto)',
                            labelStyle: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            prefixIcon: const Icon(Icons.scale_rounded),
                          ),
                          keyboardType: TextInputType.number,
                          validator: Validatorless.multiple(
                            [
                              Validatorless.required(
                                  'O campo quantidade é obrigatório'),
                              Validatorless.regex(RegExp(r'^[0-9.]+$'),
                                  'Somente numeros e ponto'),
                              Validatorless.numbersBetweenInterval(0.01, 10000,
                                  "A quantidade deve estar entre 0 e 10000")
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        TextFormField(
                          onChanged: (value) {
                            textPrice = value;
                          },
                          initialValue: initialPrice,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            labelText: 'Preço(Somente numeros e ponto)',
                            labelStyle: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            prefixIcon: const Icon(Icons.money),
                          ),
                          keyboardType: TextInputType.number,
                          validator: Validatorless.multiple(
                            [
                              Validatorless.required(
                                  'O campo preço é obrigatório'),
                              Validatorless.regex(RegExp(r'^[0-9.]+$'),
                                  'Somente numeros e ponto'),
                              Validatorless.numbersBetweenInterval(
                                  0.01,
                                  1000000,
                                  "O preço deve ser estar entre 0 e 1000000")
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        DropdownButton(
                          value: dropdownValue ?? initialDropdownValue,
                          items: const [
                            DropdownMenuItem(
                                value: 'racao', child: Text('Ração')),
                            DropdownMenuItem(
                                value: 'brinquedo', child: Text('Brinquedo')),
                            DropdownMenuItem(
                                value: 'remedio', child: Text('Remédio')),
                            DropdownMenuItem(
                                value: 'outro', child: Text('Outros')),
                          ],
                          onChanged: (newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  // const SizedBox(height: 25),
                  // OutlinedButton(
                  //   onPressed: () => _showDatePicker(
                  //       parameterDate: initialChosenDate,
                  //       chosenDate: chosenDate ?? initialChosenDate),
                  //   style: const ButtonStyle(
                  //       elevation: MaterialStatePropertyAll(2)),
                  //   child: Text(
                  //     'Data\n ${chosenDate == null ? initialChosenDate.day : chosenDate!.day}/${chosenDate == null ? initialChosenDate.month : chosenDate!.month}/${chosenDate == null ? initialChosenDate.year : chosenDate!.year}',
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                    child: FilledButton(
                      style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(2),
                      ),
                      onPressed: () {
                        if (widget.formKey.currentState?.validate() == true) {
                          String sendName =
                              textName == null ? inititalName : textName!;
                          String sendPrice =
                              textPrice == null ? initialPrice : textPrice!;
                          String sendQuantity = textQuantity == null
                              ? initialQuantity
                              : textQuantity!;
                          _putProduct(
                            editProductId: widget.editProductid,
                            name: sendName,
                            type: dropdownValue ?? initialDropdownValue,
                            price: double.tryParse(
                                    sendPrice.replaceAll(",", "")) ??
                                0.0,
                            quantity: double.tryParse(
                                    sendQuantity.replaceAll(",", "")) ??
                                0.0,
                            creationDate: chosenDate ?? initialChosenDate,
                          ).then((_) {
                            widget.updateProducts();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: const Text('Editar'),
                    ),
                  )
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
