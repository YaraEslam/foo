import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foo/model/User.dart';
import 'package:foo/screens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  final FirebaseAuth _firebaseAuth;
  String _verificationCode = "";

  Authentication(FirebaseAuth firebaseAuth) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+2$phoneNumber",
        timeout: Duration(seconds: 60),
        verificationCompleted: (authCredential) => _verificationComplete(authCredential),
        verificationFailed: (authException) => _verificationFailed(authException),
        codeAutoRetrievalTimeout: (verificationId) => _codeAutoRetrievalTimeout(verificationId),
        codeSent: (verificationId, [code]) => _smsCodeSent(verificationId, [code]));
  }

  _verificationComplete(AuthCredential authCredential) {
    print('Sign up with phone complete');
  }

  void _smsCodeSent(String verificationCode, List<int> code) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    this._verificationCode = verificationCode;
    preferences.setString("verificationId", verificationCode);
    print("verification code  $_verificationCode");
  }

  String _verificationFailed(Exception authException) {
    return authException.toString();
  }

  void _codeAutoRetrievalTimeout(String verificationCode) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    this._verificationCode = verificationCode;
    preferences.setString("verificationId", verificationCode);
    print("verify=" + this._verificationCode);
  }


  Future<UserData> signInWithSmsCode(String code, context) async {
    print("smsCode" + code.toString());
    UserData _user;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    AuthCredential authCredential = PhoneAuthProvider.credential(smsCode: code, verificationId: preferences.getString("verificationId"));
    FirebaseAuth.instance.signInWithCredential(authCredential).then((authResult) {
      _user = UserData(userId: authResult.user.uid, phoneNum: authResult.user.phoneNumber, userName: authResult.user.displayName);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen(),));
    }).catchError((onError) => throw Exception('Error logging in:$onError'));
    return _user;
  }

  Future<UserData> getUser() async {
    User firebaseUser = _firebaseAuth.currentUser;
    return UserData(userId: firebaseUser.uid, userName: firebaseUser.displayName, phoneNum: firebaseUser.phoneNumber);
  }
}
