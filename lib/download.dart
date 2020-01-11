import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'calendar/calendar.model.dart';
import 'calendar/calendar.manager.dart';
import 'event/event.model.dart';
import 'event/event.manager.dart';

import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as cal;

class CalendarDownloader {

  final cal.CalendarApi api;

  CalendarDownloader(this.api);

  Color parseHex(String h) => Color(int.parse("FF" + h.substring(1), radix: 16));

  Future downloadCalendars() async {
    var calendars = (await api.calendarList.list()).items.map(
      (x) => Calendar(x.summary, x.id, x.description, parseHex(x.backgroundColor))
    );

    var existing = CalendarManager.getInstance().calendars.map((x) => x.calendarId);
    for (var c in calendars) {
      if (!existing.contains(c.calendarId)) {
        CalendarManager.getInstance().add(c);
      }
      print("Downloading ${c.calendarId}");
      await downloadCalendar(c.calendarId);
    }

    CalendarManager.getInstance().save();
  }

  Future downloadCalendar(calendarId) async {
    var events = (await api.events.list(calendarId)).items;

    EventHeap heap = new EventHeap();
    for (var event in events) {
      if (event == null || event.start == null || event.end == null) continue;
      if (event.start.dateTime == null || event.end.dateTime == null) continue;

      heap.insert(LocalEvent(event.start.dateTime, true));
      heap.insert(LocalEvent(event.end.dateTime, false));
    }

    heap.save(calendarId);
  }

}