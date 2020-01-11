import 'login.dart';
import 'main.dart';
import 'volume.manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'calendar/calendar.component.dart';
import 'calendar/calendar.manager.dart';


class ListActivity extends StatefulWidget {
  ListActivity();

  @override
  _ListActivityState createState() => _ListActivityState();
}

class _ListActivityState extends State<ListActivity> {

  List<CalendarComponent> components = [];

  @override
  void initState() {
    super.initState();

    CalendarManager.getInstance().load().then((void _) {
      setState(() {
        components = CalendarManager
            .getInstance()
            .calendars
            .map(
                (x) => CalendarComponent(x, onChange)
        )
            .toList();
      });
    });
  }

  void onChange(String calendarId, bool on) async {
    CalendarManager.getInstance().update(calendarId, on);
    (await VolumeManager.getInstance()).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendars"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white,),
            onPressed: () async {
              // Clear cache
              var prefs = await SharedPreferences.getInstance();
              prefs.remove('calendars');
              prefs.remove('user');
              CalendarManager.getInstance().clear();

              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => LoginActivity()
              ));
            },
          )
        ],
      ),
      body: ListView(
        children: components,
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 20),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () => worker(forceUpdate: true),
      ),
    );
  }
}
