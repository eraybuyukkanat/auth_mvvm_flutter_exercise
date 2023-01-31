import 'package:first_application/app/app_prefs.dart';
import 'package:first_application/app/di.dart';
import 'package:first_application/domain/model/home/main_page.dart';
import 'package:first_application/presentation/login/old_screens/login_view.dart';
import 'package:first_application/presentation/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_application/presentation/login/login_screen.dart';
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  AppPreferences _appPreferences = instance<AppPreferences>();

  _goNext() async {
    _appPreferences.isOnboardingScreenViewed().then((value)  {
          if (value)
            {
              _appPreferences.KullaniciGirisiniYaptiMi().then((value) {

                if(value){
                  Navigator.pushReplacement(

                    context, MaterialPageRoute(builder: (context) => MainPage()));
                }else{
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }

            });
            }
          else
            {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => OnBoardingView()));
            }
        });
  }

  @override
  void initState() {
    _goNext();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
