import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class FormSpacer extends StatelessWidget {
  final bool isVertical;
  const FormSpacer({Key? key, required this.isVertical}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isVertical
        ? const SizedBox(height: 25)
        : const SizedBox(
            width: 10,
          );
  }
}
