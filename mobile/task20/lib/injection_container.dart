import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

// Core imports
import 'package:contracts_of_data_sources/core/network/network_info.dart';
import 'package:contracts_of_data_sources/core/network/network_info_impl.dart';
import 'package:contracts_of_data_sources/core/services/api_service.dart';

// Feature-specific imports (Product feature)
import 'package:contracts_of_data_sources/features/product/data/datasources/product_local_data_source.dart';
import 'package:contracts_of_data_sources/features/product/data/datasources/product_local_data_source_impl.dart';
import 'package:contracts_of_data_sources/features/product/data/datasources/product_remote_data_source.dart';
import 'package:contracts_of_data_sources/features/product/data/datasources/product_remote_data_source_impl.dart';
import 'package:contracts_of_data_sources/features/product/data/repositories/product_repository_impl.dart';
import 'package:contracts_of_data_sources/features/product/domain/repositories/product_repository.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/create_product_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/delete_product_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/get_single_product_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/update_product_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/view_all_products_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_bloc.dart';


final GetIt sl = GetIt.instance; // sl stands for Service Locator

Future<void> init() async {
  // ------------------------- Features -------------------------

  // Product BLoC
  sl.registerFactory(() => ProductBloc(
        viewAllProductsUsecase: sl(),
        getSingleProductUsecase: sl(),
        createProductUsecase: sl(),
        updateProductUsecase: sl(),
        deleteProductUsecase: sl(),
      ));

  // Use Cases
  sl.registerFactory(() => ViewAllProductsUsecase(sl()));
  sl.registerFactory(() => GetSingleProductUsecase(sl()));
  sl.registerFactory(() => CreateProductUsecase(sl()));
  sl.registerFactory(() => UpdateProductUsecase(sl()));
  sl.registerFactory(() => DeleteProductUsecase(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(apiService: sl()),
  );
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(
      sharedPreferences: sl(),
      uuid: sl(),
    ),
  );

  // ------------------------- Core -------------------------

  // ApiService
  sl.registerLazySingleton(() => ApiService(client: sl()));

  // NetworkInfo
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );

  // ------------------------- External -------------------------

  // SharedPreferences (Asynchronous dependency, await its instance)
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Connectivity
  sl.registerLazySingleton<Connectivity>(
    () => Connectivity(),
  );

  // Http Client
  sl.registerLazySingleton(() => http.Client());

  // Uuid
  sl.registerLazySingleton(() => const Uuid());
}