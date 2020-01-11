import 'calendar/calendar.manager.dart';
import 'event/event.manager.dart';
import 'package:volume/volume.dart';

class VolumeManager {

  static VolumeManager _instance;
  static Future<VolumeManager> getInstance() async {
    if (_instance == null) {
      _instance = new VolumeManager();
      await _instance.refresh();
    }
    return _instance;
  }

  int semaphore = 0;
  List<EventHeap> heaps = [];

  Future refresh() async {
    var manager = CalendarManager.getInstance();
    heaps.clear();

    for (int i = 0; i < manager.calendars.length; i ++) {
      if (!manager.active[i]) continue;

      var heap = EventHeap();
      heap.load(manager.calendars[i].calendarId);

      heaps.add(heap);
    }
  }

  static void mute() {
    print("Muting");
    Volume.controlVolume(AudioManager.STREAM_RING);
    Volume.setVol(0);
  }

  static void unmute() {
    print("Unmuting");
    Volume.controlVolume(AudioManager.STREAM_RING);
    Volume.setVol(100);
  }

  void loop() {
    print("Hit the loop");

    int previous = semaphore;
    var now = DateTime.now();
    // Go through the heap of each calendar
    for (var heap in heaps) {
      var td = heap.min() == null ? 6 : heap.min().ts.millisecondsSinceEpoch - now.millisecondsSinceEpoch;
      // Pop while the earliest event is no more than 5 minutes into the future
      while (td / (1000 * 60) < 5) {
        var event = heap.extract();

        print("Found event at ${event.ts.toIso8601String()}");
        if (event.start) semaphore ++;
        else semaphore--;

        td = heap.min() == null ? 6 : heap.min().ts.millisecondsSinceEpoch - now.millisecondsSinceEpoch;
      }
    }

    print("Semaphore is at $semaphore");

    if (previous == semaphore) return;
    if (semaphore < 0) semaphore = 0;

    if (semaphore == 0) unmute();
    else mute();
  }

}