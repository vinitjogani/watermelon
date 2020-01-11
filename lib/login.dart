import 'download.dart';
import 'list.dart';
import 'user.dart';
import 'layout.dart';
import 'credentials.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:googleapis/calendar/v3.dart' as cal;
import "package:googleapis_auth/auth_io.dart" as auth;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';



class LoginActivity extends StatefulWidget {

  static const platform = const MethodChannel('samples.flutter.dev/battery');

  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {
  final clientId = new auth.ClientId(CLIENT_ID, CLIENT_SECRET);
  bool showLogin = true;

  final scopes = [
    cal.CalendarApi.CalendarReadonlyScope,
    cal.CalendarApi.CalendarEventsReadonlyScope
  ];

  void check(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getKeys().contains('calendars')) home(context);
  }

  void prompt(String url) async {
    await FlutterWebBrowser.openWebPage(url: url);
  }

  Future<cal.CalendarApi> login({obtain = true}) async {
    User user = await User.load();

    auth.AutoRefreshingAuthClient client;
    if (user != null) {
      print("Saved user found");
      client = user.getClient(clientId, scopes);
    }
    else if (obtain) {
      print("No saved user found");
      client = await auth.clientViaUserConsent(clientId, scopes, prompt);
      var newUser = User.fromCredentials(client.credentials);
      newUser.save();
    }
    else
      return null;

    return cal.CalendarApi(client);
  }

  Future download(cal.CalendarApi api) async {
    var downloader = CalendarDownloader(api);
    await downloader.downloadCalendars();
  }

  void home(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => ListActivity(),
      maintainState: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    login(obtain: false).then((x) async {
      if (x != null) {
        setState(() {
          showLogin = false;
        });
        await download(x);
        home(context);
      }
    });

    return  SplashLayout(
        title: "Watermelon",
        subtitle: "Calendar-synced Ringer",
        buttonText: 'Login',
        callback: () async {
          await download(await login());
          home(context);
        },
        buttonVisible: showLogin,
    );
  }
}
