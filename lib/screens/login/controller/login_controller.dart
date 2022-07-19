import 'package:flutter/material.dart';

final loginFormKey = GlobalKey<FormState>();

bool validateAndSaveForm() {
  final form = loginFormKey.currentState;
  if (form!.validate()) {
    form.save();
    return true;
  }
  return false;
}
