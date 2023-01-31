import 'package:first_application/presentation/login/old_screens/login_view.dart';
import 'package:first_application/presentation/login/login_viewmodel.dart';
import 'package:first_application/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:first_application/presentation/login/old_screens/login_view.dart';
import 'package:first_application/app/app_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/di.dart';
import '../../../presentation/login/login_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

AppPreferences _appPreferences = instance<AppPreferences>();






class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  final List<Widget> _children = [
    homePage(),
    addPage(),
    profilePage(),
  ];

  void onTabTapped(int index) {
    setState(() {currentIndex = index;});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
        title: Text("TEST APP!"),
        actions: [
          IconButton(onPressed: (){
            _appPreferences.KullaniciGirisiniYapmadi();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          }, icon: Icon(Icons.logout))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home,color: ColorManager.primary,)),
          BottomNavigationBarItem(label: "Add", icon: Icon(Icons.add,color: ColorManager.primary,)),
          BottomNavigationBarItem(label: "Profile", icon: Icon(Icons.person,color: ColorManager.primary,))
        ],
      ),


      body: _children[currentIndex]

    );
  }
}

class homePage extends StatelessWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("HOMEPAGE!"),
      ),
    );
  }
}

class addPage extends StatelessWidget {
  const addPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("ADDING PAGE!")
      ),
    );
  }
}

class profilePage extends StatelessWidget {
  const profilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("PROFILE PAGE!"),
      )
    );
  }
}
