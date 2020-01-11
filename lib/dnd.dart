import 'dart:async';

import 'layout.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DNDActivity extends StatelessWidget {
  static const platform = const MethodChannel('com.firebrick.calendar_ringer/dnd');

  Future dnd(BuildContext context, {String mode='dnd_request', cancel}) async {
    bool result = await platform.invokeMethod(mode);
    if (result) {
      if (cancel != null) cancel();
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => LoginActivity()
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    dnd(context, mode: 'dnd_check').then((void _) {
      Timer.periodic(Duration(seconds: 2), (t) {
        dnd(context, mode: 'dnd_check', cancel: t.cancel);
      });
    });

    return SplashLayout(
        title: "First things first",
        subtitle: "We need some permissions to change your ringer settings",
        buttonText: 'Grant Do Not Disturb Access',
        callback: () => dnd(context)
    );
  }
}
