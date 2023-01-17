import 'package:first_application/data/network/app_api.dart';
import 'package:first_application/data/network/request.dart';
import 'package:first_application/data/responses/responses.dart';

abstract class RemoteDataSource {
  Future<AuthenticationResponse> login(LoginRequest loginRequest);
  Future<AuthenticationResponse> register(RegisterRequest registerRequest);
}



class RemoteDataSourceImplementer implements RemoteDataSource {
  AppServiceClient _appServiceClient;

  RemoteDataSourceImplementer(this._appServiceClient);

  @override
  Future<AuthenticationResponse> login(LoginRequest loginRequest) async {
    return await _appServiceClient.login(
        loginRequest.sign, loginRequest.password,loginRequest.deviceId,loginRequest.userDeviceTypeId);
  }

  @override
  Future<AuthenticationResponse> register(RegisterRequest registerRequest)async{
    return await _appServiceClient.register(
      registerRequest.sign,registerRequest.password,registerRequest.languageId);

  }
}