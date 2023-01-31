import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

import 'package:first_application/app/di.dart';
import 'package:first_application/domain/model/home/main_page.dart';
import 'package:first_application/presentation/login/login_viewmodel.dart';
import 'package:first_application/presentation/register/old_screens/register_view.dart';
import 'package:first_application/presentation/state_renderer/state_renderer_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';

import '../register/register_screen.dart';
import '../resources/color_manager.dart';
import '../resources/text_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginViewModel _viewModel = instance<LoginViewModel>();
  TextEditingController _usernameTextEditingController =
      TextEditingController();
  TextEditingController _passwordTextEditingController =
      TextEditingController();

  StreamController<bool> _isPasswordVisibleController =
      StreamController<bool>.broadcast();

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

  @override
  Widget _getContentWidget() {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: ColorManager.white,
            padding: EdgeInsets.only(left: 8.0,right: 8.0,top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Lottie.asset("assets/json_assets/welcome.json",
                    height: size.height * 0.22),
                Text(
                  "Welcome Again!",
                  style: TextStyleManager.blackBoldText.copyWith(fontSize: 45,color:ColorManager.secondary)
                ),
                Text(
                  "detail text",
                  style: TextStyleManager.blackNormalText.copyWith(fontSize: 15,color: ColorManager.secondary)
                ),
                SizedBox(
                  height: 50,
                ),

                Form(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Username",
                          style: TextStyleManager.blackBoldText.copyWith(fontSize: 15)
                        ),
                        StreamBuilder<String?>(
                            stream: _viewModel.outputErrorUsername,
                            builder: (context, snapshot) {
                              return TextFormField(
                                controller: _usernameTextEditingController,
                                decoration: InputDecoration(
                                  suffixIcon:
                                      Icon(Icons.person_outline_outlined),
                                  errorText: snapshot.data,
                                ),
                              );
                            }),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Password",
                          style: TextStyleManager.blackBoldText.copyWith(fontSize: 15)
                        ),
                        StreamBuilder<bool>(
                            initialData: true,
                            stream: _isPasswordVisibleController.stream,
                            builder: (context, isVisible) {
                              return StreamBuilder<String?>(
                                  stream: _viewModel.outputErrorPassword,
                                  builder: (context, snapshot) {
                                    return TextFormField(
                                      controller:
                                          _passwordTextEditingController,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      obscureText: isVisible.data!,
                                      decoration: InputDecoration(
                                        errorText: snapshot.data,
                                        suffixIcon: IconButton(
                                          icon: isVisible.data!
                                              ? Icon(Icons.visibility)
                                              : Icon(Icons.visibility_off),
                                          onPressed: () {
                                            _isPasswordVisibleController.sink
                                                .add(!isVisible.data!);
                                          },
                                        ),
                                      ),
                                    );
                                  });
                            })
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: ColorManager.primary),
                    onPressed: () {
                      _viewModel.login();
                    },
                    child: Text(
                      "Login!",
                      style: TextStyleManager.whiteText.copyWith(fontSize: 15,color: ColorManager.white)
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      "If you haven't registered yet",
                      style: TextStyleManager.blackBoldText.copyWith(fontSize: 18,color: ColorManager.secondary),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                        width: size.width * 0.35,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.secondary),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => RegisterScreen()));
                            },
                            child: Text("Register!",
                                style: TextStyleManager.blackBoldText.copyWith(fontSize: 15,color: ColorManager.white)))),
                  ],
                ),
                SizedBox(height: 113,)
              ],

            ),
          ),
        ),
      ),
    );
  }
}
