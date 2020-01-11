import 'event.model.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EventHeap {
  List<LocalEvent> arr = [];

  int parent(int i) => ((i - 1) / 2).floor();
  int left(int i) => 2*i+1;
  int right(int i) => 2*i+2;

  void swap(int i, int j) {
    LocalEvent tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
  }

  void insert(LocalEvent obj) {
    arr.add(obj);

    int i = arr.length - 1;
    while (i > 0 && arr[i].compareTo(arr[parent(i)]) < 0) {
      swap(i, parent(i));
      i = parent(i);
    }
  }

  LocalEvent extract() {
    swap(0, arr.length - 1);
    var minEvent = arr.removeAt(arr.length - 1);

    int i = 0;
    while (2*i < arr.length - 1) {
      int newPos = i;
      if (arr[newPos].compareTo(arr[left(i)]) > 0) newPos = left(i);
      if (right(i) < arr.length && arr[newPos].compareTo(arr[right(i)]) > 0) newPos = right(i);
      if (newPos == i) break;
      swap(i, newPos);
      i = newPos;
    }

    return minEvent;
  }

  LocalEvent min() {
    if (arr.length > 0) return arr[0];
    return null;
  }

  List<String> serialize() {
    return arr.map((x) => x.toJson()).toList();
  }

  void parse(List<String> data) {
    this.arr = data.map((x) => LocalEvent.fromJson(jsonDecode(x))).toList();
  }

  void save(String key) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, serialize());
  }

  void load(String key) async {
    var prefs = await SharedPreferences.getInstance();
    parse(prefs.getStringList(key));
    var now = DateTime.now();
    while (min() != null && min().ts.millisecondsSinceEpoch < now.millisecondsSinceEpoch) {
      extract();
    }
  }
}