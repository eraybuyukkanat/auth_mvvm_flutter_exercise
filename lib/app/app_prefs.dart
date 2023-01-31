import 'package:shared_preferences/shared_preferences.dart';

const String PREFS_KEY_ONBOARDING_SCREEN = "PREFS_KEY_ONBOARDING_SCREEN";

class AppPreferences {
  SharedPreferences _sharedPreferences;
  String isAlreadyHaveToken="isAlreadyHaveToken";
  String bos = "";


  AppPreferences(this._sharedPreferences);

  Future<void> setOnboardingScreenViewed() async {
    _sharedPreferences.setBool(PREFS_KEY_ONBOARDING_SCREEN, true);
    
  }

  Future<bool> isOnboardingScreenViewed() async {
    return _sharedPreferences.getBool(PREFS_KEY_ONBOARDING_SCREEN) ?? false;
  }

  Future<void> setToken(String token)async{

    _sharedPreferences.setString("buraya_token_kaydediyorum", token);
  }
  Future<String> getToken()async{
    return _sharedPreferences.getString("buraya_token_kaydediyorum") ?? "token bulunamadi";
  }


  Future<void> KullaniciGirisiniYapti()async{

    _sharedPreferences.setBool("a", true);

  }

  Future<void> KullaniciGirisiniYapmadi()async{

    _sharedPreferences.remove("a");

  }

  Future<bool> KullaniciGirisiniYaptiMi()async{

    return _sharedPreferences.getBool("a") ?? false;

  }
 


}
