import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:zeus_app/src/features/product/components/add_product_modal.dart';
import 'package:zeus_app/src/features/product/components/custom_sliver_appbar.dart';
import 'package:zeus_app/src/features/product/components/product_box.dart';
import 'package:zeus_app/src/features/product/models/product_model.dart';
import 'package:zeus_app/src/features/product/vm/product_vm.dart';

import '../../core/models/theme_model.dart';
import '../../core/utils/hero_dialog_route.dart';
import 'components/hero_product_box.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late final ThemeModel themeModel;
  late final ProductVM productVM;
  late final List<bool> isToggleSelected;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    themeModel = context.read<ThemeModel>();
    productVM = context.read<ProductVM>();
    isToggleSelected = [true, false, false];
    productVM.updateProducts();
  }

  void updateToggle(int newIndex) {
    var allVisibleOption = [
      VisibleOption.sevenDays,
      VisibleOption.thirtyDays,
      VisibleOption.all
    ];
    for (int index = 0; index < isToggleSelected.length; index++) {
      if (index == newIndex) {
        isToggleSelected[index] = true;
        productVM.updateVisibility(newOption: allVisibleOption[index]);
      } else {
        isToggleSelected[index] = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: RefreshIndicator(
        onRefresh: () => productVM.updateProducts(),
        child: CustomScrollView(slivers: [
          CustomSliverAppbar(themeModel: themeModel),
          Observer(
            builder: (_) => SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 35),
                  ToggleButtons(
                    isSelected: isToggleSelected,
                    onPressed: updateToggle,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text('7 dias',
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text('30 dias',
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text('Todos',
                            style: Theme.of(context).textTheme.titleMedium),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  if (productVM.screenState == VMState.loaded)
                    Material(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Preço total: ${productVM.productsTotalPrice.toStringAsFixed(2)}",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Observer(
            builder: (_) => switch (productVM.screenState) {
              (VMState.error) => SliverToBoxAdapter(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25),
                    Text(
                        'Algo inesperado aconteceu aqui.\n Erro: ${productVM.errorMessage!}'),
                  ],
                )),
              (VMState.idle) => SliverToBoxAdapter(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 25),
                      Text(
                        'Nenhum produto encontrado.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              (VMState.loading) => const SliverToBoxAdapter(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              (VMState.loaded) => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: productVM.visibleProducts.length,
                    (context, index) {
                      ProductModel currentProduct =
                          productVM.visibleProducts[index];
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              HeroDialogRoute(
                                builder: (context) => HeroProductBox(
                                  horizontalPadding:
                                      MediaQuery.sizeOf(context).width * .05,
                                  verticalPadding:
                                      MediaQuery.sizeOf(context).height * .2,
                                  id: currentProduct.id!,
                                  name: currentProduct.name,
                                  type: currentProduct.typeVisualise,
                                  price: currentProduct.price,
                                  quantity: currentProduct.quantity,
                                  creationDate: currentProduct.purchaseTime,
                                  lastEditeDate: currentProduct.lastEditTime,
                                  updateProducts: productVM.updateProducts,
                                ),
                              ),
                            );
                          },
                          child: ProductBox(
                            id: currentProduct.id!,
                            name: currentProduct.name,
                            price: currentProduct.price,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            },
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addProductModal(
              context: context,
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              formKey: formKey,
              updateProducts: productVM.updateProducts);
        },
        label: const Text('Adicionar Produto'),
      ),
    );
  }
}
