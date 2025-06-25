import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/hive/models/menu/menu.dart';
import '../bloc/product_bloc.dart';
import '/core/router/router.dart'; // Убедитесь, что импортировали ваш роутер для навигации

@RoutePage()
class ProductScreen extends StatelessWidget {
  final int id;
  const ProductScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    // Обертываем в BlocProvider для управления состоянием этой страницы
    return BlocProvider(
      create: (_) => ProductBloc()..add(LoadProduct(productId: id)),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          // Показываем индикатор загрузки, пока данные о продукте загружаются
          if (state is ProductLoading) {
            return const Scaffold(
              backgroundColor: Color(0xFF1A191A),
              body: Center(child: CircularProgressIndicator(color: Colors.white)),
            );
          }
          // Показываем сообщение об ошибке, если загрузка не удалась
          else if (state is ProductLoadingFailure) {
            return Scaffold(
              backgroundColor: const Color(0xFF1A191A),
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.router.pop(), // Возвращаемся назад
                ),
              ),
              body: const Center(
                child: Text('Ошибка загрузки продукта', style: TextStyle(color: Colors.white70)),
              ),
            );
          }
          // Отображаем страницу, когда продукт успешно загружен
          else if (state is ProductLoaded) {
            final Menu product = state.product;
            final theme = Theme.of(context);
            final isWide = MediaQuery.of(context).size.width > 600;

            return Scaffold(
              backgroundColor: const Color(0xFF1A191A), // Устанавливаем тёмный фон
              appBar: AppBar(
                backgroundColor: Colors.transparent, // Прозрачный AppBar для слияния с фоном
                elevation: 0,
                // Кнопка "назад", которая ведет на MenuScreen
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.router.pop(),
                ),
                // Название продукта по центру
                title: Text(
                  product.name,
                  style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView( // Позволяет прокручивать контент
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch, // Растягиваем дочерние элементы
                      children: [
                        // --- Изображение продукта ---
                        if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              product.fullImageUrl,
                              height: isWide ? 300 : 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: isWide ? 300 : 220,
                                color: Colors.grey[850],
                                child: const Icon(Icons.no_photography, color: Colors.white24, size: 60),
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),

                        // --- Контейнер-форма для деталей ---
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF242526), // Фон формы, чуть светлее основного
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // --- Большой заголовок (название) ---
                              Text(
                                product.name,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // --- Описание продукта ---
                              if (product.description != null && product.description!.isNotEmpty)
                                Text(
                                  product.description!,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white70,
                                    height: 1.5,
                                    fontSize: 20
                                  ),
                                ),
                              const SizedBox(height: 16),

                              // --- Детали продукта (поля поменьше) ---
                              _buildDetailRow(context, label: 'Категория', value: product.category),
                              _buildDetailRow(context, label: 'Артикул (SKU)', value: product.sku ?? 'Не указан'),
                              if (product.value != null && product.unit != null)
                                _buildDetailRow(context, label: 'Объем/Вес', value: '${product.value} ${product.unit}'),
                              
                              const Divider(color: Colors.white24, height: 32),

                              // --- Цена ---
                              _buildDetailRow(context, label: 'Цена', value: '${product.price} ₽', isPrice: true),
                              
                              const SizedBox(height: 32),

                              // --- Кнопка добавления в корзину ---
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: product.isAvailable ? theme.primaryColor : Colors.grey[800],
                                    foregroundColor: product.isAvailable ? Colors.black : Colors.white38,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    textStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: product.isAvailable ? () => {_addToCart(context, product)} : null,
                                  child: Text(product.isAvailable ? 'Добавить в корзину' : 'Нет в наличии', style: theme.textTheme.titleMedium?.copyWith(color: Colors.black),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          // Возвращаем пустой контейнер по умолчанию
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // Вспомогательный виджет для отображения строки "поле: значение"
  Widget _buildDetailRow(BuildContext context, {required String label, required String value, bool isPrice = false}) {
    final theme = Theme.of(context);
    
    // Стиль для цены
    final priceStyle = theme.textTheme.headlineSmall?.copyWith(
      color: Colors.white, 
      fontWeight: FontWeight.bold
    );
    // Стиль для значения обычного поля
    final valueStyle = theme.textTheme.bodyLarge?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w500
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Метка (название поля)
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white60),
          ),
          const SizedBox(width: 16),
          // Значение поля (гибкое, чтобы переноситься при необходимости)
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: isPrice ? priceStyle : valueStyle,
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context, Menu menu) {
    // Реализация добавления в корзину
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавлено'),
        content: Text('${menu.name} добавлен в корзину', style: TextStyle(color: Colors.black),),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.black),),
          ),
        ],
      ),
    );
  }
}