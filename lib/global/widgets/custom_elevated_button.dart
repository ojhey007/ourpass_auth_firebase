import 'package:flutter/material.dart';

class OurpassElevatedButton extends StatelessWidget {
  final String buttonIdentifier;
  final Color color;
  final Function()? onPressed;
  final String? buttonLabel;
  final IconData? iconData;
  final bool isIconButton;

  const OurpassElevatedButton({
    Key? key,
    required this.buttonIdentifier,
    required this.color,
    this.onPressed,
    this.buttonLabel,
    required this.isIconButton,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        key: Key(buttonIdentifier),
        onPressed: onPressed,
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size(15, 47)),
            backgroundColor: MaterialStateProperty.all<Color>(color)),
        child: isIconButton
            ? Icon(iconData)
            : Text(buttonLabel!, style: const TextStyle(fontSize: 20.0)));
  }
}
