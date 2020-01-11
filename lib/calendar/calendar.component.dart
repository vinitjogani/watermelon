import 'package:shared_preferences/shared_preferences.dart';

import 'calendar.manager.dart';

import 'calendar.model.dart';

import 'package:flutter/material.dart';


class CalendarComponent extends StatefulWidget {

  final Calendar calendar;
  final Function onChange;

  CalendarComponent(this.calendar, this.onChange);

  @override
  _CalendarComponentState createState() => _CalendarComponentState();
}

class _CalendarComponentState extends State<CalendarComponent> {

  bool on = false;
  int numEvents = 0;

  @override
  void initState() {
    super.initState();
    on = CalendarManager.getInstance().status(widget.calendar.calendarId);
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        numEvents = prefs.getStringList(widget.calendar.calendarId).length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(2)),
            boxShadow: <BoxShadow>[
              BoxShadow(color: Colors.grey[300], blurRadius: 55, spreadRadius: 5)
            ]
        ),
        child: Row(
          children: <Widget>[
            Container(
              color: widget.calendar.color,
              width: 50,
              height: 82,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          widget.calendar.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto'
                          ),
                        ),
                        Text(
                            "$numEvents future events"
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Switch(
                      value: on, onChanged: (bool value) {
                      setState(() {
                        on = value;
                        widget.onChange(widget.calendar.calendarId, on);
                      });
                    },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
