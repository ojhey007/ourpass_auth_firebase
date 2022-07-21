import 'package:flutter/material.dart';

Future showLoadingDialog(BuildContext context) async {
  // show the loading dialog
  showDialog(
      // The user CANNOT close this dialog  by pressing outsite it
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Dialog(
          // The background color
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                // The loading indicator
                CircularProgressIndicator(),
                SizedBox(
                  height: 15,
                ),
                // Some text
                Text('Loading...')
              ],
            ),
          ),
        );
      });
}

void showErrorMessage(BuildContext context, String? message) async {
  // show the loading dialog
  showDialog(
      // The user CANNOT close this dialog  by pressing outsite it
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return Dialog(
          // The background color
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    const Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Icon(
                        Icons.cancel_outlined,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(message ?? "An Error Occurred",
                          style: const TextStyle(fontSize: 15)),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
}

class Utils {
  static showSnackbar(String? message) {
    if (message == null) return;
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
  }
}
