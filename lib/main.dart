import 'package:account_book/route/page_name.dart';
import 'package:account_book/ui/bloc/system/application_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final themeData = ThemeData(
      primaryColor: Colors.white,
      backgroundColor: Colors.white,
      primaryColorDark: Colors.white,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.black12,
      brightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    FlutterStatusbarcolor.setStatusBarColor(Colors.white12);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      darkTheme: themeData,
      home: ApplicationBloc.getInstance().getPage(PageName.DefaultPage),
    );
  }
}

