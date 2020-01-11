import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

class LoginBrowser extends StatefulWidget {

  final String url;

  LoginBrowser(this.url);

  @override
  _LoginBrowserState createState() => _LoginBrowserState();
}

class _LoginBrowserState extends State<LoginBrowser> {

  @override
  Widget build(BuildContext context) {

    FlutterWebBrowser.openWebPage(
        url: "https://flutter.io/",
        androidToolbarColor: Colors.deepPurple
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),

    );
  }
}
