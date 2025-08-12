import 'package:dartz/dartz.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repositories.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> login({
    required String email,
    required String password,
  }) async {
    print('Checking network connection...');
    final isConnected = await networkInfo.isConnected;
    print('Network connected: $isConnected');
    
    if (isConnected) {
      try {
        print('Making login request...');
        final response = await remoteDataSource.login(
          email: email,
          password: password,
        );

        print('Login successful, caching token...');
        await localDataSource.cacheToken(response.accessToken);
        return Right(response.accessToken);
      } on ServerException {
        print('Login failed with ServerException');
        return Left(ServerFailure());
      }
    } else {
      print('Network not connected, returning NetworkFailure');
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.register(
          name: name,
          email: email,
          password: password,
        );
        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearToken();
      return const Right(null);
    } catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getLoggedInUser() async {
    print('Checking network connection for getLoggedInUser...');
    final isConnected = await networkInfo.isConnected;
    print('Network connected: $isConnected');
    
    if (isConnected) {
      try {
        print('Getting cached token...');
        final token = await localDataSource.getCachedToken();
        print('Token retrieved, getting user info...');
        final user = await remoteDataSource.getLoggedInUser(token: token);
        print('User info retrieved successfully');
        return Right(user);
      } on CacheException {
        print('GetLoggedInUser failed with CacheException');
        return Left(CacheFailure());
      } on ServerException {
        print('GetLoggedInUser failed with ServerException');
        return Left(ServerFailure());
      }
    } else {
      print('Network not connected, returning NetworkFailure');
      return Left(NetworkFailure());
    }
  }
}
