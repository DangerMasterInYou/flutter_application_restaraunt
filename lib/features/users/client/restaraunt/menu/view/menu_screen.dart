import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_application_restaraunt/features/users/client/restaraunt/product/view/product_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import '/core/hive/models/menu/menu.dart';
import '/core/repositories/users/client/restaraunt/carts/carts.dart';
import '../widgets/app_bar.dart';
import '../widgets/tile_card.dart';
import '../bloc/menu_bloc.dart';
import 'package:flutter_application_restaraunt/core/repositories/restaraunt/menu/repository/abstract_menu.dart';
import '../models/menu_item.dart'; // UI-модель

@RoutePage()
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late final MenuBloc _menuBloc;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _menuBloc = MenuBloc(
      GetIt.I<AbstractMenuRepository>(),
      GetIt.I<AbstractCartRepository>(),
    )..add(LoadMenu());
  }

  @override
  void dispose() {
    _menuBloc.close();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Вспомогательный метод: оставляет только первую строку описания (до \n)
  // ---------------------------------------------------------------------------
  String? _cleanDescription(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return raw.split('\n').first.trim();
  }

  // ---------------------------------------------------------------------------
  // Группировка оригинальных Menu в UI‑модели MenuItem
  // ---------------------------------------------------------------------------
  List<MenuItem> _groupMenuItems(List<Menu> menuList) {
    // Регулярное выражение для отделения размера/объёма в конце названия
    // Удаляет числа с единицами (гр, г, мл, л, кг, шт) или слова‑размеры
    final sizeRegex = RegExp(
      r'\s+(?:\d+(?:\.\d+)?\s*(?:гр|г|мл|л|кг|шт)|Стандарт|Большая|Средняя|Маленькая)\s*$',
    );

    final Map<String, List<Menu>> grouped = {};

    for (final item in menuList) {
      // Извлекаем базовое имя, убирая размер/объём в конце
      final baseName = item.name.replaceFirst(sizeRegex, '').trim();
      // Ключ группировки: базовое имя + imageUrl (чтобы различать блюда с одинаковым названием, но разной картинкой)
      final key = '$baseName|${item.imageUrl ?? ''}';
      grouped.putIfAbsent(key, () => []).add(item);
    }

    return grouped.values.map((items) {
      // Если только один элемент – создаём MenuItem с одним вариантом
      if (items.length == 1) {
        final m = items.first;
        return MenuItem(
          name: m.name,
          description: _cleanDescription(m.description), // <-- чистим описание
          imageUrl: m.imageUrl,
          category: m.category,
          sku: m.sku,
          isAvailable: m.isAvailable,
          modifierGroups: m.modifierGroups,
          variants: [
            MenuItemVariant(
              id: m.id,
              name: m.value != null && m.unit != null
                  ? '${m.value} ${m.unit}'
                  : m.name,
              price: m.price,
              value: m.value,
              unit: m.unit,
              isDefault: true,
            )
          ],
        );
      }

      // Несколько размеров → собираем варианты
      final variants = <MenuItemVariant>[];

      // Определяем базовое имя для всего блюда (из первого элемента, убрав размер)
      final first = items.first;
      final baseName = first.name.replaceFirst(sizeRegex, '').trim();

      for (final m in items) {
        // Имя варианта: либо «value unit» (если есть), либо то, что осталось после удаления базового имени
        String variantName;
        if (m.value != null && m.unit != null) {
          variantName = '${m.value} ${m.unit}';
        } else {
          // Убираем базовое имя из полного названия, оставляя только часть с размером
          variantName = m.name.replaceFirst(baseName, '').trim();
          if (variantName.isEmpty) {
            // Если всё же пусто (например, базовое имя совпало с полным), берём последнее слово
            variantName = m.name.split(' ').last;
          }
        }

        variants.add(
          MenuItemVariant(
            id: m.id,
            name: variantName,
            price: m.price,
            value: m.value,
            unit: m.unit,
            isDefault: m.name.contains('Стандарт'),
          ),
        );
      }

      return MenuItem(
        name: baseName,
        description:
            _cleanDescription(first.description), // <-- чистим описание
        imageUrl: first.imageUrl,
        category: first.category,
        sku: first.sku,
        isAvailable: first.isAvailable,
        modifierGroups: first.modifierGroups,
        variants: variants,
      );
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // Фильтрация по категории (работаем с MenuItem)
  // ---------------------------------------------------------------------------
  List<MenuItem> _getFilteredItems(List<MenuItem> items) {
    if (_selectedCategory == null) return items;
    return items.where((item) => item.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth >= 800;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => _menuBloc,
      child: Scaffold(
        body: BlocConsumer<MenuBloc, MenuState>(
          listener: (context, state) {
            if (state is MenuLoadingFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ошибка загрузки')),
              );
            }
          },
          builder: (context, state) {
            if (state is MenuLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MenuLoadingFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Ошибка загрузки', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _menuBloc.add(LoadMenu()),
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              );
            }

            if (state is MenuLoaded) {
              // 1. Группируем Menu → List<MenuItem>
              final menuItems = _groupMenuItems(state.menuList);

              // 2. Категории из сгруппированных данных
              final categories =
                  menuItems.map((m) => m.category).toSet().toList()..sort();

              // 3. Фильтрация
              final filteredItems = _getFilteredItems(menuItems);

              final crossAxisCount = _calculateCrossAxisCount(screenWidth);
              final isNarrow = crossAxisCount == 1;

              return CustomScrollView(
                slivers: [
                  _buildAppBar(isWideScreen, theme),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    sliver: SliverToBoxAdapter(
                      child: _buildCategoryButtons(categories, theme),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: isNarrow
                        ? _buildMenuList(filteredItems, isNarrow: true)
                        : _buildMenuGrid(filteredItems, crossAxisCount,
                            isNarrow: false),
                  ),
                ],
              );
            }

            return const Center(child: Text('Неизвестное состояние'));
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Построение списка / сетки
  // ---------------------------------------------------------------------------
  SliverList _buildMenuList(List<MenuItem> items, {required bool isNarrow}) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: MenuTileCard(
              data: item,
              isNarrow: isNarrow,
              onTap: () => _openProductScreen(item),
              onAddToCart: (variant) => _quickAddToCart(item, variant),
            ),
          );
        },
        childCount: items.length,
      ),
    );
  }

  SliverGrid _buildMenuGrid(List<MenuItem> items, int crossAxisCount,
      {required bool isNarrow}) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = items[index];
          return MenuTileCard(
            data: item,
            isNarrow: isNarrow,
            onTap: () => _openProductScreen(item),
            onAddToCart: (variant) => _quickAddToCart(item, variant),
          );
        },
        childCount: items.length,
      ),
    );
  }

  int _calculateCrossAxisCount(double screenWidth) {
    if (screenWidth > 1200) return 4;
    if (screenWidth > 900) return 3;
    if (screenWidth > 600) return 2;
    return 1;
  }

  // ---------------------------------------------------------------------------
  // AppBar и кнопки категорий (без изменений)
  // ---------------------------------------------------------------------------
  SliverAppBar _buildAppBar(bool isWideScreen, ThemeData theme) {
    return SliverAppBar(
      leading: isWideScreen
          ? Padding(
              padding: const EdgeInsets.only(left: 15),
              child: _buildLogo(60),
            )
          : SizedBox(
              width: 80,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: _buildLogo(40),
              ),
            ),
      title: isWideScreen
          ? (buildWideAppBar(context) as AppBar).title
          : Text('Меню', style: theme.textTheme.titleMedium),
      actions: isWideScreen
          ? (buildWideAppBar(context) as AppBar).actions
          : (buildNarrowAppBar(context) as AppBar).actions,
      floating: true,
      pinned: true,
      snap: false,
      expandedHeight: isWideScreen ? 0 : null,
    );
  }

  Widget _buildLogo(double size) {
    return Center(
      child: Container(
        height: size,
        width: size,
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: ClipOval(
          child: SvgPicture.asset(
            'assets/svg/logo.svg',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButtons(List<String> categories, ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildCategoryButton(null, 'Все категории', theme),
          ...categories.map(
              (category) => _buildCategoryButton(category, category, theme)),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String? category, String text, ThemeData theme) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () => setState(() => _selectedCategory = category),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? theme.primaryColor
              : theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}),
          foregroundColor: isSelected
              ? const Color(0xFF1A1A1A)
              : theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected
                  ? Colors.transparent
                  : Colors.white.withOpacity(0.2),
            ),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Навигация и добавление в корзину
  // ---------------------------------------------------------------------------
  void _openProductScreen(MenuItem item) {
    final productId = item.variants.first.id;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductScreen(id: productId),
      ),
    );
  }

  void _quickAddToCart(MenuItem item, MenuItemVariant variant) {
    if (item.modifierGroups.isNotEmpty) {
      _openProductScreen(item);
      return;
    }

    _menuBloc.add(
      AddItemCartMenu(
        cartItemRequest: CartItemRequestDTO(
          productVariantId: variant.id,
          quantity: 1,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} (${variant.name}) добавлен в корзину'),
      ),
    );
  }
}
