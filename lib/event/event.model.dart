import 'dart:convert';

class LocalEvent {
  final DateTime ts;
  final bool start;

  LocalEvent(this.ts, this.start);

  int compareTo(LocalEvent other) => ts.compareTo(other.ts);

  static LocalEvent fromJson(Map json) {
    return LocalEvent(DateTime.parse(json['ts']), json['start']);
  }

  String toJson() {
    Map data = {
      'ts' : this.ts.toIso8601String(),
      'start': this.start
    };
    return jsonEncode(data);
  }
}