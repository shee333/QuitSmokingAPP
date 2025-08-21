import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/smoking_entry.dart';
import '../utils/date.dart';

class QuitState extends ChangeNotifier {
  static const String _entriesKey = 'smoking_entries';
  static const String _goalKey = 'daily_goal';
  static const String _startKey = 'quit_start';

  List<SmokingEntry> _entries = [];
  int _dailyGoal = 0; // 0 表示未设置
  DateTime? _quitStart; // 开始戒烟的日期

  List<SmokingEntry> get entries => List.unmodifiable(_entries);
  int get dailyGoal => _dailyGoal;
  DateTime? get quitStart => _quitStart;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_entriesKey) ?? [];
    _entries = raw
        .map((s) => SmokingEntry.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    _dailyGoal = prefs.getInt(_goalKey) ?? 0;
    final quitStartStr = prefs.getString(_startKey);
    _quitStart = quitStartStr != null ? DateTime.parse(quitStartStr) : null;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _entriesKey,
      _entries.map((e) => jsonEncode(e.toJson())).toList(),
    );
    await prefs.setInt(_goalKey, _dailyGoal);
    if (_quitStart != null) {
      await prefs.setString(_startKey, _quitStart!.toIso8601String());
    }
  }

  Future<void> addEntry({String? note}) async {
    _entries.add(SmokingEntry(dateTime: DateTime.now(), note: note));
    await _persist();
    notifyListeners();
  }

  Future<void> setDailyGoal(int goal) async {
    _dailyGoal = goal;
    await _persist();
    notifyListeners();
  }

  Future<void> setQuitStart(DateTime start) async {
    _quitStart = DateTime(start.year, start.month, start.day);
    await _persist();
    notifyListeners();
  }

  int countForDay(DateTime day) {
    final key = dateKey(day);
    return _entries.where((e) => dateKey(e.dateTime) == key).length;
  }

  Map<DateTime, int> recentCounts({int days = 7}) {
    final map = <DateTime, int>{};
    for (final d in recentDays(days: days)) {
      map[d] = countForDay(d);
    }
    return map;
  }

  int get todayCount => countForDay(todayLocal());

  int get streakDays {
    if (_quitStart == null) return 0;
    return todayLocal().difference(_quitStart!).inDays + 1;
  }
}


