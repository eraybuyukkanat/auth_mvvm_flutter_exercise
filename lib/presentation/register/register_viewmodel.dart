import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:first_application/domain/usecases/login_usecase.dart';
import 'package:first_application/domain/usecases/register_usecase.dart';
import 'package:first_application/presentation/base/base_viewmodel.dart';
import 'package:first_application/presentation/freezed/freezed_data_classes.dart';
import 'package:first_application/presentation/state_renderer/state_renderer.dart';
import 'package:first_application/presentation/state_renderer/state_renderer_impl.dart';

import '../../domain/repository/repository.dart';

class RegisterViewModel extends BaseViewModel {

  StreamController _usernameStreamController = StreamController<
      String>.broadcast();
  StreamController _passwordStreamController = StreamController<
      String>.broadcast();
  StreamController _passwordStreamController2 = StreamController<
      String>.broadcast();
  StreamController _isAllInputsValidStreamController = StreamController<
      void>.broadcast();
  StreamController isUserRegisterInSuccessfullyStreamController = StreamController<
      bool>.broadcast();



  var registerViewObject = RegisterObject("", "","", 1);

  RegisterUseCase _registerUseCase;
  RegisterViewModel(this._registerUseCase);



  @override
  void dispose() {
    _usernameStreamController.close();
    _passwordStreamController.close();
    _passwordStreamController2.close();
    _isAllInputsValidStreamController.close();
    isUserRegisterInSuccessfullyStreamController.close();
  }


  @override
  void start() {
    inputState.add(ContentState());
  }

  bool _validateAllInputs() {
    if(registerViewObject.password == registerViewObject.password2 && registerViewObject.username.isNotEmpty &&
        registerViewObject.password.isNotEmpty){
      return true;
    }else{
      return false;
    }

  }

  _isPasswordValid(String password) {
    return password.length > 3;
  }

  _isUsernameValid(String username) {
    return username.length > 3;
  }

  @override
  register() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));
    (await _registerUseCase.execute(RegisterUseCaseInput(
        registerViewObject.username, registerViewObject.password,
        registerViewObject.languageId)))
    //fold yapısında iki yol var gibi düşünebilirsiniz hatalı olursa left başarılı olursa right
        .fold(
            (failure) =>
        {
          inputState.add(ErrorState(StateRendererType.POPUP_ERROR_STATE,
              "Kayıt Olurken Hata Oluştu"))
        }, (data) {
      inputState.add(ContentState());
      isUserRegisterInSuccessfullyStreamController.add(true);
    });
  }


  @override
  setPassword(String password) {
    inputPassword.add(password);
    if (_isPasswordValid(password)) {
      registerViewObject = registerViewObject.copyWith(password: password);
    } else {
      registerViewObject = registerViewObject.copyWith(password: "");
    }
    _validate();
  }

  @override
  setPassword2(String password2) {
    inputPassword.add(password2);
    if (_isPasswordValid(password2)) {
      registerViewObject = registerViewObject.copyWith(password2: password2);
    } else {
      registerViewObject = registerViewObject.copyWith(password2: "");
    }
    _validate();
  }


  @override
  setUsername(String username) {
    inputUsername.add(username);
    if (_isUsernameValid(username)) {
      registerViewObject = registerViewObject.copyWith(username: username);
    } else {
      registerViewObject = registerViewObject.copyWith(username: "");
    }
    _validate();
  }


  @override
  Sink get inputAllInputsValid => _isAllInputsValidStreamController.sink;

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputUsername => _usernameStreamController.sink;


  _validate() {
    inputAllInputsValid.add(null);
  }

  @override
  Stream<String?> get outputErrorPassword =>
      outputIsPasswordValid.map((isPasswordValid) =>
      isPasswordValid ? null : "Şifreniz 7 Haneden Büyük Olmalı !!!");

  @override
  Stream<String?> get outputErrorUsername =>
      outputIsUsernameValid.map((isUsernameValid) =>
      isUsernameValid
          ? null
          : "Kullanıcı Adınız 5 Haneden Büyük Olmalı !!!");

  @override
  Stream<bool> get outputIsPasswordValid =>
      _passwordStreamController.stream
          .map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outputIsUsernameValid =>
      _usernameStreamController.stream
          .map((username) => _isUsernameValid(username));

  @override
  Stream<bool> get outputIsAllValid =>
      _isAllInputsValidStreamController.stream.map((_) => _validateAllInputs());

}
abstract class RegisterViewModelInput {
  register();

  setUsername(String username);

  setPassword(String password);

  Sink get inputUsername;

  Sink get inputPassword;

  Sink get inputAllInputsValid;
}

abstract class RegisterViewModelOutput{
  Stream<bool> get outputIsUsernameValid;
  Stream<String?> get outputErrorUsername;
  Stream<bool> get outputIsPasswordValid;
  Stream<String?> get outputErrorPassword;

  Stream<bool> get outputIsAllValid;
}

