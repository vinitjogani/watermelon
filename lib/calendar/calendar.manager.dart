import 'calendar.model.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class CalendarManager {

  static CalendarManager _instance = CalendarManager();
  static CalendarManager getInstance() => _instance;

  CalendarManager() {
    load();
  }

  List<Calendar> calendars = [];
  List<bool> active = [];

  void clear() {
    calendars.clear();
    active.clear();
  }

  void add(Calendar calendar, {on = false}) {
    calendars.add(calendar);
    active.add(on);
  }

  bool status(String calendarId) {
    var index = calendars.indexWhere((x) => x.calendarId == calendarId);
    return index < calendars.length && active[index];
  }

  void update(String calendarId, bool on) {
    var index = calendars.indexWhere((x) => x.calendarId == calendarId);
    if(index < calendars.length) active[index] = on;
    save();
  }

  List<String> serialize() {
    var activeString = active.map((x) => x?"1":"0").join();
    var list = calendars.map((x) => x.toJson()).toList();
    list.add(activeString);
    return list;
  }

  void parse(List<String> data) {
    var activeString = data.removeLast();
    active.clear();
    active.insertAll(0, activeString.split('').map((x) => x == "1").toList());
    calendars.clear();
    calendars.insertAll(0, data.map((x) => Calendar.fromJson(jsonDecode(x))).toList());
  }

  void save({String key = "calendars"}) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, serialize());
  }

  Future<void> load({String key = "calendars"}) async {
    var prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey(key)) parse(prefs.getStringList(key));
    else clear();
  }
}
