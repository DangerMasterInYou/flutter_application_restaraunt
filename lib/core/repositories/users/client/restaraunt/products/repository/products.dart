import 'package:dio/dio.dart';

import '../products.dart';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '/core/hive/models/models.dart';

class ProductsRepository implements AbstractProductsRepository {
  ProductsRepository({
    required this.dio,
    required this.productsBox,
    required this.apiSiteUrl,
  });

  final Dio dio;
  final Box<Product> productsBox;
  final String apiSiteUrl;

  @override
  Future<List<Product>> getProductsList() async {
    var productsList = <Product>[];
    try {
      productsList = await _fetchProductsListFromApi();
      final productsMap = {for (var e in productsList) e.id: e};
      await productsBox.putAll(productsMap);
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      productsList = productsBox.values.toList();
    }
    return productsList;
  }

  Future<List<Product>> _fetchProductsListFromApi() async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/products',
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Ошибка при загрузке данных: ${response.statusCode}',
        );
      }
      final data = response.data;
      if (data is! List) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Неожиданный формат ответа',
        );
      }
      final productsList = data.map((item) {
        if (item is! Map<String, dynamic>) {
          throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: 'Неверный формат данных продукта',
          );
        }
        try {
          final product = Product.fromJson(item);
          return product;
        } catch (e) {
          rethrow;
        }
      }).toList();
      return List<Product>.from(productsList);
    } on DioException catch (e) {
      GetIt.instance<Talker>().handle(e, e.stackTrace);
      rethrow;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      throw Exception('Ошибка при получении списка продукт: $e');
    }
  }

  @override
  Future<Product> getProduct(String productName) async {
    try {
      final product = await _fetchProductFromApi(productName);
      await productsBox.put(product.id, product);
      return product;
    } catch (e, st) {
      GetIt.instance<Talker>().handle(e, st);
      for (var key in productsBox.keys) {
        final product = productsBox.get(key);
        if (product != null && product.name == productName) {
          return product;
        }
      }
      throw Exception('Ошибка при получении продукта: $e');
    }
  }

  Future<Product> _fetchProductFromApi(String productName) async {
    try {
      final response = await dio.get(
        '$apiSiteUrl/api/v1/menu/products/$productName',
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Ошибка при загрузке данных: ${response.statusCode}',
        );
      }
      final productData = response.data;
      if (productData is! Map<String, dynamic>) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Неожиданный формат ответа для продукта $productName',
        );
      }
      final product = Product.fromJson(productData);
      return product;
    } catch (e) {
      throw Exception('Ошибка при получении продукта: $e');
    }
  }

  Future<ProductFull?> getFullProduct(int productId) async {
    final product = productsBox.get(productId);
    if (product == null) return null;
    final categoryBox = Hive.box<Category>('categories_box');
    final variantBox = Hive.box<ProductVariantHive>('product_variants_box');
    final modifierGroupBox = Hive.box<ModifierGroupHive>('modifier_groups_box');
    final modifierBox = Hive.box<ModifierHive>('modifiers_box');
    final comboBundleBox = Hive.box<ComboBundleHive>('combo_bundles_box');

    final category = categoryBox.get(product.categoryId);
    final variants = product.variantIds
        .map((id) => variantBox.get(id))
        .whereType<ProductVariantHive>()
        .toList();

    // Для каждого варианта достаем группы модификаторов
    final Map<int, List<ModifierGroupHive>> variantModifierGroups = {};
    final Map<int, List<ModifierHive>> modifierGroupsModifiers = {};
    for (final variant in variants) {
      // Предполагается, что variant.modifierGroupIds - список id групп
      final groups = variant.modifierGroupIds
          .map((id) => modifierGroupBox.get(id))
          .whereType<ModifierGroupHive>()
          .toList();
      variantModifierGroups[variant.id] = groups;
      // Для каждой группы достаем модификаторы
      for (final group in groups) {
        final modifiers = group.modifierIds
            .map((id) => modifierBox.get(id))
            .whereType<ModifierHive>()
            .toList();
        modifierGroupsModifiers[group.id] = modifiers;
      }
    }

    // ComboBundles, связанные с вариантами этого продукта
    final comboBundles = comboBundleBox.values
        .whereType<ComboBundleHive>()
        .where((cb) => product.variantIds.contains(cb.comboVariantId))
        .toList();

    return ProductFull(
      product: product,
      category: category,
      variants: variants,
      variantModifierGroups: variantModifierGroups,
      modifierGroupsModifiers: modifierGroupsModifiers,
      comboBundles: comboBundles,
    );
  }
}
