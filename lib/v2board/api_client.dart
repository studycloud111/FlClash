import 'package:dio/dio.dart';
import 'package:fl_clash/manager/auth_manager.dart';
import 'package:fl_clash/manager/config_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final apiUrl = ref.watch(apiUrlProvider);
  if (apiUrl == null) {
    throw Exception('API URL is not configured');
  }
  return ApiClient(apiUrl, ref);
});

class ApiClient {
  final Dio _dio;
  final String _apiUrl;
  final Ref _ref;

  ApiClient(this._apiUrl, this._ref) : _dio = Dio(BaseOptions(baseUrl: _apiUrl)) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _ref.read(authProvider).token;
          if (token != null) {
            options.headers['Authorization'] = token;
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<Response> login(String email, String password) async {
    return await _dio.post(
      '/passport/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<Response> getUserInfo() async {
    return await _dio.get('/user/info');
  }

  Future<Response> getSubscription() async {
    return await _dio.get('/user/getSubscribe');
  }

  Future<Response> getPlans() async {
    return await _dio.get('/user/plan/fetch');
  }

  Future<Response> createOrder(int planId) async {
    return await _dio.post(
      '/user/order/save',
      data: {'plan_id': planId},
    );
  }

  // I will add methods for login, getSubscription, etc. here later.
} 