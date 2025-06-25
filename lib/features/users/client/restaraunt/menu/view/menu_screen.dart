import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import '/core/services/alert_dialog.dart';
import '/core/hive/models/menu/menu.dart';
import '../widgets/app_bar.dart';
import '../widgets/tile_card.dart';
import '../bloc/menu_bloc.dart';
import 'package:flutter_application_restaraunt/core/repositories/restaraunt/menu/repository/abstract_menu.dart';

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
    _menuBloc = MenuBloc(GetIt.I<AbstractMenuRepository>())..add(LoadMenu());
  }

  @override
  void dispose() {
    _menuBloc.close();
    super.dispose();
  }

  List<Menu> _getFilteredMenu(List<Menu> menuList) {
    return _selectedCategory == null
        ? menuList
        : menuList.where((m) => m.category == _selectedCategory).toList();
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
              final categories = state.menuList
                  .map((m) => m.category)
                  .toSet()
                  .toList()
                ..sort();

              final filteredMenu = _getFilteredMenu(state.menuList);
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
                        ? _buildMenuList(filteredMenu, isNarrow: true)
                        : _buildMenuGrid(filteredMenu, crossAxisCount, isNarrow: false),
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

  // Строит список для узких экранов
  SliverList _buildMenuList(List<Menu> filteredMenu, {required bool isNarrow}) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final menu = filteredMenu[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: MenuTileCard(
              data: menu,
              isNarrow: isNarrow,
              onAddToCart: () => _addToCart(context, menu),
            ),
          );
        },
        childCount: filteredMenu.length,
      ),
    );
  }

  // Строит сетку для широких экранов
  SliverGrid _buildMenuGrid(List<Menu> filteredMenu, int crossAxisCount, {required bool isNarrow}) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final menu = filteredMenu[index];
          return MenuTileCard(
            data: menu,
            isNarrow: isNarrow,
            onAddToCart: () => _addToCart(context, menu),
          );
        },
        childCount: filteredMenu.length,
      ),
    );
  }

  int _calculateCrossAxisCount(double screenWidth) {
    if (screenWidth > 1200) return 4;
    if (screenWidth > 900) return 3;
    if (screenWidth > 600) return 2;
    return 1;
  }

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
      title: isWideScreen ? (buildWideAppBar(context) as AppBar).title : Text('Меню', style: theme.textTheme.titleMedium),
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
    // Оборачиваем Row в SingleChildScrollView для горизонтальной прокрутки
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