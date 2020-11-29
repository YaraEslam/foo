import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:foo/auth/Authentication.dart';
import 'package:foo/utils/constants.dart';
import 'package:foo/utils/translations.dart';
import 'package:responsive_container/responsive_container.dart';

class Login extends StatefulWidget {

  bool lang;
  Login(this.lang);
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {

  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();
  bool _validPhone = false, _validPassword = false;

  bool _passwordVisible = false ;
  Intro intro;

  LoginState(){
    intro = Intro(
      stepCount: 6,
      padding: EdgeInsets.all(8),
      borderRadius: BorderRadius.all(Radius.circular(4)),
      widgetBuilder: StepWidgetBuilder.useDefaultTheme(
        texts: [
          'Change Language',
          'Enter Your Phone',
          'Enter Your Password',
          'Login Button',
          'Register Button',
          'Forget Your Password'
        ],
        buttonTextBuilder: (curr, total) {
          return curr < total - 1 ? 'Next' : 'Finish';
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(microseconds: 0), () {
      intro.start(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.lang ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Color(0xff231351),
        body: ListView(
          padding: EdgeInsets.fromLTRB(16, 24, 24, 16),
          children: <Widget>[
            SizedBox(height: 15),
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: (){
                  changeLang();
                },
                child: Container(
                  key: intro.keys[0],
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      color: Color(0xff2196f3),
                      shape: BoxShape.rectangle
                  ),
                  child: Wrap(
                    children: <Widget>[
                      Icon(Icons.language, color: Colors.white, size: 30,),
                      SizedBox(width: 10,),
                      Text(Translations.of(context).text("lang"), style: TextStyle(color: Colors.white,
                          fontSize: 25,fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
              ),),
            SizedBox(height: 15,),
            ResponsiveContainer(
              heightPercent: 30.0,
              widthPercent: 100.0,
              child: Image.asset(
                'images/logo.png',
              ), //any widget
            ),
            TextField(
              key: intro.keys[1],
              controller: phoneController,
              keyboardType: TextInputType.phone,
              style: Constants.textStyle,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                labelText: Translations.of(context).text("phone" ),
                labelStyle: Constants.textStyle,
                errorText: _validPhone
                    ? Translations.of(context).text("phone")
                    : null,
                border: Constants.inputBorder,
                focusedBorder: Constants.inputBorder,
                enabledBorder: Constants.inputBorder
              ),
            ),
            TextField(
              key: intro.keys[2],
              controller: passwordController,
              keyboardType: TextInputType.text,
              style: Constants.textStyle,
              cursorColor: Colors.white,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                  labelText: Translations.of(context).text("password" ),
                  labelStyle: Constants.textStyle,
                  errorText: _validPassword
                      ? Translations.of(context).text("password")
                      : null,
                  suffixIcon: IconButton(
                    icon: Icon(_passwordVisible? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: (){
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  border: Constants.inputBorder,
                  focusedBorder: Constants.inputBorder,
                  enabledBorder: Constants.inputBorder
              ),
            ),
            SizedBox(height: 15,),
            Align(
              alignment: Alignment.center,
              child: RaisedButton(
                  key: intro.keys[3],
                  padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
                  child: new Text(
                    Translations.of(context).text("login"),
                    style: Constants.textStyle
                  ),
                  onPressed: () {
                    _login();
                  },
                  color: Color(0xff2196f3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  )),
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                    key: intro.keys[4],
                    padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
                    child: new Text(
                      Translations.of(context).text("signUp"),
                      style: Constants.textStyle.copyWith(color: Colors.black),
                    ),
                    onPressed: () {
                      _signUp();
                      },
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    )),

                FlatButton(
                  key: intro.keys[5],
                  padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
                  child: new Text(
                    Translations.of(context).text("forget_pass"),
                    style: Constants.textStyle.copyWith(fontSize: 15),
                  ),
                  onPressed: () {
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }



  // ------------ validation ------------
  void _signUp() async {
    await Firebase.initializeApp();
    Authentication authentication = Authentication(FirebaseAuth.instance);
    validPhone();
    if(_validPhone == false){
      authentication.verifyPhoneNumber(phoneController.text.trim());
    }
  }

  void _login() async {
    await Firebase.initializeApp();
    Authentication authentication = Authentication(FirebaseAuth.instance);
    validPhone();
    validPassword();
    if(_validPhone == false && _validPassword == false){
      authentication.signInWithSmsCode(passwordController.text.trim(), context);
    }
  }

  validPhone(){
    if (phoneController.text.isEmpty || phoneController.text.length <11) {
      setState(() {
        _validPhone = true;
      });
    }else{
      setState(() {
        _validPhone = false;
      });
    }
  }

  validPassword(){
    if (passwordController.text.isEmpty) {
      setState(() {
        _validPassword = true;
      });
    }else{
      setState(() {
        _validPassword = false;
      });
    }
  }
  // ------------ validation ------------

  // ------------ change language ------------
  changeLang() async{
    bool language = !widget.lang;
    language == true ? Translations.load(Locale('en')) : Translations.load(Locale('ar'));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(language),));
  }
  // ------------ change language ------------

}
