import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class Utils {
  static void showTopSnackBar(
    Duration duration,
    BuildContext context,
    String message,
    Color color,
  ) =>
      showSimpleNotification(
        Text( message, style:TextStyle(color: Colors.amber)),
        //Text('Estado de Internet', style:TextStyle(color: Colors.amber)),
        //subtitle: Text(message),
        background: color,
        duration: duration,
        slideDismiss: true,
        slideDismissDirection: DismissDirection.up
      );
}
