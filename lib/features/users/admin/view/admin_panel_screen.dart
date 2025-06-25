import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_restaraunt/features/users/admin/bloc/admin_entities_bloc.dart';
import '/core/router/router.dart';
import '../widgets/widgets.dart';

@RoutePage()
class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  String expandedEntity = 'category';
  int? expandedItemId;

  @override
  void initState() {
    super.initState();
    // Диспатчим загрузку всех сущностей при инициализации
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<AdminEntitiesBloc>().add(LoadAllEntities());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminEntitiesBloc()..add(LoadAllEntities()), // MODIFIED HERE
      child: BlocConsumer<AdminEntitiesBloc, AdminEntitiesState>(
        listener: (context, state) {
          if (state is AdminEntityOperationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ошибка: ${state.message}')),
            );
          }
          if (state is AdminEntityOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Операция выполнена успешно')),
            );
          }
        },
        builder: (context, state) {
          final theme = Theme.of(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Административная панель',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  tooltip: 'Выйти',
                  onPressed: () {
                    context.router.replace(const LoginRoute());
                  },
                ),
              ],
              backgroundColor: theme.colorScheme.surface,
            ),
            backgroundColor: theme.brightness == Brightness.dark
                ? const Color(0xFF18191A)
                : Colors.grey[100],
            body: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                return Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _entityIndex(expandedEntity),
                      onDestinationSelected: (index) {
                        setState(() {
                          expandedEntity = _entities[index];
                          expandedItemId = null;
                        });
                      },
                      labelType: NavigationRailLabelType.all,
                      destinations: _entities
                          .map((e) => NavigationRailDestination(
                                icon: const Icon(Icons.folder),
                                label: Text(_entityLabel(e)),
                              ))
                          .toList(),
                    ),
                    Expanded(
                      child: _buildEntityList(context, state, expandedEntity,
                          expandedItemId, isWide),
                    ),
                  ],
                );
              },
            ),
            floatingActionButton: _buildFab(context, expandedEntity, state),
          );
        },
      ),
    );
  }

  static const _entities = [
    'category',
    'product',
    'variant',
    'modifier',
    'modifierGroup',
    'cart',
    'orders',
    'users',
  ];

  int _entityIndex(String? entity) =>
      entity == null ? 0 : _entities.indexOf(entity);

  String _entityLabel(String entity) {
    switch (entity) {
      case 'category':
        return 'Категории';
      case 'product':
        return 'Продукты';
      case 'variant':
        return 'Варианты';
      case 'modifier':
        return 'Модификаторы';
      case 'modifierGroup':
        return 'Группы модификаторов';
      case 'cart':
        return 'Корзины';
      case 'orders':
        return 'Заказы';
      case 'users':
        return 'Пользователи';
      default:
        return entity;
    }
  }

  Widget _buildFab(
      BuildContext context, String entity, AdminEntitiesState state) {
    switch (entity) {
      case 'category':
        return FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => CategoryCrudDialog(
                onSubmit: (name, sortOrder) {
                  context.read<AdminEntitiesBloc>().add(
                        CreateCategory(name: name, sortOrder: sortOrder),
                      );
                },
              ),
            );
          },
          child: const Icon(Icons.add),
          tooltip: 'Добавить категорию',
        );
      case 'product':
        return FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => ProductCrudDialog(
                // categories: categories,
                onSubmit: (categoryId, name, description, sortOrder, imageUrl) {
                  context.read<AdminEntitiesBloc>().add(
                        CreateProduct(
                          categoryId: categoryId,
                          name: name,
                          description: description,
                          imageUrl: imageUrl,
                          sortOrder: sortOrder,
                        ),
                      );
                },
              ),
            );
          },
          child: const Icon(Icons.add),
          tooltip: 'Добавить продукт',
        );
      case 'variant':
        final products = state is AdminEntitiesLoaded ? state.products : [];
        return FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => VariantCrudDialog(
                initialProductId:
                    products.isNotEmpty ? products.first.id : null,
                onSubmit: (
                    {required int productId,
                    required String name,
                    required int price,
                    required String sku,
                    required bool isAvailable,
                    required bool isCombo,
                    String? description,
                    String? imageUrl,
                    int? value,
                    String? unit}) {
                  context.read<AdminEntitiesBloc>().add(
                        CreateVariant(
                          productId: productId,
                          name: name,
                          price: price,
                          imageUrl: imageUrl ?? '', // MODIFIED
                        ),
                      );
                },
              ),
            );
          },
          child: const Icon(Icons.add),
          tooltip: 'Добавить вариант',
        );
      case 'modifier':
        final groups = state is AdminEntitiesLoaded
            ? state.modifierGroups
                .map((g) => {'id': g.id, 'name': g.name})
                .toList()
            : <Map<String, dynamic>>[];
        return FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => ModifierCrudDialog(
                groups: groups,
                onSubmit: (name, priceDelta, groupId) {
                  context.read<AdminEntitiesBloc>().add(
                        CreateModifier(
                            groupId: groupId,
                            name: name,
                            price: priceDelta),
                      );
                },
              ),
            );
          },
          child: const Icon(Icons.add),
          tooltip: 'Добавить модификатор',
        );
      case 'modifierGroup':
        return FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => ModifierGroupCrudDialog(
                onSubmit: (name, isRequired, isMultiselect) {
                  context.read<AdminEntitiesBloc>().add(
                        CreateModifierGroup(name: name, description: ''),
                      );
                },
              ),
            );
          },
          child: const Icon(Icons.add),
          tooltip: 'Добавить группу модификаторов',
        );
      case 'cart':
      case 'orders':
      case 'users':
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildEntityList(BuildContext context, AdminEntitiesState state,
      String entity, int? expandedId, bool isWide) {
    if (state is AdminEntitiesLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is AdminEntitiesError) {
      return Center(child: Text('Ошибка: ${state.message}'));
    }
    if (state is! AdminEntitiesLoaded) {
      return const SizedBox.shrink();
    }
    final items = _getItemsForEntity(state, entity);
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Нет данных для этой сущности.',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Text('Нажмите + чтобы создать.',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: items.length,
      itemBuilder: (context, idx) {
        final item = items[idx];
        final isExpanded = expandedId == idx;
        return Card(
          color:
              isExpanded ? Theme.of(context).colorScheme.surfaceVariant : null,
          child: InkWell(
            onTap: () {
              setState(() {
                expandedItemId = isExpanded ? null : idx;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: isExpanded
                  ? _buildFullItem(context, entity, item, isWide, state)
                  : _buildMiniItem(context, entity, item, isWide),
            ),
          ),
        );
      },
    );
  }

  List _getItemsForEntity(AdminEntitiesLoaded state, String entity) {
    switch (entity) {
      case 'category':
        return state.categories;
      case 'product':
        return state.products;
      case 'variant':
        return state.variants;
      case 'modifier':
        return state.modifiers;
      case 'modifierGroup':
        return state.modifierGroups;
      case 'cart':
      case 'orders':
      case 'users':
      default:
        return [];
    }
  }

  Widget _buildMiniItem(
      BuildContext context, String entity, dynamic item, bool isWide) {
    switch (entity) {
      case 'category':
        return Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.image, color: Colors.white38),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(item.name,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ],
        );
      case 'product':
        return Row(
          children: [
            if (item.imageUrl != null)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    item.fullImageUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, color: Colors.red);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ),
            if (item.imageUrl == null)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.image, color: Colors.white38),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(item.name,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ],
        );
      case 'variant':
        return Row(
          children: [
            if (item.imageUrl != null)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    item.fullImageUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, color: Colors.red);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ),
            if (item.imageUrl == null)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.image, color: Colors.white38),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(item.name,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ],
        );
      case 'modifier':
        return Row(
          children: [
            const Icon(Icons.tune),
            const SizedBox(width: 16),
            Expanded(
              child: Text(item.name,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ],
        );
      case 'modifierGroup':
        return Row(
          children: [
            const Icon(Icons.group_work),
            const SizedBox(width: 16),
            Expanded(
              child: Text(item.name,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ],
        );
      case 'cart':
        return Row(
          children: [
            const Icon(Icons.shopping_cart),
            const SizedBox(width: 16),
            Expanded(
              child: Text('Cart',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ],
        );
      case 'orders':
        return Row(
          children: [
            const Icon(Icons.receipt_long),
            const SizedBox(width: 16),
            Expanded(
              child: Text('Order',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ],
        );
      case 'users':
        return Row(
          children: [
            const Icon(Icons.people),
            const SizedBox(width: 16),
            Expanded(
              child: Text('User',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ],
        );
      default:
        return Text(item.toString());
    }
  }

  Widget _buildFullItem(BuildContext context, String entity, dynamic item,
      bool isWide, AdminEntitiesState state) {
    final bloc = context.read<AdminEntitiesBloc>();
    switch (entity) {
      case 'category':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: isWide ? 180 : 120,
                  height: isWide ? 180 : 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.image, color: Colors.white38, size: 48),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: Theme.of(context).textTheme.headlineSmall),
                      Text('ID: ${item.id}',
                          style: Theme.of(context).textTheme.bodySmall),
                      if (item.sortOrder != null)
                        Text('Sort: ${item.sortOrder}',
                            style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => CategoryCrudDialog(
                        initialName: item.name,
                        initialSortOrder: item.sortOrder,
                        onSubmit: (name, sortOrder) {
                          bloc.add(UpdateCategory(
                              id: item.id, name: name, sortOrder: sortOrder));
                        },
                        isEdit: true,
                        onHardDelete: () {
                          bloc.add(DeleteCategory(id: item.id, hard: true));
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Редактировать'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    bloc.add(DeleteCategory(id: item.id, hard: false));
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Удалить'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                const SizedBox(width: 12),
                if (item.isDeleted == true)
                  ElevatedButton.icon(
                    onPressed: () {
                      bloc.add(RestoreCategory(id: item.id));
                    },
                    icon: const Icon(Icons.restore),
                    label: const Text('Восстановить'),
                  ),
              ],
            ),
            if (state is AdminEntitiesLoaded)
              ...state.products
                  .where((p) => p.category.id == item.id)
                  .map((product) => Padding(
                        padding: const EdgeInsets.only(left: 24.0, top: 16),
                        child: _buildFullItem(
                            context, 'product', product, isWide, state),
                      ))
                  .toList(),
          ],
        );
      case 'product':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.imageUrl != null)
                  Container(
                    width: isWide ? 180 : 120,
                    height: isWide ? 180 : 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        item.fullImageUrl,
                        width: isWide ? 180 : 120,
                        height: isWide ? 180 : 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, color: Colors.red, size: 48);
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ),
                if (item.imageUrl == null)
                  Container(
                    width: isWide ? 180 : 120,
                    height: isWide ? 180 : 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.image, color: Colors.white38, size: 48),
                  ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: Theme.of(context).textTheme.headlineSmall),
                      Text('ID: ${item.id}',
                          style: Theme.of(context).textTheme.bodySmall),
                      if (item.description != null)
                        Text('Desc: ${item.description}',
                            style: Theme.of(context).textTheme.bodySmall),
                      if (item.sortOrder != null)
                        Text('Sort: ${item.sortOrder}',
                            style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => ProductCrudDialog(
                        initialCategoryId: item.category.id, // MODIFIED HERE
                        initialName: item.name,
                        initialDescription: item.description,
                        initialSortOrder: item.sortOrder,
                        initialImageUrl: item.imageUrl,
                        // categories: state.categories, // Передаем текущие категории в диалог
                        onSubmit: (categoryId, name, description, sortOrder,
                            imageUrl) {
                          bloc.add(UpdateProduct(
                              id: item.id,
                              categoryId: categoryId,
                              name: name,
                              description: description,
                              sortOrder: sortOrder,
                              imageUrl: imageUrl));
                        },
                        isEdit: true,
                        onHardDelete: () {
                          bloc.add(DeleteProduct(id: item.id, hard: true));
                        },
                      ),
                    );
                  },
                  label: const Text('Продукты'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => ProductCrudDialog(
                        initialCategoryId: item.category.id, // MODIFIED HERE
                        initialName: item.name,
                        initialDescription: item.description,
                        initialSortOrder: item.sortOrder,
                        initialImageUrl: item.imageUrl,
                        onSubmit: (categoryId, name, description, sortOrder,
                            imageUrl) {
                          bloc.add(UpdateProduct(
                              id: item.id,
                              categoryId: categoryId,
                              name: name,
                              description: description,
                              sortOrder: sortOrder,
                              imageUrl: imageUrl));
                        },
                        isEdit: true,
                        onHardDelete: () {
                          bloc.add(DeleteProduct(id: item.id, hard: true));
                        },
                      ),
                    );
                  },
                  label: const Text('Продукты'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => VariantCrudDialog(
                        initialProductId: item.productId,
                        initialName: item.name,
                        initialPrice: item.price,
                        initialImageUrl: item.imageUrl,
                        onSubmit: (
                            {required int productId,
                            required String name,
                            required int price,
                            required String sku,
                            required bool isAvailable,
                            required bool isCombo,
                            String? description,
                            String? imageUrl,
                            int? value,
                            String? unit}) {
                          bloc.add(UpdateVariant(
                            id: item.id,
                            name: name,
                            price: price,
                            imageUrl: imageUrl,
                          ));
                        },
                        isEdit: true,
                      ),
                    );
                  },
                  label: const Text('Варианты продуктов'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => VariantCrudDialog(
                        initialProductId: item.productId,
                        initialName: item.name,
                        initialPrice: item.price,
                        initialImageUrl: item.imageUrl,
                        onSubmit: (
                            {required int productId,
                            required String name,
                            required int price,
                            required String sku,
                            required bool isAvailable,
                            required bool isCombo,
                            String? description,
                            String? imageUrl,
                            int? value,
                            String? unit}) {
                          bloc.add(UpdateVariant(
                            id: item.id,
                            name: name,
                            price: price,
                            imageUrl: imageUrl,
                          ));
                        },
                        isEdit: true,
                      ),
                    );
                  },
                label: const Text('Варианты продуктов'),
                ),
              ],
            ),

            // Ассоциации с группами модификаторов
            if (state is AdminEntitiesLoaded)
              ElevatedButton.icon(
                onPressed: () {
                  final allGroups = state.modifierGroups
                      .map((g) => g.name.toString())
                      .toList();
                  final selectedGroups = item.groupNames ?? [];
                  showDialog(
                    context: context,
                    builder: (ctx) => AssociationDialog(
                      allGroups: allGroups,
                      selectedGroups: selectedGroups,
                      onSubmit: (selected) {
                        // Привязка/отвязка групп (пример)
                        for (final groupName in allGroups) {
                          final group = state.modifierGroups
                              .firstWhere((g) => g.name == groupName);
                          if (selected.contains(groupName) &&
                              !(selectedGroups.contains(groupName))) {
                            bloc.add(LinkGroupToVariant(
                                variantId: item.id, groupId: group.id));
                          } else if (!selected.contains(groupName) &&
                              selectedGroups.contains(groupName)) {
                            bloc.add(UnlinkGroupFromVariant(
                                variantId: item.id, groupId: group.id));
                          }
                        }
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.link),
                label: const Text('Группы модификаторов'),
              ),
            ],
          );
        
      case 'variant':
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 24,
            children: [
              Row(
                children: [
                  if (item.imageUrl != null)
                    Image.network(item.fullImageUrl,
                        width: isWide ? 180 : 120,
                        height: isWide ? 180 : 120,
                        fit: BoxFit.cover),
                  if (item.imageUrl == null)
                    Container(
                        width: isWide ? 180 : 120,
                        height: isWide ? 180 : 120,
                        color: Colors.grey[700],
                        child: const Icon(Icons.image,
                            color: Colors.white38, size: 48)),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: Theme.of(context).textTheme.headlineSmall),
                      Text('ID: ${item.id}',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => VariantCrudDialog(
                          initialProductId: item.productId,
                          initialName: item.name,
                          initialPrice: item.price,
                          initialImageUrl: item.imageUrl,
                          onSubmit: (
                              {required int productId,
                              required String name,
                              required int price,
                              required String sku,
                              required bool isAvailable,
                              required bool isCombo,
                              String? description,
                              String? imageUrl,
                              int? value,
                              String? unit}) {
                            bloc.add(UpdateVariant(
                              id: item.id,
                              name: name,
                              price: price,
                              imageUrl: imageUrl,
                            ));
                          },
                          isEdit: true,
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text(
                        'Редактировать'), // <-- добавлен параметр label
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      bloc.add(DeleteVariant(id: item.id, hard: false));
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Удалить'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                  const SizedBox(width: 12),
                  if (item.isDeleted == true)
                    ElevatedButton.icon(
                      onPressed: () {
                        bloc.add(RestoreVariant(id: item.id));
                      },
                      icon: const Icon(Icons.restore),
                      label: const Text('Восстановить'),
                    ),
                ],
              ),

              // Ассоциации с группами модификаторов
              if (state is AdminEntitiesLoaded)
                ElevatedButton.icon(
                  onPressed: () {
                    final allGroups = state.modifierGroups
                        .map((g) => g.name.toString())
                        .toList();
                    final selectedGroups = item.groupNames ?? [];
                    showDialog(
                      context: context,
                      builder: (ctx) => AssociationDialog(
                        allGroups: allGroups,
                        selectedGroups: selectedGroups,
                        onSubmit: (selected) {
                          // Привязка/отвязка групп (пример)
                          for (final groupName in allGroups) {
                            final group = state.modifierGroups
                                .firstWhere((g) => g.name == groupName);
                            if (selected.contains(groupName) &&
                                !(selectedGroups.contains(groupName))) {
                              bloc.add(LinkGroupToVariant(
                                  variantId: item.id, groupId: group.id));
                            } else if (!selected.contains(groupName) &&
                                selectedGroups.contains(groupName)) {
                              bloc.add(UnlinkGroupFromVariant(
                                  variantId: item.id, groupId: group.id));
                            }
                          }
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.link),
                  label: const Text('Группы модификаторов'),
                ),
            ],
          ),
        );
      case 'modifier':
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 24,
            children: [
              Row(
                children: [
                  const Icon(Icons.tune, size: 48),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: Theme.of(context).textTheme.headlineSmall),
                      Text('ID: ${item.id}',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => ModifierCrudDialog(
                          groups: state is AdminEntitiesLoaded
                              ? state.modifierGroups
                                  .map((g) => {'id': g.id, 'name': g.name})
                                  .toList()
                              : <Map<String, dynamic>>[],
                          initialGroupId: item.groupId,
                          onSubmit: (name, priceDelta, groupId) {
                            bloc.add(UpdateModifier(
                                id: item.id,
                                name: name,
                                price: priceDelta,
                                groupId: groupId));
                          },
                          isEdit: true,
                          onHardDelete: () {
                            bloc.add(DeleteModifier(id: item.id, hard: true));
                          },
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Редактировать'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      bloc.add(DeleteModifier(id: item.id, hard: true));
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Удалить'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                  const SizedBox(width: 12),
                  // if (item.isDeleted == true)
                  //   ElevatedButton.icon(
                  //     onPressed: () {
                  //       bloc.add(RestoreModifier(id: item.id));
                  //     },
                  //     icon: const Icon(Icons.restore),
                  //     label: const Text('Восстановить'),
                  //   ),
                ],
              ),
            ],
          ),
        );
      case 'modifierGroup':
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 24,
            children: [
              Row(
                children: [
                  const Icon(Icons.group_work, size: 48),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name,
                          style: Theme.of(context).textTheme.headlineSmall),
                      Text('ID: ${item.id}',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => ModifierGroupCrudDialog(
                          initialName: item.name,
                          onSubmit: (name, isRequired, isMultiselect) {
                            bloc.add(UpdateModifierGroup(
                                id: item.id, name: name, description: ''),
                              );
                          },
                          isEdit: true,
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Редактировать'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      bloc.add(DeleteModifierGroup(id: item.id, hard: false));
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Удалить'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                  const SizedBox(width: 12),
                  if (item.isDeleted == true)
                    ElevatedButton.icon(
                      onPressed: () {
                        bloc.add(RestoreModifierGroup(id: item.id));
                      },
                      icon: const Icon(Icons.restore),
                      label: const Text('Восстановить'),
                    ),
                ],
              ),
            ],
          ),
        );
      default:
        return Text(item.toString());
    }
  }
}
