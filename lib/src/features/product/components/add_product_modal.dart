// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';
import 'package:zeus_app/src/features/product/models/product_model.dart';
import 'package:zeus_app/src/features/product/services/product_service.dart';

class AuxDropDown {
  final String value;
  final String visibleValue;
  AuxDropDown({
    required this.value,
    required this.visibleValue,
  });
}

addProductModal({
  required BuildContext context,
  required double height,
  required double width,
  required GlobalKey<FormState> formKey,
  required Function updateProducts,
}) {
  showModalBottomSheet(
    isScrollControlled: true,
    shape: const BeveledRectangleBorder(),
    enableDrag: false,
    context: context,
    builder: (BuildContext context) => _AddProductWidget(
      height: height,
      width: width,
      formKey: formKey,
      updateProducts: updateProducts,
    ),
  );
}

class _AddProductWidget extends StatefulWidget {
  final double height;
  final double width;
  final GlobalKey<FormState> formKey;
  final Function updateProducts;
  const _AddProductWidget(
      {super.key,
      required this.height,
      required this.width,
      required this.formKey,
      required this.updateProducts});

  @override
  State<_AddProductWidget> createState() => _AddProductWidgetState();
}

class _AddProductWidgetState extends State<_AddProductWidget> {
  var chosenDate = DateTime.now();
  final nameEC = TextEditingController();
  final priceEC = TextEditingController();
  final quantityEC = TextEditingController();
  late final ProductService productService;

  List<AuxDropDown> auxDropDowns = [
    AuxDropDown(value: 'Ração', visibleValue: ProductType.racao.toString()),
    AuxDropDown(
        value: 'Brinquedo', visibleValue: ProductType.brinquedo.toString()),
    AuxDropDown(value: 'Remédio', visibleValue: ProductType.remedio.toString()),
    AuxDropDown(value: 'Outro', visibleValue: ProductType.outro.toString()),
  ];
  String dropdownValue = 'racao';

  @override
  void initState() {
    productService = context.read<ProductService>();
    super.initState();
  }

  @override
  void dispose() {
    nameEC.dispose();
    super.dispose();
  }

  Future<void> _postProduct({
    required String name,
    required String type,
    required double price,
    required DateTime creationDate,
    required double quantity,
  }) async {
    try {
      await productService.postProduct(newProduct: {
        'name': name,
        'type': type,
        'price': price,
        'quantity': quantity,
        'purchaseTime': creationDate.toUtc().toIso8601String()
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error em adicionar compra no banco de dados. Error $e"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Fechar"))
          ],
        ),
      );
    }
  }

  void _showDatePicker() {
    DateTime currentDate = DateTime.now();
    showDatePicker(
            context: context,
            initialDate: chosenDate,
            currentDate: currentDate,
            firstDate: currentDate.subtract(const Duration(days: 50)),
            lastDate: currentDate.add(const Duration(days: 50)))
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
              'Adicione uma compra!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: nameEC,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      labelText: 'Nome',
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground),
                      prefixIcon: const Icon(Icons.abc_rounded),
                    ),
                    validator: Validatorless.multiple([
                      Validatorless.required('O campo nome é obrigatório.'),
                      Validatorless.between(3, 24,
                          'O nome deve ter o tamanho entre 3 e 24 caracteres.'),
                    ]),
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: quantityEC,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      labelText: 'Quantidade(Somente numeros e ponto)',
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground),
                      prefixIcon: const Icon(Icons.scale_rounded),
                    ),
                    keyboardType: TextInputType.number,
                    validator: Validatorless.multiple(
                      [
                        Validatorless.required(
                            'O campo quantidade é obrigatório'),
                        Validatorless.regex(
                            RegExp(r'^[0-9.]+$'), 'Somente numeros e ponto'),
                        Validatorless.numbersBetweenInterval(0.001, 10000,
                            "A quantidade deve estar entre 0 e 10000")
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: priceEC,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      labelText: 'Preço(Somente numeros e ponto)',
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground),
                      prefixIcon: const Icon(Icons.money),
                    ),
                    keyboardType: TextInputType.number,
                    validator: Validatorless.multiple(
                      [
                        Validatorless.required('O campo preço é obrigatório'),
                        Validatorless.regex(
                            RegExp(r'^[0-9.]+$'), 'Somente numeros e ponto'),
                        Validatorless.numbersBetweenInterval(0.001, 1000000,
                            "O preço deve ser estar entre 0 e 1000000")
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            DropdownButton(
              value: dropdownValue,
              items: const [
                DropdownMenuItem(value: 'racao', child: Text('Ração')),
                DropdownMenuItem(value: 'brinquedo', child: Text('Brinquedo')),
                DropdownMenuItem(value: 'remedio', child: Text('Remédio')),
                DropdownMenuItem(value: 'outro', child: Text('Outro')),
              ],
              onChanged: (newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
            ),
            const SizedBox(height: 25),
            OutlinedButton(
              onPressed: _showDatePicker,
              style: const ButtonStyle(elevation: MaterialStatePropertyAll(2)),
              child: Text(
                'Data\n ${chosenDate.day}/${chosenDate.month}/${chosenDate.year}',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            FilledButton(
              style: const ButtonStyle(
                elevation: MaterialStatePropertyAll(2),
              ),
              onPressed: () {
                if (widget.formKey.currentState?.validate() == true) {
                  _postProduct(
                    name: nameEC.text,
                    type: dropdownValue,
                    price: double.tryParse(priceEC.text.replaceAll(",", "")) ??
                        0.0,
                    quantity:
                        double.tryParse(quantityEC.text.replaceAll(",", "")) ??
                            0.0,
                    creationDate: chosenDate,
                  ).then((value) {
                    widget.updateProducts();
                    Navigator.pop(context);
                  });
                }
              },
              child: const Text('Adicionar'),
            )
          ],
        ),
      ),
    );
  }
}
