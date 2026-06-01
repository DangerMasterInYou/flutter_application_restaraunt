import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '/features/users/client/restaraunt/menu/view/menu_screen.dart';
import '../../features/users/admin/view/admin_panel_screen.dart';
import '/features/users/client/restaraunt/product/view/product_screen.dart';
import '/features/users/client/profile/view/profile_screen.dart';
import '/features/auth/login/view/login_screen.dart';
import '/features/users/client/cart/view/view.dart';
import '/features/users/client/restaraunt/orders/view/view.dart';

part 'router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Screen,Route',
)
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: MenuRoute.page, path: '/menu'),
        AutoRoute(page: LoginRoute.page, path: '/login', initial: true),
        AutoRoute(page: ProductRoute.page, path: '/menu/products/:id'),
        AutoRoute(page: AdminPanelRoute.page, path: '/admin'),
        AutoRoute(page: ProfileRoute.page, path: '/profile'),
        AutoRoute(page: OrdersRoute.page, path: '/orders'),
        AutoRoute(page: OrderDetailRoute.page, path: '/orders/:id'),
        AutoRoute(
          path: '/cart',
          page: CartRoute.page,
          children: [
            AutoRoute(path: 'part/1', page: CartItemsRoute.page),
            AutoRoute(path: 'part/2', page: CartCommentRoute.page),
            AutoRoute(path: 'part/3', page: CartPaymentRoute.page),
          ],
        ),
        RedirectRoute(path: '*', redirectTo: '/login'),
      ];
}
