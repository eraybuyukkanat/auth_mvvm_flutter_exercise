import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:first_application/app/app_prefs.dart';
import 'package:first_application/data/responses/responses.dart';
import 'package:first_application/domain/usecases/login_usecase.dart';
import 'package:first_application/presentation/base/base_viewmodel.dart';
import 'package:first_application/presentation/freezed/freezed_data_classes.dart';
import 'package:first_application/presentation/state_renderer/state_renderer.dart';
import 'package:first_application/presentation/state_renderer/state_renderer_impl.dart';
import 'package:first_application/data/responses/responses.dart';

import '../../app/di.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInput, LoginViewModelOutput {
  StreamController _usernameStreamController =
      StreamController<String>.broadcast();
  StreamController _passwordStreamController =
      StreamController<String>.broadcast();
  StreamController _isAllInputsValidStreamController =
      StreamController<void>.broadcast();
  StreamController isUserLoginInSuccessfullyStreamController =
      StreamController<bool>();



  var loginViewObject = LoginObject("", "","blabla");

  LoginUseCase _loginUseCase;

  AppPreferences _appPreferences = instance<AppPreferences>();

  LoginViewModel(this._loginUseCase);

////////////////////////////////////////////////////////////////////
  @override
  void dispose() {
    _usernameStreamController.close();
    _passwordStreamController.close();
    _isAllInputsValidStreamController.close();
    isUserLoginInSuccessfullyStreamController.close();

  }

  @override
  void start() {
    inputState.add(ContentState());
  }

//functions

  bool _validateAllInputs() {
    return loginViewObject.username.isNotEmpty &&
        loginViewObject.password.isNotEmpty;
  }

  _isPasswordValid(String password) {
    return password.length > 3;
  }

  _isUsernameValid(String username) {
    return username.length > 3;
  }

  @override
  login() async {
    //login butonuna basıldığında ekrana loading popupını getiriyoruz.
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));

        //_loginUseCase.girişyap ya da kayıtol fonksiyonları gibi düşünülebilir.
    (await _loginUseCase.execute(LoginUseCaseInput(
            loginViewObject.username, loginViewObject.password,loginViewObject.deviceId,1)))
        //fold yapısında iki yol var gibi düşünebilirsiniz hatalı olursa left başarılı olursa right
        .fold(
            (failure) => {
                  inputState.add(ErrorState(StateRendererType.POPUP_ERROR_STATE,
                      "Giriş Yaparken Hata Oluştu"))
                }, (data) {

      inputState.add(ContentState());
      isUserLoginInSuccessfullyStreamController.add(true);
      _appPreferences.setToken(data.userData!.token);
      print(data.userData?.id);
      print(data.userData?.sign);
      print(data.userData!.token);
      _appPreferences.KullaniciGirisiniYapti();

      //print(_appPreferences.getToken());

      //bir tane streamcontroller atcaz içine string olcak çünkü içine token saklayacak diğerleri gibi input outputu olcak
      //add diyip tokenı içine vercez
      //app preferenceste tokenı saklamak için fonk oluşturcaz set ve get için burda set
    });
  }


//YAPILACAKLAR
  //


  @override
  setPassword(String password) {
    inputPassword.add(password);
    if (_isPasswordValid(password)) {
      loginViewObject = loginViewObject.copyWith(password: password);
    } else {
      loginViewObject = loginViewObject.copyWith(password: "");
    }
    _validate();
  }

  @override
  setUsername(String username) {
    inputUsername.add(username);
    if (_isUsernameValid(username)) {
      loginViewObject = loginViewObject.copyWith(username: username);
    } else {
      loginViewObject = loginViewObject.copyWith(username: "");
    }
    _validate();
  }

  _validate() {
    inputAllInputsValid.add(null);
  }

//inputs

  @override
  Sink get inputAllInputsValid => _isAllInputsValidStreamController.sink;

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputUsername => _usernameStreamController.sink;



//outputs

  @override
  Stream<String?> get outputErrorPassword =>
      outputIsPasswordValid.map((isPasswordValid) =>
          isPasswordValid ? null : "Şifreniz 7 Haneden Büyük Olmalı !!!");

  @override
  Stream<String?> get outputErrorUsername =>
      outputIsUsernameValid.map((isUsernameValid) => isUsernameValid
          ? null
          : "Kullanıcı Adınız 5 Haneden Büyük Olmalı !!!");

  @override
  Stream<bool> get outputIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outputIsUsernameValid => _usernameStreamController.stream
      .map((username) => _isUsernameValid(username));

  @override
  Stream<bool> get outputIsAllValid =>
      _isAllInputsValidStreamController.stream.map((_) => _validateAllInputs());
}

abstract class LoginViewModelInput {
  login();

  //freezed
  setUsername(String username);
  setPassword(String password);

  Sink get inputUsername;
  Sink get inputPassword;
  Sink get inputAllInputsValid;
}



abstract class LoginViewModelOutput {
  Stream<bool> get outputIsUsernameValid;
  Stream<String?> get outputErrorUsername;
  Stream<bool> get outputIsPasswordValid;
  Stream<String?> get outputErrorPassword;

  Stream<bool> get outputIsAllValid;
}
