import 'package:auto_route/auto_route.dart';
import '../../features/users/client/restaraunt/menu/view/menu_screen.dart';
import '../../features/users/client/restaraunt/products/product/view/product_screen.dart';
import '/features/auth/login/view/login_screen.dart';
import '/features/users/client/cart/view/cart_screen.dart';
import 'package:flutter/material.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: MenuRoute.page, path: '/menu', initial: true),
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: ProductRoute.page, path: '/product/:productId'),
    // AutoRoute(page: CartRoute.page, path: '/cart'),
    AutoRoute(
      path: '/cart',
      page: CartRoute.page,
      children: [
        AutoRoute(path: 'part/1', page: CartItemsRoute.page),
        AutoRoute(path: 'part/2', page: CartAddressRoute.page),
        AutoRoute(path: 'part/3', page: CartPaymentRoute.page),
      ],
    ),
  ];
}
