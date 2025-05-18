import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/repositories/services/jwt_tokens/jwt_tokens.dart';
import '/core/repositories/restaraunt/products/products.dart';
import '/core/repositories/restaraunt/carts/carts.dart';
import '/core/hive/models/models.dart';
import '/core/hive/models/header_boxes.dart';
import '../bloc/menu_bloc.dart';
import '../../products/product/widgets/widgets.dart';
import '../widgets/app_bar.dart';
import '/core/router/router.dart';

@RoutePage()
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late final MenuBloc _menuBloc;
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();
    
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Container(
        color: Colors.grey[200],
        child: Center(
          child: Text(
            'Ошибка загрузки',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    };
    
    _menuBloc = MenuBloc(
      GetIt.I<AbstractJWTTokensRepository>(),
      GetIt.I<AbstractProductsRepository>(),
      GetIt.I<AbstractCartsRepository>(),
    );
    _menuBloc.add(LoadMenu());
    
    _menuBloc.stream.listen((state) {
      if (state is MenuLoaded) {
        print('Загружено ${state.productsList.length} продуктов');
        if (state.productsList.isNotEmpty) {
          print('Первый продукт: ${state.productsList[0].name}');
        }
      }
    });
  }

  @override
  void dispose() {
    _menuBloc.close();
    super.dispose();
  }
  List<Product> _getFilteredProducts(List<Product> products) {
    if (_selectedCategory == null) {
      return products;
    }
    return products.where((product) => product.category == _selectedCategory).toList();
  }

  void _addToCart(Product product) {
    final cartItem = Cart(
      id: product.id,
      name: product.name,
      price: product.price,
      imageUrl: product.imageUrl,
      count: 1,
    );
    _menuBloc.add(AddItemCartMenu(cartItem: cartItem));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} добавлен в корзину'),
        action: SnackBarAction(
          label: 'Перейти в корзину',
          onPressed: () {
            AutoRouter.of(context).push(CartRoute());
          },
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth >= 800;

    return BlocProvider.value(
      value: _menuBloc,
      child: Builder(
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: isWideScreen ? buildWideAppBar(context) : buildNarrowAppBar(context),
            body: BlocBuilder<MenuBloc, MenuState>(
              bloc: _menuBloc,
              builder: (context, state) {
                final theme = Theme.of(context);
                
                if (state is MenuLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is MenuLoadingFailure) {
                  return Center(
                    child: Text(
                      'Ошибка загрузки: ${state.exception}',
                      style: theme.textTheme.titleMedium,
                    ),
                  );
                } else if (state is MenuLoaded) {
                  final filteredProducts = _getFilteredProducts(state.productsList);
                  
                  if (filteredProducts.isEmpty) {
                    return Center(
                      child: Text(
                        'Продукты не найдены',
                        style: theme.textTheme.headlineSmall,
                      ),
                    );
                  }
                  
                  int crossAxisCount;
                  if (screenWidth > 1200) {
                    crossAxisCount = 4;
                  } else if (screenWidth > 900) {
                    crossAxisCount = 3;
                  } else if (screenWidth > 600) {
                    crossAxisCount = 2;
                  } else {
                    crossAxisCount = 1;
                  }
                  
                  return Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1500),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            color: theme.scaffoldBackgroundColor.withOpacity(0.95),
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              alignment: WrapAlignment.start,
                              children: [
                                const SizedBox(width: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedCategory = null;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _selectedCategory == null
                                          ? theme.primaryColor
                                          : theme.scaffoldBackgroundColor,
                                      foregroundColor: _selectedCategory == null
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          color: _selectedCategory == null
                                              ? Colors.transparent
                                              : Colors.white.withOpacity(0.2),
                                        ),
                                      ),
                                    ),
                                    child: const Text('Все категории'),
                                  ),
                                ),
                                ...Category.values.map((category) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _selectedCategory = category;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _selectedCategory == category
                                            ? theme.primaryColor
                                            : theme.scaffoldBackgroundColor,
                                        foregroundColor: _selectedCategory == category
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          side: BorderSide(
                                            color: _selectedCategory == category
                                                ? Colors.transparent
                                                : Colors.white.withOpacity(0.2),
                                          ),
                                        ),
                                      ),
                                      child: Text(category.russianUpperCase),
                                    ),
                                  );
                                }).toList(),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                final completer = Completer();
                                _menuBloc.add(LoadMenu(completer: completer));
                                return completer.future;
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    childAspectRatio: 0.75,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    mainAxisExtent: screenWidth <= 300 ? 400 : null,
                                  ),
                                  itemCount: filteredProducts.length,
                                  itemBuilder: (context, index) {
                                    final product = filteredProducts[index];
                                    return ProductTileCard(
                                      product: product,
                                      onAddToCart: () => _addToCart(product),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          );
      },
    ),
  );
  }
}