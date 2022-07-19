import 'package:flutter/material.dart';

class AppMaterialPageRoute extends PageRouteBuilder {
  final Widget page;
  AppMaterialPageRoute({required this.page})
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                page,
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                      parent: animation, curve: Curves.fastOutSlowIn)),
                  child: FadeTransition(
                      opacity: Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(CurvedAnimation(
                          parent: animation, curve: Curves.linear)),
                      child: child));
            });
}
