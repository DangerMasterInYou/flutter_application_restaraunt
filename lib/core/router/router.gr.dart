// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    CartAddressRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CartAddressScreen(),
      );
    },
    CartItemsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CartItemsScreen(),
      );
    },
    CartPaymentRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CartPaymentScreen(),
      );
    },
    CartRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CartScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginScreen(),
      );
    },
    MenuRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MenuScreen(),
      );
    },
    ProductRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProductRouteArgs>(
          orElse: () =>
              ProductRouteArgs(productId: pathParams.getInt('productId')));
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProductScreen(
          key: args.key,
          productId: args.productId,
        ),
      );
    },
  };
}

/// generated route for
/// [CartAddressScreen]
class CartAddressRoute extends PageRouteInfo<void> {
  const CartAddressRoute({List<PageRouteInfo>? children})
      : super(
          CartAddressRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartAddressRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CartItemsScreen]
class CartItemsRoute extends PageRouteInfo<void> {
  const CartItemsRoute({List<PageRouteInfo>? children})
      : super(
          CartItemsRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartItemsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CartPaymentScreen]
class CartPaymentRoute extends PageRouteInfo<void> {
  const CartPaymentRoute({List<PageRouteInfo>? children})
      : super(
          CartPaymentRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartPaymentRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [CartScreen]
class CartRoute extends PageRouteInfo<void> {
  const CartRoute({List<PageRouteInfo>? children})
      : super(
          CartRoute.name,
          initialChildren: children,
        );

  static const String name = 'CartRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MenuScreen]
class MenuRoute extends PageRouteInfo<void> {
  const MenuRoute({List<PageRouteInfo>? children})
      : super(
          MenuRoute.name,
          initialChildren: children,
        );

  static const String name = 'MenuRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProductScreen]
class ProductRoute extends PageRouteInfo<ProductRouteArgs> {
  ProductRoute({
    Key? key,
    required int productId,
    List<PageRouteInfo>? children,
  }) : super(
          ProductRoute.name,
          args: ProductRouteArgs(
            key: key,
            productId: productId,
          ),
          rawPathParams: {'productId': productId},
          initialChildren: children,
        );

  static const String name = 'ProductRoute';

  static const PageInfo<ProductRouteArgs> page =
      PageInfo<ProductRouteArgs>(name);
}

class ProductRouteArgs {
  const ProductRouteArgs({
    this.key,
    required this.productId,
  });

  final Key? key;

  final int productId;

  @override
  String toString() {
    return 'ProductRouteArgs{key: $key, productId: $productId}';
  }
}
