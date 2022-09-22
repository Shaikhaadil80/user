import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/auth_details.dart';
import '../models/route_argument.dart';
import '../models/user.dart' as model;
import '../pages/mobile_verification_2.dart';
import '../repository/user_repository.dart' as repository;

class UserController extends ControllerMVC {
  model.User? user;
  bool hidePassword = true;
  bool loading = false;
  List<String> userTypes = ['Whole Saler', 'Retailer'];
  GlobalKey<FormState>? loginFormKey;
  GlobalKey<ScaffoldState>? scaffoldKey;
  FirebaseMessaging? _firebaseMessaging;
  OverlayEntry? loader;

  UserController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging!.getToken().then((String? _deviceToken) {
      user!.deviceToken = _deviceToken!;
      print('device token is: ' + _deviceToken);
    }).catchError((e) {
      print('Notification not configured');
    });
  }

  void login(email, password) async {
    loader = Helper.overlayLoader(state!.context);
    FocusScope.of(state!.context).unfocus();

    if (loginFormKey!.currentState!.validate()) {
      loginFormKey!.currentState!.save();
      Overlay.of(state!.context)!.insert(loader!);
      print(email);
      print(password);
      repository
          .login(LoginDetails(email: email, password: password))
          .then((value) {
        loader!.remove();
        if (value != null) {
          Navigator.of(scaffoldKey!.currentContext!)
              .pushReplacementNamed('/Pages', arguments: 0);
        } else {
          ScaffoldMessenger.of(scaffoldKey!.currentContext!)
              .showSnackBar(SnackBar(
            content: Text(S.of(state!.context).wrong_email_or_password),
          ));
        }
      }).catchError((e) {
        print(" the error body ${e}");
        loader!.remove();
        if (e.message == 'Account email has not been verified') {
          ScaffoldMessenger.of(scaffoldKey!.currentContext!)
              .showSnackBar(const SnackBar(
            content: Text('Account email has not been verified'),
          ));
        } else {
          if (e.message != null) {
            ScaffoldMessenger.of(scaffoldKey!.currentContext!)
                .showSnackBar(SnackBar(
              content: Text(e.message),
            ));
          } else {
            ScaffoldMessenger.of(scaffoldKey!.currentContext!)
                .showSnackBar(SnackBar(
              content: Text(S.of(state!.context).this_account_not_exist),
            ));
          }
        }
      }).whenComplete(() {
        Helper.hideLoader(loader!);
      });
    }
  }

  Future<void> verifyPhone(model.User user) async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      repository.currentUser.value!.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int? forceCodeResent]) {
      repository.currentUser.value!.verificationId = verId;
      Navigator.push(
        scaffoldKey!.currentContext!,
        MaterialPageRoute(
            builder: (context) => MobileVerification2(
                  onVerified: (v) {
                    Navigator.of(scaffoldKey!.currentContext!)
                        .pushReplacementNamed('/Pages', arguments: 0);
                  },
                )),
      );
    };
    final PhoneVerificationCompleted _verifiedSuccess =
        (AuthCredential auth) {};
    final PhoneVerificationFailed _verifyFailed = (FirebaseAuthException e) {
      ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
        content: Text(e.message.toString()),
      ));
      print(e.toString());
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: user.phone!,
      timeout: const Duration(seconds: 5),
      verificationCompleted: _verifiedSuccess,
      verificationFailed: _verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
  }

  void register(SignUpDetails signUpDetails) async {
    loader = Helper.overlayLoader(state!.context);
    FocusScope.of(state!.context).unfocus();
    Overlay.of(state!.context)!.insert(loader!);
    String? token = await FirebaseMessaging.instance.getToken();
    signUpDetails = signUpDetails.copyWith(deviceToken: token);
    repository.register(signUpDetails).then((value) {
      print(value.email);

      loader!.remove();
      // if (value != null && value.apiToken != null) {
      Navigator.of(scaffoldKey!.currentContext!).pushReplacementNamed(
          '/emailVerification',
          arguments: RouteArgument(param: value.email));
      // } else {
      //   ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
      //     content: Text(S.of(state!.context).wrong_email_or_password),
      //   ));
      // }
    }).catchError((e) {
      loader!.remove();
      print(" the error body ${e}");
      ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
        content: Text(json.decode(e.message)['message']),
      ));
    }).whenComplete(() {
      Helper.hideLoader(loader!);
    });
  }

  void resetPassword() {
    loader = Helper.overlayLoader(state!.context);
    FocusScope.of(state!.context).unfocus();
    if (loginFormKey!.currentState!.validate()) {
      loginFormKey!.currentState!.save();
      Overlay.of(state!.context)!.insert(loader!);
      repository.resetPassword(user!).then((value) {
        if (value == true) {
          ScaffoldMessenger.of(scaffoldKey!.currentContext!)
              .showSnackBar(SnackBar(
            content: Text(S
                .of(state!.context)
                .your_reset_link_has_been_sent_to_your_email),
            action: SnackBarAction(
              label: S.of(state!.context).login,
              onPressed: () {
                Navigator.of(scaffoldKey!.currentContext!)
                    .pushReplacementNamed('/Login');
              },
            ),
            duration: const Duration(seconds: 10),
          ));
        } else {
          loader!.remove();
          ScaffoldMessenger.of(scaffoldKey!.currentContext!)
              .showSnackBar(SnackBar(
            content: Text(S.of(state!.context).error_verify_email_settings),
          ));
        }
      }).whenComplete(() {
        Helper.hideLoader(loader!);
      });
    }
  }
}
