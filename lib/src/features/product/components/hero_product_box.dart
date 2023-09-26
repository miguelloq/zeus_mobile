import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeus_app/src/features/product/components/edit_product_modal.dart';

import '../services/product_service.dart';

class HeroProductBox extends StatefulWidget {
  final double horizontalPadding;
  final double verticalPadding;
  final String id;
  final String name;
  final String type;
  final double price;
  final double quantity;
  final DateTime creationDate;
  final DateTime? lastEditeDate;
  final Function updateProducts;

  const HeroProductBox({
    super.key,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.creationDate,
    required this.quantity,
    required this.updateProducts,
    this.lastEditeDate,
  });

  @override
  State<HeroProductBox> createState() => _HeroProductBoxState();
}

class _HeroProductBoxState extends State<HeroProductBox> {
  late final ProductService productService;

  @override
  void initState() {
    productService = context.read<ProductService>();
    super.initState();
  }

  void _deleteProduct({required String id}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            "O produto de nome ${widget.name} será deletado. Tem certeza?"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              try {
                productService.deleteProduct(id: id);
                widget.updateProducts();
                Navigator.pop(context);
                Navigator.pop(context);
              } catch (e) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Erro ao deletar o produto"),
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
            },
            child: const Text("Deletar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Hero(
      tag: widget.id,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          widget.horizontalPadding,
          widget.verticalPadding,
          widget.horizontalPadding,
          widget.verticalPadding,
        ),
        child: Material(
          elevation: 2,
          color: Theme.of(context).colorScheme.secondaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Text(
                    widget.name,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Text(
                    widget.type,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 30),
                  const Divider(thickness: 2),
                  const SizedBox(height: 30),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Preço: R\$ ${widget.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Quantidade: ${widget.quantity.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Data da compra: ${widget.creationDate.day}/${widget.creationDate.month}/${widget.creationDate.year}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        widget.lastEditeDate != null
                            ? 'Última edição: ${widget.lastEditeDate!.day}/${widget.lastEditeDate!.month}/${widget.lastEditeDate!.year}'
                            : 'Última edição: Não foi editado',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Divider(thickness: 2),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FilledButton(
                          onPressed: () {
                            _deleteProduct(id: widget.id);
                          },
                          child: const Text('Remover')),
                      FilledButton(
                          onPressed: () {
                            editProductModal(
                                context: context,
                                height: MediaQuery.sizeOf(context).height,
                                width: MediaQuery.sizeOf(context).width,
                                formKey: formKey,
                                editProductId: widget.id,
                                updateProducts: widget.updateProducts);
                          },
                          child: const Text('Editar')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
