import 'package:account_book/route/page_name.dart';
import 'package:account_book/tools/colors.dart';
import 'package:account_book/ui/bloc/system/application_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  MyApp({Key? key}) : super(key: key);

  final themeData = ThemeData(
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      primaryColor: Colors.orange,
      scaffoldBackgroundColor: lightBackground,
      iconTheme: IconThemeData(
        color: Colors.orange,
      ),
      dividerColor: Colors.grey,
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.black, fontSize: 25),
        bodyText2: TextStyle(color: Colors.black, fontSize: 22),
        subtitle1: TextStyle(color: Colors.black, fontSize: 20),
        subtitle2: TextStyle(color: Colors.black, fontSize: 18),
        headline1: TextStyle(color: Colors.grey, fontSize: 25),
        headline2: TextStyle(color: Colors.grey, fontSize: 22),
        headline3: TextStyle(color: Colors.grey, fontSize: 20),
        headline4: TextStyle(color: Colors.grey, fontSize: 18),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.black,
        secondary: Colors.orange,
        tertiary: Colors.white,
        // brightness: Brightness.light,
        background: Colors.black12,
        surface: Colors.black12,
        primaryContainer: Colors.white,
        onBackground: lightSecond,
      ));

  final darkThemeData = ThemeData(
      primaryColor: Colors.white12,
      scaffoldBackgroundColor: Colors.black,
      iconTheme: const IconThemeData(
        color: Colors.orange,
      ),
      dividerColor: Colors.white38,
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.white, fontSize: 25),
        bodyText2: TextStyle(color: Colors.white, fontSize: 20),
        subtitle1: TextStyle(color: Colors.white, fontSize: 18),
        subtitle2: TextStyle(color: Colors.white, fontSize: 15),
        headline1: TextStyle(color: Colors.grey, fontSize: 25),
        headline2: TextStyle(color: Colors.grey, fontSize: 22),
        headline3: TextStyle(color: Colors.grey, fontSize: 20),
        headline4: TextStyle(color: Colors.grey, fontSize: 18),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.white,
        secondary: Colors.black,
        tertiary: darkBackground,
        // brightness: Brightness.light,
        background: lightBlack,
        surface: Colors.grey,
        primaryContainer: Colors.white12,
        onBackground: Colors.white12,
      ));

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeData,
            darkTheme: darkThemeData,
            themeMode: currentMode,
            home: ApplicationBloc.getInstance().getPage(PageName.DefaultPage),
          );
        });
  }
}
