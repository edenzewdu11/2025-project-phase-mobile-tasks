import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// sl<AuthBloc>()
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/auth/presentation/pages/home_screen.dart';
import '../../../features/auth/presentation/pages/sign_in_screen.dart';
import '../../../features/auth/presentation/pages/sign_up_screen.dart';
import '../../../features/auth/presentation/pages/splash_screen.dart';
import '../../../features/product/domain/entities/product.dart';
// sl<ProductBloc>()
import '../../../features/product/presentation/bloc/product_bloc.dart';
import '../../../features/product/presentation/pages/add_update_product_page.dart';
import '../../../features/product/presentation/pages/product_details_page.dart';
import '../../../features/product/presentation/pages/retrieve_all_products_page.dart';
import '../../features/auth/injection_container.dart' as auth_di;
import '../../features/product/injection_container.dart' as product_di;

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Splash screen
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => auth_di.sl<AuthBloc>()..add(GetUserEvent()),
            child: const EcomScreen(),
          ),
        );

      case '/login':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => auth_di.sl<AuthBloc>(),
            child: const SignInScreen(),
          ),
        );

      case '/signup':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => auth_di.sl<AuthBloc>(),
            child: const SignUpScreen(),
          ),
        );

      case '/home':
        // Expect userName and userEmail as arguments
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => auth_di.sl<AuthBloc>(),
            child: HomeScreen(
              userName: args['userName']!,
              userEmail: args['userEmail']!,
            ),
          ),
        );

      // -------- PRODUCT ROUTES --------

      case '/products':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                product_di.sl<ProductBloc>()..add(const LoadAllProductEvent()),
            child: const RetrieveAllProductsPage(),
          ),
        );

      case '/detail':
        final String productId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                product_di.sl<ProductBloc>()
                  ..add(GetSingleProductEvent(productId)),
            child: ProductDetailsPage(productId: productId),
          ),
        );

      case '/create':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => product_di.sl<ProductBloc>(),
            child: const AddUpdateProductPage(isEditing: false),
          ),
        );

      case '/update':
        final Product product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => product_di.sl<ProductBloc>(),
            child: AddUpdateProductPage(isEditing: true, product: product),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
