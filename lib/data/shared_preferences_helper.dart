import 'package:shared_preferences/shared_preferences.dart';
import 'note.dart';
import 'dart:convert';

class SharedPreferencesHelper {
  static late SharedPreferences prefs;
  static final notePrefix = 'note_';
  static final latestNoteIdKey = 'latest_note_id';

  Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future storeNote(Note note) async {
    prefs.setString(notePrefix + note.id.toString(), json.encode(note.toJson()));
  }

  List<Note> getStoredNotes() {
    List<Note> notes = [];
    Set<String> keys = prefs.getKeys();
    keys.forEach((String key) {
      if (key.startsWith(notePrefix)) {
        Note note = Note.fromJson(json.decode(prefs.getString(key) ?? ''));
        notes.add(note);
      }
    });

    return notes;
  }

  Future deleteNote(int id) async {
    prefs.remove(notePrefix + id.toString());
  }

  Future increaseLatestNoteId() async {
    int latestNoteId = prefs.getInt(latestNoteIdKey) ?? 0;
    latestNoteId++;
    await prefs.setInt(latestNoteIdKey, latestNoteId);
  }

  int getLatestNoteId() {
    return prefs.getInt(latestNoteIdKey) ?? 0;
  }
}
