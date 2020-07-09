import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lily_books/api/api_status.dart';
import 'package:lily_books/api/requests/sign_in.request.dart';
import 'package:lily_books/api/requests/sign_up.request.dart';
import 'package:lily_books/api/responses/lily.response.dart';
import 'package:lily_books/api/responses/user.response.dart';
import 'package:lily_books/constants.dart';
import 'package:lily_books/repositories/base.repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo extends BaseRepo {
  Stream<Resource<bool>> signIn(SignInRequest request) async* {
    yield Resource.loading();
    try {
      var response = await dio.post('users/login', data: request.toJson());
      UserResponse user = UserResponse.fromJson(response.data);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(PREFS_KEY_TOKEN, user.token);
      prefs.setString(PREFS_KEY_USER_ID, user.userId);
      yield Resource.success(true);
    } catch (e) {
      if (e is DioError) {
        var error = LilyResponse.fromJson(e.response.data);
        yield Resource.failed(error.message);
      } else {
        yield Resource.failed(e);
      }
    }
  }

  Stream<Resource<bool>> signUp(SignUpRequest request) async* {
    yield Resource.loading();
    try {
      await dio.post('users/register', data: request.toJson());
      yield Resource.success(true);
    } catch (e) {
      if (e is DioError) {
        var error = LilyResponse.fromJson(e.response.data);
        yield Resource.failed(error.message);
      } else {
        yield Resource.failed(e);
      }
    }
  }

  Stream<Resource<String>> forgot(String email) async* {
    yield Resource.loading();
    try {
      var response = await dio.post('users/forgot', data: {"email": email});
      String code = jsonDecode(response.data)['code'];
      yield Resource.success(code);
    } catch (e) {
      if (e is DioError) {
        var error = LilyResponse.fromJson(e.response.data);
        yield Resource.failed(error.message);
      } else {
        yield Resource.failed(e);
      }
    }
  }

  Stream<Resource<bool>> logout() async* {
    yield Resource.loading();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove(PREFS_KEY_TOKEN);
      prefs.remove(PREFS_KEY_USER_ID);
      yield Resource.success(true);
    } catch (e) {
      yield Resource.failed(e);
    }
  }
}