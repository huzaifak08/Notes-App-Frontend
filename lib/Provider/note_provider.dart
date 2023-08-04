import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/notes_model.dart';

class NotesProvider with ChangeNotifier {
  static const String _baseUrl = "http://192.168.10.20:2000/notes";

  List<NotesModel> notes = [];

  // Add Notes:
  Future<void> addNote(NotesModel note) async {
    try {
      final response =
          await http.post(Uri.parse("$_baseUrl/add"), body: note.toMap());

      debugPrint(response.body);

      debugPrint(response.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body.toString());
        debugPrint('Data: $data');

        notifyListeners();
      } else {
        debugPrint('Got error in response');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Get Notes:
  Future<List<NotesModel>> getNote() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.10.20:2000/notes/list'));

      var data = jsonDecode(response.body.toString());

      if (response.statusCode == 200) {
        notes.clear();
        for (Map<String, dynamic> i in data) {
          NotesModel newNote = NotesModel.fromMap(i);
          notes.add(newNote);
          // debugPrint(newNote.title.toString());
        }
        notifyListeners();
        return notes;
      } else {
        debugPrint('Got error in Response');
        return notes;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return notes;
  }

  // Delete Note:
  Future<void> deleteNote(String id) async {
    try {
      final response = await http.delete(Uri.parse("$_baseUrl/list/$id"));

      if (response.statusCode == 200) {
        debugPrint('Note Deleted');
        notifyListeners();
      } else {
        debugPrint('Noooot Deleted response error');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Update Note:
  Future<void> updateNote(String id, NotesModel note) async {
    try {
      final response =
          await http.patch(Uri.parse("$_baseUrl/list/$id"), body: note.toMap());

      if (response.statusCode == 200) {
        debugPrint('Note updated successfully');
        notifyListeners();
      } else {
        debugPrint('Error updating note');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
