import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'session.dart';

class SPHelper {
  static late SharedPreferences prefs;

  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future writeSession(Session session) async {
    prefs.setString(session.id.toString(), json.encode(session.toJson()));
  }

  Iterable<Session> getSessions() {
    Set<String> keys = prefs.getKeys();
    return keys.where((element) => element != 'counter').map((key) {
      return Session.fromJson(json.decode(prefs.getString(key) ?? ''));
    });
  }

  Future setCounter() async {
    int counter = prefs.getInt('counter') ?? 0;
    counter++;
    await prefs.setInt('counter', counter);
  }

  int getCounter() {
    return prefs.getInt('counter') ?? 0;
  }

  Future deleteSession(int id) async {
    prefs.remove(id.toString());
  }
}
