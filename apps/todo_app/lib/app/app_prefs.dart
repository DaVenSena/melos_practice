import 'dart:convert';

import 'package:data/entities/user.dart';
import 'package:domain/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;
import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static const String _user = 'user';

  Future<void> setUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_user, jsonEncode(user.toEntity().toJson()));
  }

  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString(_user);
    return user != null
        ? UserModel.fromEntity(UserEntity.fromJson(jsonDecode(user)))
        : null;
  }
}

final appPrefsProvider = Provider<AppPrefs>((ref) {
  return AppPrefs();
});
