import 'dart:developer';

import 'package:bond/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:bond/features/auth/data/dto/user_dto.dart';
import 'package:bond/features/auth/data/models/user.dart';
import 'package:bond/features/auth/data/models/user_meta.dart';
import 'package:dartz/dartz.dart';
import 'package:one_studio_core/core.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthStore<User> _localDataSource;

  AuthRepository(this._remoteDataSource, this._localDataSource);

  Future<Either<Failure, SingleMResponse<User, UserMeta>>> anonymous() async {
    try {
      final response = await _remoteDataSource.anonymous();
      _localDataSource.user = response.data;
      _localDataSource.token = response.meta.token;
      return Right(response);
    } on ServerException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(ConnectionFailure());
    }
  }

  Future<Either<Failure, SingleMResponse<User, UserMeta>>> register(
    UserDto user,
  ) async {
    try {
      final response = await _remoteDataSource.register(user);
      _localDataSource.user = response.data;
      _localDataSource.token = response.meta.token;
      return Right(response);
    } on ServerException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(ConnectionFailure());
    }
  }

  Future<Either<Failure, SingleMResponse<User, UserMeta>>> login(
      UserDto user) async {
    try {
      final response = await _remoteDataSource.login(user);
      _localDataSource.user = response.data;
      _localDataSource.token = response.meta.token;
      return Right(response);
    } on ServerException catch (e) {
      log('server exception: ${e.toFailure().toMessage()}');
      return Left(e.toFailure());
    } catch (e) {
      return Left(ConnectionFailure());
    }
  }

  Future<Either<Failure, SuccessResponse>> logout() async {
    try {
      final response = await _remoteDataSource.logout();
      _localDataSource.user = null;
      _localDataSource.token = null;
      return Right(response);
    } on ServerException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(ConnectionFailure());
    }
  }
}
