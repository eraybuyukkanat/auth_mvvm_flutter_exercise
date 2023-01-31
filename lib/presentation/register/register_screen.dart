import 'dart:async';

import 'package:first_application/app/di.dart';
import 'package:first_application/domain/model/home/main_page.dart';
import 'package:first_application/presentation/login/login_screen.dart';
import 'package:first_application/presentation/login/old_screens/login_view.dart';
import 'package:first_application/presentation/login/login_viewmodel.dart';
import 'package:first_application/presentation/register/register_viewmodel.dart';
import 'package:first_application/presentation/resources/color_manager.dart';
import 'package:first_application/presentation/resources/text_manager.dart';
import 'package:first_application/presentation/state_renderer/state_renderer_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegisterViewModel _viewModel = instance<RegisterViewModel>();
  TextEditingController _usernameTextEditingController =
      TextEditingController();
  TextEditingController _passwordTextEditingController =
      TextEditingController();
  TextEditingController _passwordTextEditingController2 =
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

    _passwordTextEditingController2.addListener(() {
      _viewModel.setPassword2(_passwordTextEditingController2.text);
    });


    _viewModel.isUserRegisterInSuccessfullyStreamController.stream
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
    _passwordTextEditingController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {




    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Colors.black,
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
            padding: EdgeInsets.only(left: 8.0,right: 8.0,top: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                //////////////////////////GÖRSEL VE YAZILARI
                Lottie.asset("assets/json_assets/welcome.json",
                    height: size.height * 0.22),
                Text(
                  "Welcome!",
                  style: TextStyleManager.blackBoldText.copyWith(fontSize: 45,color: ColorManager.secondary)
                ),
                Text(
                  "detail text",
                  style: TextStyleManager.blackNormalText.copyWith(fontSize: 15,color: ColorManager.secondary)
                ),
                SizedBox(
                  height: 20,
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
                        SizedBox(height: 2,),
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
                          height: 20,
                        ),
                        Text(
                          "Password",
                          style: TextStyleManager.blackBoldText.copyWith(fontSize: 15)
                        ),
                        SizedBox(height: 2,),
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
                            }),
                        //tekrar şifre
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Password Again",
                          style: TextStyleManager.blackBoldText.copyWith(fontSize: 15)
                        ),
                        SizedBox(height: 3,),
                        StreamBuilder<bool>(
                            initialData: true,
                            stream: _isPasswordVisibleController.stream,
                            builder: (context, isVisible) {
                              return StreamBuilder<String?>(
                                  stream: _viewModel.outputErrorPassword,
                                  builder: (context, snapshot) {
                                    return TextFormField(
                                      controller:
                                      _passwordTextEditingController2,
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
                  child: StreamBuilder<bool>(
                    stream: _viewModel.outputIsAllValid,
                    builder: (context, snapshot) {
                      return ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(backgroundColor: ColorManager.primary),
                        onPressed: (snapshot.data ?? false) ? () {

                          _viewModel.register();
                        } : null,
                        child: Text(
                          "Register!",
                          style: TextStyleManager.whiteText.copyWith(fontSize: 15,color: ColorManager.white)
                        ),
                      );
                    }
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                Row(
                  children: [
                    SizedBox(
                        width: size.width * 0.25,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(

                                backgroundColor: ColorManager.secondary),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            child: Text("Login!",
                                style: TextStyleManager.blackBoldText.copyWith(fontSize: 15,color: ColorManager.white)))),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "You are already registered?",
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: ColorManager.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
