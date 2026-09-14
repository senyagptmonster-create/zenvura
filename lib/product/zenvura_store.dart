import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class ZenvuraStore extends ChangeNotifier {
  List<String> sessions = [];
  int streak = 0;
  
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    sessions = prefs.getStringList('zen_sessions') ?? [];
    streak = prefs.getInt('zen_streak') ?? 0;
    
    if (sessions.isEmpty) {
      try {
        final jsonStr = await rootBundle.loadString('packages/zenvura/content.json');
        final data = jsonDecode(jsonStr);
        sessions = List<String>.from(data['sessions']);
        streak = data['streak'];
      } catch (e) {
        // Fallback
      }
    }
    notifyListeners();
  }

  Future<void> addSession(String name) async {
    sessions.add(name);
    streak += 1;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('zen_sessions', sessions);
    await prefs.setInt('zen_streak', streak);
    notifyListeners();
  }
}
