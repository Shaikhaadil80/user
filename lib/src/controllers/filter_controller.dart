import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/city.dart';
import '../repository/city_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/field.dart';
import '../models/filter.dart';
import '../repository/field_repository.dart';

class FilterController extends ControllerMVC {
  GlobalKey<ScaffoldState>? scaffoldKey;
  List<Field> fields = [];
  List<City> cities = [];
  Filter? filter;
  Cart? cart;

  FilterController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForFilter().whenComplete(() {
      listenForFields();
    });
    listenForCities();
  }

  Future<void> listenForFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
    });
  }

  Future<void> saveFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    filter!.fields = this.fields.where((_f) => _f.selected).toList();
    prefs.setString('filter', json.encode(filter!.toMap()));
  }

  void listenForCities({String? message}) async {
    try {
      var res = await getSupportedCities();

      cities = res.map((e) => City.fromMap(e)).toList();
      setState(() {});
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
        content: Text(S.of(state!.context).verify_your_internet_connection),
      ));
    }
  }

  void listenForFields({String? message}) async {
    fields.add(new Field.fromJSON(
        {'id': '0', 'name': S.of(state!.context).all, 'selected': true}));
    final Stream<Field> stream = await getFields();
    stream.listen((Field _field) {
      setState(() {
        if (filter!.fields.contains(_field)) {
          _field.selected = true;
          fields.elementAt(0).selected = false;
        }
        fields.add(_field);
      });
    }, onError: (a) {
      print(a);
      ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
        content: Text(S.of(state!.context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        ScaffoldMessenger.of(scaffoldKey!.currentContext!).showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> refreshFields() async {
    fields.clear();
    listenForFields(
        message: S.of(state!.context).addresses_refreshed_successfuly);
  }

  void clearFilter() {
    setState(() {
      filter!.open = false;
      filter!.city = '';
      filter!.delivery = false;
      resetFields();
    });
  }

  void resetFields() {
    filter!.fields = [];
    fields.forEach((Field _f) {
      _f.selected = false;
    });
    fields.elementAt(0).selected = true;
  }

  void onChangeFieldsFilter(int index) {
    if (index == 0) {
      // all
      setState(() {
        resetFields();
      });
    } else {
      setState(() {
        fields.elementAt(index).selected = !fields.elementAt(index).selected;
        fields.elementAt(0).selected = false;
      });
    }
  }
}
