import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calendar
{
  final String name;
  final String calendarId;
  final String description;
  final Color color;

  Calendar(this.name, this.calendarId, this.description, this.color);

  String toJson() {
    Map data = {
      'name' : name,
      'id': calendarId,
      'desc': description,
      'color': color.value
    };
    return jsonEncode(data);
  }

  static Calendar fromJson(json) {
    return Calendar(json['name'], json['id'], json['desc'], Color(json['color']));
  }
}
