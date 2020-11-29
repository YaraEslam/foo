import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foo/screens/login.dart';
import 'package:foo/utils/translations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foo',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('ar', '')
      ],
      home: Login(true),
    );
  }

}