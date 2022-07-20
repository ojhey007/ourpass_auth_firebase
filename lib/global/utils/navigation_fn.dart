import 'package:flutter/material.dart';
import 'package:ourpass/global/utils/app_material_page_route.dart';

push({required BuildContext context, required Widget page}) {
  Navigator.push(context, AppMaterialPageRoute(page: page));
}

pushUntil({required BuildContext context, required Widget page}) {
  Navigator.pushAndRemoveUntil(
    context,
    AppMaterialPageRoute(page: page),
    ModalRoute.withName('/login'),
  );
}
