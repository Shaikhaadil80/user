import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import '../elements/BlockButtonWidget.dart';
import '../helpers/app_config.dart' as config;
import '../models/auth_details.dart';

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends StateMVC<SignUpWidget> {
  late UserController _con;

  _SignUpWidgetState() : super(UserController()) {
    _con = controller as UserController;
  }

  Country selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode('57');
  late SignUpDetails signUpDetails = SignUpDetails();

  void openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(
              //primaryColor: primaryColor,
              textTheme: Theme.of(context)
                  .textTheme
                  .apply(bodyColor: Colors.black, displayColor: Colors.black)),
          child: CountryPickerDialog(
              titlePadding: const EdgeInsets.all(8.0),
              searchCursorColor: Colors.pinkAccent,
              searchInputDecoration:
                  InputDecoration(hintText: S.of(context).search),
              isSearchable: true,
              title: Text(S.of(context).select_your_country_code),
              onValuePicked: (Country country) {
                setState(() {
                  selectedDialogCountry = country;
                });
              },
              itemBuilder: (country) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CountryPickerUtils.getDefaultFlagImage(country),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        flex: 4,
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                country.name,
                              ),
                            )
                          ],
                        )),
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(country.phoneCode),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Scaffold(
        key: _con.scaffoldKey,
        resizeToAvoidBottomInset: true,
        body: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              //   width: config.App(context).appWidth(100),
              height: 150,
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.secondary),
              child: Container(
                //width: config.App(context).appWidth(84),
                height: config.App(context).appHeight(29.5),
                child: Center(
                  child: Text(
                    S.of(context).lets_start_with_register,
                    style: Theme.of(context).textTheme.headline2!.merge(
                        TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 50,
                          color: Theme.of(context).hintColor.withOpacity(0.2),
                        )
                      ]),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 27),
                  width: config.App(context).appWidth(88),
                  //              height: config.App(context).appHeight(55),
                  child: Form(
                    key: _con.loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.text,
                          onSaved: (input) => setState(() {
                            signUpDetails =
                                signUpDetails.copyWith(name: input!);
                          }),
                          validator: (input) => input!.length < 3
                              ? S.of(context).should_be_more_than_3_letters
                              : null,
                          decoration: InputDecoration(
                            labelText: S.of(context).full_name,
                            labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                            contentPadding: const EdgeInsets.all(12),
                            hintText: S.of(context).john_doe,
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.7)),
                            prefixIcon: Icon(Icons.person_outline,
                                color: Theme.of(context).colorScheme.secondary),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (input) => setState(() {
                            signUpDetails =
                                signUpDetails.copyWith(email: input!);
                          }),
                          validator: (input) => !input!.contains('@')
                              ? S.of(context).should_be_a_valid_email
                              : null,
                          decoration: InputDecoration(
                            labelText: S.of(context).email,
                            labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                            contentPadding: const EdgeInsets.all(12),
                            hintText: 'johndoe@gmail.com',
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.7)),
                            prefixIcon: Icon(Icons.alternate_email,
                                color: Theme.of(context).colorScheme.secondary),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          onSaved: (input) => setState(() {
                            signUpDetails =
                                signUpDetails.copyWith(idNumber: input!);
                          }),
                          validator: (input) {
                            if (input!.isEmpty || input.length < 4) {
                              return S.of(context).should_be_a_valid_id_number;
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: S.of(context).identification_number,
                            labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                            contentPadding: const EdgeInsets.all(12),
                            hintText: '1234E124',
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.7)),
                            prefixIcon: Icon(Icons.card_membership_outlined,
                                color: Theme.of(context).colorScheme.secondary),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                          ),
                        ),
                        const SizedBox(height: 30),
                        DropdownButton(
                          isDense: false,
                          hint: Text(S.of(context).select_customer_type),
                          underline: Container(),
                          onChanged: (val) {
                            setState(() {
                              signUpDetails = signUpDetails.copyWith(
                                  userType: val.toString());
                            });
                          },
                          value: signUpDetails.userType,
                          items: List.generate(
                              _con.userTypes.length,
                              (index) => DropdownMenuItem(
                                  value: _con.userTypes[index],
                                  child: Text(_con.userTypes[index]))),
                          isExpanded: true,
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                openCountryPickerDialog();
                              },
                              child: Row(
                                children: [
                                  Text("+" +
                                      '${selectedDialogCountry.phoneCode}'),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: TextFormField(
                              keyboardType: TextInputType.phone,
                              onSaved: (input) => setState(() {
                                signUpDetails = signUpDetails.copyWith(
                                    phone: '+' +
                                        selectedDialogCountry.phoneCode +
                                        input!);
                              }),
                              validator: (input) {
                                if (input!.length < 8) {
                                  return S
                                      .of(context)
                                      .should_be_valid_mobile_number;
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                labelText: S.of(context).phoneNumber,
                                labelStyle: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                contentPadding: const EdgeInsets.all(12),
                                hintText: '623-648-8699',
                                hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.7)),
                                prefixIcon: Icon(Icons.phone_android,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.2))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.5))),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .focusColor
                                            .withOpacity(0.2))),
                              ),
                            ))
                          ],
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          obscureText: _con.hidePassword,
                          onSaved: (input) => setState(() {
                            signUpDetails =
                                signUpDetails.copyWith(password: input!);
                          }),
                          validator: (input) => input!.length < 6
                              ? S.of(context).should_be_more_than_6_letters
                              : null,
                          decoration: InputDecoration(
                            labelText: S.of(context).password,
                            labelStyle: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                            contentPadding: const EdgeInsets.all(12),
                            hintText: '••••••••••••',
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.7)),
                            prefixIcon: Icon(Icons.lock_outline,
                                color: Theme.of(context).colorScheme.secondary),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _con.hidePassword = !_con.hidePassword;
                                });
                              },
                              color: Theme.of(context).focusColor,
                              icon: Icon(_con.hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                          ),
                        ),
                        const SizedBox(height: 30),
                        BlockButtonWidget(
                          text: Text(
                            S.of(context).register,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            if (_con.loginFormKey!.currentState!.validate() &&
                                signUpDetails.userType != null &&
                                signUpDetails.userType.toString().isNotEmpty) {
                              _con.loginFormKey!.currentState!.save();
                              _con.register(signUpDetails);
                              // var bottomSheetController =
                              //     _con.scaffoldKey.currentState.showBottomSheet(
                              //   (context) =>
                              //       MobileVerificationBottomSheetWidget(
                              //           scaffoldKey: _con.scaffoldKey,
                              //           user: _con.user),
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: new BorderRadius.only(
                              //         topLeft: Radius.circular(10),
                              //         topRight: Radius.circular(10)),
                              //   ),
                              // );
                              // bottomSheetController.closed.then((value) {
                              //   _con.register();
                              // });
                            }
                          },
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                MaterialButton(
                  elevation: 0,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/Login');
                  },
                  textColor: Theme.of(context).hintColor,
                  child: Text(S.of(context).i_have_account_back_to_login),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
