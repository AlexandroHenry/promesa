import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../models/user_model.dart';
import '../../models/user_list_response_model.dart';

part 'user_api.g.dart';

@RestApi(baseUrl: '') // baseUrl은 DioClient에서 설정됨
abstract class UserApi {
  factory UserApi(Dio dio, {String baseUrl}) = _UserApi;

  @GET('/users')
  Future<UserListResponseModel> getUsers(
    @Query('page') int page,
    @Query('limit') int limit,
    @Query('search') String? search,
  );

  @GET('/users/{id}')
  Future<UserModel> getUser(@Path('id') int id);

  @POST('/users')
  Future<UserModel> createUser(@Body() Map<String, dynamic> userData);

  @PUT('/users/{id}')
  Future<UserModel> updateUser(
    @Path('id') int id,
    @Body() Map<String, dynamic> userData,
  );

  @DELETE('/users/{id}')
  Future<void> deleteUser(@Path('id') int id);
}
