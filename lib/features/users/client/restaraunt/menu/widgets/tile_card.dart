import 'package:flutter/material.dart';
import '../models/menu_item.dart'; // UI-модель MenuItem

class MenuTileCard extends StatefulWidget {
  final MenuItem data;
  final ValueChanged<MenuItemVariant>
      onAddToCart; // теперь передаёт выбранный вариант
  final VoidCallback onTap; // переход на экран продукта
  final bool isNarrow;

  const MenuTileCard({
    super.key,
    required this.data,
    required this.onAddToCart,
    required this.onTap,
    this.isNarrow = false,
  });

  @override
  State<MenuTileCard> createState() => _MenuTileCardState();
}

class _MenuTileCardState extends State<MenuTileCard> {
  late MenuItemVariant _selectedVariant;

  @override
  void initState() {
    super.initState();
    // Выбираем вариант по умолчанию (помеченный как isDefault или первый)
    _selectedVariant = widget.data.variants.firstWhere(
      (v) => v.isDefault,
      orElse: () => widget.data.variants.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isNarrow
        ? _buildNarrowLayout(context)
        : _buildWideLayout(context);
  }

  // ===========================================================================
  // Широкий макет (вертикальная карточка) – стиль полностью из исходного кода
  // ===========================================================================
  Widget _buildWideLayout(BuildContext context) {
    final theme = Theme.of(context);
    final hasVariants = widget.data.variants.length > 1;

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Изображение (высота 120 как было) ---
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.data.fullImageUrl,
                  width: double.infinity,
                  height: 180, // исходная высота
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: double.infinity,
                      height: 180,
                      color: Colors.grey[800],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 180,
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(Icons.restaurant_menu,
                            size: 80, color: Colors.green),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),

              // --- Название (оригинальные стили) ---
              Text(
                widget.data.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // --- Категория или описание (оригинальный стиль) ---
              Text(
                widget.data.description ?? widget.data.category,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),

              // --- Описание (если есть) – оригинальное обрезание ---
              if (widget.data.description != null &&
                  widget.data.description!.isNotEmpty)
                Text(
                  widget.data.description!,
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

              const Spacer(),

              // --- Нижний блок с ценой, выбором размера и кнопкой ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Кнопки выбора размера (только если есть варианты)
                        if (hasVariants)
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: widget.data.variants.map((v) {
                                final isSelected = v.id == _selectedVariant.id;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: ActionChip(
                                    label: Text(
                                      v.name,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    backgroundColor: isSelected
                                        ? Colors.white
                                        : Colors.grey[800],
                                    onPressed: () =>
                                        setState(() => _selectedVariant = v),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        const SizedBox(height: 4),
                        // Цена (динамическая, зависит от выбранного варианта)
                        Text(
                          '${_selectedVariant.price} ₽',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Кнопка добавления в корзину (как была)
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
                      onPressed: widget.data.isAvailable
                          ? () => widget.onAddToCart(_selectedVariant)
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Узкий макет (горизонтальная карточка) – стиль полностью из исходного кода
  // ===========================================================================
  Widget _buildNarrowLayout(BuildContext context) {
    final theme = Theme.of(context);
    final hasVariants = widget.data.variants.length > 1;

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Изображение (фиксированная ширина 90, высота 90) ---
              SizedBox(
                width: 90,
                height: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.data.fullImageUrl,
                    height: 90,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 90,
                        height: 90,
                        color: Colors.grey[800],
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 90,
                        height: 90,
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(Icons.restaurant_menu,
                              size: 50, color: Colors.green),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // --- Информация (оригинальное расположение) ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.data.description ?? widget.data.category,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    // --- Цена, выбор размера и кнопка ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (hasVariants)
                                Wrap(
                                  spacing: 4,
                                  children: widget.data.variants.map((v) {
                                    final isSelected =
                                        v.id == _selectedVariant.id;
                                    return ActionChip(
                                      label: Text(
                                        v.name,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                      backgroundColor: isSelected
                                          ? Colors.white
                                          : Colors.grey[800],
                                      onPressed: () =>
                                          setState(() => _selectedVariant = v),
                                    );
                                  }).toList(),
                                ),
                              Text(
                                '${_selectedVariant.price} ₽',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 40,
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
                            icon: const Icon(Icons.add,
                                color: Colors.black, size: 24),
                            onPressed: widget.data.isAvailable
                                ? () => widget.onAddToCart(_selectedVariant)
                                : null,
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
      ),
    );
  }
}
