import 'package:flutter/material.dart';

class AlertForm {
  dialogBuilder(BuildContext context, Widget alertForm) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: alertForm,
          );
        });
  }
}
