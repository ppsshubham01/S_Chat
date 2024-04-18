
import 'package:get/get.dart';

import 'package:s_chat/res/routes/routes_name.dart';
import 'package:s_chat/screens/auth_screens/welcom_phone_auth.dart';
import 'package:s_chat/screens/home_screens/home_page.dart';
import 'package:s_chat/screens/home_screens/home_screens.dart';
import 'package:s_chat/screens/home_screens/news_page.dart';
import 'package:s_chat/screens/home_screens/notes_page.dart';
import 'package:s_chat/screens/home_screens/setting_page.dart';
import 'package:s_chat/screens/notes_screen/notes_editScreen.dart';

class AppRoutes{

  static appRoutes ()=> [

    GetPage(name: RouteName.phoneAuthScreen,
        page: ()=> const PhoneAuth(),
      // transitionDuration: Duration(microseconds: 250),
      transition: Transition.leftToRightWithFade
    ),

    GetPage(name: RouteName.homeScreen,
        page: ()=> const HomeScreen(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.leftToRightWithFade
    ),
    GetPage(name: RouteName.homePage,
        page: ()=> const HomePage(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.leftToRightWithFade
    ),
    GetPage(name: RouteName.notesPage,
        page: ()=> const NotesPage(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.leftToRightWithFade
    ),
    GetPage(name: RouteName.newsPage,
        page: ()=> const NewsPage(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.leftToRightWithFade
    ),
    GetPage(name: RouteName.settingPage,
        page: ()=> const SettingPage(),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.leftToRightWithFade
    ),


    GetPage(name: RouteName.notesEditScreen,
        page: ()=> NotesEditScreen(onSave: (NotesModel ) {  }, ),
      transitionDuration: const Duration(microseconds: 250),
      transition: Transition.leftToRightWithFade
    ),

  ];
}