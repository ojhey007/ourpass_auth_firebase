import 'package:flutter/material.dart';
import 'package:ourpass/globals/app_material_page_route.dart';

push({required BuildContext context, required Widget page}) {
  Navigator.push(context, AppMaterialPageRoute(page: page));
}
