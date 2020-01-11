import 'download.dart';
import 'user.dart';
import 'volume.manager.dart';
import 'package:flutter/material.dart';

import 'package:background_fetch/background_fetch.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'dnd.dart';
import 'credentials.dart';


Future update() async {

  final clientId = new auth.ClientId(CLIENT_ID, CLIENT_SECRET);
  final scopes = [
    cal.CalendarApi.CalendarReadonlyScope,
    cal.CalendarApi.CalendarEventsReadonlyScope
  ];

  User user = await User.load();
  auth.AutoRefreshingAuthClient client;
  if (user == null) return;

  client = user.getClient(clientId, scopes);
  var api = cal.CalendarApi(client);

  CalendarDownloader(api).downloadCalendars();
}

void worker({forceUpdate: false}) async {
  // Only run once in two hours
  if (forceUpdate || (DateTime.now().minute < 15 && DateTime.now().hour % 2 == 0))
    await update();

  VolumeManager.getInstance().then((i) {
    i.loop();
    BackgroundFetch.finish();
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: DNDActivity());
  }
}


void main() {
  runApp(MyApp());

  BackgroundFetch.configure(new BackgroundFetchConfig(
      enableHeadless: true,
      startOnBoot: true,
      stopOnTerminate: false
  ), worker);
  BackgroundFetch.registerHeadlessTask(worker);
  BackgroundFetch.start();
}
