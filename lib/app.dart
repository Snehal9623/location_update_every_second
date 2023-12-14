import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:snehal_chavan/Location/location.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    configLoading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
            debugShowCheckedModeBanner: false,

            builder: EasyLoading.init(),

            home: GestureDetector(
              child: LocationPage(),
            ),
          );



  }

  void configLoading() {
    EasyLoading.instance
      // ..indicatorWidget = CustomLoaderWidget(message: "")
      ..indicatorType = EasyLoadingIndicatorType.fadingFour
      ..loadingStyle = EasyLoadingStyle.light
      ..maskColor = Colors.black26
      ..maskType = EasyLoadingMaskType.custom
      ..indicatorColor = Colors.pinkAccent
      ..indicatorSize = 45.0
      ..backgroundColor = Colors.black26
      ..radius = 10.0
      ..userInteractions = true
      ..dismissOnTap = true;
  }
}
