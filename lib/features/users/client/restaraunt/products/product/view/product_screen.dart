import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/product_bloc.dart';
import '/core/repositories/users/client/restaraunt/products/products.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, @PathParam('productName') required this.productName});

  final String productName;

  @override
  State<ProductScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductScreen> {
  final ProductBloc _productBloc = ProductBloc(GetIt.I<AbstractProductsRepository>());

  @override
  void initState() {
    _productBloc.add(LoadProduct(productName: widget.productName));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(
          child: Text(
            '${widget.productName}',
            style: theme.appBarTheme.titleTextStyle,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final completer = Completer();
          _productBloc.add(LoadProduct(productName: widget.productName, completer: completer));
          return completer.future;
        },
        child: BlocBuilder<ProductBloc, ProductState>(
          bloc: _productBloc,
          builder: (context, state) {
            if (state is ProductLoaded) {
              final product = state.product;
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            product.fullImageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(left: 100),
                        child: Text('Название: ${product.name}', style: theme.textTheme.headlineLarge),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 100),
                        child: Text(
                          'Категория: ${product.category.russianUpperCase}',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.only(left: 100),
                        child: Text('Описание: ', style: theme.textTheme.titleLarge),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 100),
                        child: Text(product.description, style: theme.textTheme.bodyLarge),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.only(left: 100),
                        child: Text(
                          '${product.price} ₽',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: SizedBox(
                          width: screenWidth > 600 ? 600 : screenWidth * 0.8,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: theme.elevatedButtonTheme.style,
                            child: const Text('Добавить в корзину'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
            if (state is ProductLoadingFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Что-то пошло не так',
                      style: theme.textTheme.headlineMedium,
                    ),
                    Text(
                      'Пожалуйста, попробуйте позже',
                      style: theme.textTheme.labelSmall?.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    TextButton(
                      onPressed: () {
                        _productBloc.add(LoadProduct(productName: widget.productName));
                      },
                      child: const Text('Попробовать снова'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
