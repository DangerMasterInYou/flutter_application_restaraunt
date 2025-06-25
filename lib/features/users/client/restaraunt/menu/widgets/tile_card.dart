import 'package:flutter/material.dart';
import 'package:flutter_application_restaraunt/features/users/client/restaraunt/product/view/product_screen.dart';
import '/core/hive/models/menu/menu.dart'; // Путь к вашей модели Menu

class MenuTileCard extends StatelessWidget {
  const MenuTileCard({
    super.key,
    required this.data,
    required this.onAddToCart,
    this.isNarrow = false,
  });

  final Menu data;
  final VoidCallback onAddToCart;
  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Переход на экран продукта, передавая id
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductScreen(id: data.id), // Передаем id продукта
          ),
        );
      },
      child: isNarrow
          ? _buildNarrowLayout(context)
          : _buildWideLayout(context),
    );
  }

  // Макет для широких экранов (вертикальная карточка)
  Widget _buildWideLayout(BuildContext context) {
    final theme = Theme.of(context);
    // Для более универсального отображения в сетке, можно задать фиксированную ширину/высоту карточки,
    // или позволить ей растягиваться, но ограничить внутренний контент.
    // В данном случае, LayoutBuilder не нужен, так как мы не зависим от Constraints напрямую.

    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias, // Важно для закругления содержимого
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Блок изображения с обработкой загрузки и ошибок ---
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                data.fullImageUrl,
                width: double.infinity,
                height: 120, // Фиксированная высота для изображения
                fit: BoxFit.cover,
                // Индикатор загрузки
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: double.infinity,
                    height: 120,
                    color: Colors.grey[800], // Фон для индикатора
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.white, // Цвет индикатора
                      ),
                    ),
                  );
                },
                // Заглушка при ошибке загрузки изображения (например, 404)
                errorBuilder: (context, error, stackTrace) {
                  // Здесь вы можете добавить логирование ошибки, если используете talker_flutter
                  // GetIt.instance<Talker>().handle(error, stackTrace); // Если Talker доступен
                  return Container(
                    width: double.infinity,
                    height: 120,
                    color: Colors.grey[800], // Темный фон
                    child: const Center(
                      child: Icon(
                        Icons.restaurant_menu, // Стандартная иконка еды
                        size: 80, // Размер иконки
                        color: Colors.green, // Цвет иконки
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // --- Название блюда ---
            Text(
              data.name,
              style: theme.textTheme.titleLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 2, // Ограничиваем название двумя строками
              overflow: TextOverflow.ellipsis, // Обрезаем с многоточием
            ),
            const SizedBox(height: 4),

            // --- Категория ---
            Text(
                        data.description ?? data.category,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 4),

            // --- Описание (с контролем переполнения) ---
            if (data.description != null && data.description!.isNotEmpty)
              Text(
                data.description!,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
                maxLines: 3, // Ограничиваем описание тремя строками
                overflow: TextOverflow.ellipsis, // Обрезаем с многоточием
              ),
            
            const Spacer(), // Заполняет оставшееся пространство, прижимая нижние элементы вниз

            // --- Цена и кнопка "Добавить в корзину" ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end, // Выравниваем по низу
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Занимает минимально необходимую высоту
                  children: [
                    if (data.value != null && data.unit != null)
                      Text(
                        '${data.price} ₽  ${data.value} ${data.unit}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    else
                      Text( // Используем else, чтобы избежать дублирования Text
                        '${data.price} ₽',
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.black),
                    onPressed: data.isAvailable ? onAddToCart : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // Адаптивный макет для узких экранов (горизонтальная карточка)
  Widget _buildNarrowLayout(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Блок изображения ---
            // Используем SizedBox, чтобы задать фиксированную ширину, но позволить высоте быть гибкой
            SizedBox(
              width: 90, // Уменьшенная, но фиксированная ширина для предсказуемости
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  data.fullImageUrl,
                  height: 90, // Та же высота, что и ширина для квадратного изображения
                  fit: BoxFit.cover,
                  // Индикатор загрузки
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey[800],
                      child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                    );
                  },
                  // Заглушка при ошибке
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(Icons.restaurant_menu, size: 50, color: Colors.green),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            // --- Блок с информацией ---
            // Expanded гарантирует, что этот блок займет все оставшееся место
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Распределяет пространство по вертикали
                children: [
                  // --- Верхняя часть: Название и категория ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        style: theme.textTheme.titleLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.description ?? data.category,
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  
                  // --- Нижняя часть: Цена и кнопка ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Expanded гарантирует, что текст цены не вытолкнет кнопку за пределы экрана
                      Expanded(
                        child: Text(
                          (data.value != null && data.unit != null)
                              ? '${data.price} ₽ / ${data.value} ${data.unit}'
                              : '${data.price} ₽',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          softWrap: true, // Разрешаем перенос текста
                        ),
                      ),
                      const SizedBox(width: 8), // Небольшой отступ между текстом и кнопкой
                      Container(
                        height: 40, // Явно задаем размер, чтобы избежать сюрпризов
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.add, color: Colors.black, size: 24),
                          onPressed: data.isAvailable ? onAddToCart : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}