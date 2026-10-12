import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';

class NoteStorage {
  static const String storageKey = 'personal_notes';

  late final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  Future<List<Note>> loadNotes() async {
    final jsonString = await _preferences.getString(storageKey);
    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((item) => Note.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveNotes(List<Note> notes) async {
    // SharedPreferences lưu được String, nên chuyển danh sách thành JSON.
    final jsonString = jsonEncode(notes.map((note) => note.toJson()).toList());
    await _preferences.setString(storageKey, jsonString);
  }
}
