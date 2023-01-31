import 'dart:async';

import 'package:first_application/app/di.dart';
import 'package:first_application/domain/model/home/main_page.dart';
import 'package:first_application/presentation/login/login_viewmodel.dart';
import 'package:first_application/presentation/register/old_screens/register_view.dart';
import 'package:first_application/presentation/state_renderer/state_renderer_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';

import '../../register/register_screen.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginViewModel _viewModel = instance<LoginViewModel>();
  TextEditingController _usernameTextEditingController =
      TextEditingController();
  TextEditingController _passwordTextEditingController =
      TextEditingController();

  StreamController<bool> _isPasswordVisibleController =
  StreamController<bool>.broadcast();




      

  //Burası kullanıcıyla buluştuğumuz ilk ekran burda sadece tasarım kodları var !
  //fonksiyonlarımızı kullanmak için viewmodeldan bir instance alıyoruz çünkü bütün fonksiyonlarımız viewmodelda

  _bind() {
    _usernameTextEditingController.addListener(() {
      _viewModel.setUsername(_usernameTextEditingController.text);
    });

    _passwordTextEditingController.addListener(() {
      _viewModel.setPassword(_passwordTextEditingController.text);
    });

    _viewModel.isUserLoginInSuccessfullyStreamController.stream
        .listen((girisYapabilirmi) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (girisYapabilirmi == true) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainPage()));
        }
      });
    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _passwordTextEditingController.dispose();
    _usernameTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder<FlowState>(
          stream: _viewModel.outputState,
          builder: (context, snapshot) {
            return snapshot.data
                    ?.getScreenWidget(context, _getContentWidget(), () {}) ??
                _getContentWidget();
          },
        ),
      )),
    );
  }

  Widget _getContentWidget() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Form(
          child: IntrinsicHeight(
            child: Column(
              children: [
                Spacer(),
                Lottie.asset("assets/json_assets/hosgeldin.json", height: 250),

                Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: StreamBuilder<String?>(
                          stream: _viewModel.outputErrorUsername,
                          builder: (context, snapshot) {
                            return TextFormField(
                              controller: _usernameTextEditingController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  labelText: "Kullanıcı Adı",
                                  hintText: "Kullanıcı Adı",
                                  errorText: snapshot.data),
                            );
                          }),
                    )),
                Expanded(
                    flex: 3,
                    child: StreamBuilder<bool>(
                        initialData: true,
                        stream: _isPasswordVisibleController.stream,
                        builder: (context, isVisible) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          child: StreamBuilder<String?>(
                              stream: _viewModel.outputErrorPassword,
                              builder: (context, snapshot) {
                                return TextFormField(
                                  controller: _passwordTextEditingController,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: isVisible.data!,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16)),
                                      suffixIcon: IconButton(
                                        icon: isVisible.data! ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                                        onPressed: () { _isPasswordVisibleController.sink
                                            .add(!isVisible.data!);},
                                      ),
                                      hintText: "Şifre",
                                      labelText: "Şifre",
                                      errorText: snapshot.data),
                                );
                              }),
                        );
                      }
                    )),
                Expanded(
                    flex: 2,
                    child: ElevatedButton(
                        onPressed: () {
                          _viewModel.login();
                        },
                        child: Text("Giriş Yap"))),
                Expanded(
                  flex: 2,
                  child: TextButton(
                      onPressed: () {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RegisterScreen()));},
                      child: Text("Üye Olmak İçin Tıklayınız")),
                ),
                Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
