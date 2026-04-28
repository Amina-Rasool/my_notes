import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/db_helper.dart';
import '../domain/note_model.dart';

class NoteCubit extends Cubit<List<Note>> {
  final DBHelper dbHelper = DBHelper();
  List<Note> _allNotes = [];

  NoteCubit() : super([]);

  // LOAD NOTES
  Future<void> loadNotes() async {
    try {
      final data = await dbHelper.getNotes();
      _allNotes = data;
      // ✅ Nayi list ki copy bhejna zaroori hai taake UI refresh ho
      emit([..._allNotes]);
    } catch (e) {
      debugPrint("Error loading notes: $e");
    }
  }

  // ADD NOTE
  Future<void> addNote(String title) async {
    if (title.trim().isEmpty) return;
    final note = Note(title: title);
    await dbHelper.insertNote(note);
    await loadNotes(); // Refresh list after adding
  }

  // DELETE NOTE
  Future<void> deleteNote(int id) async {
    await dbHelper.deleteNote(id);
    await loadNotes(); // Refresh list after deleting
  }

  // UPDATE NOTE
  Future<void> updateNote(int id, String title) async {
    if (title.trim().isEmpty) return;
    final updatedNote = Note(id: id, title: title);
    await dbHelper.updateNote(updatedNote);
    await loadNotes(); // Refresh list after updating
  }

  // SEARCH NOTE
  void searchNotes(String query) {
    if (query.isEmpty) {
      emit([..._allNotes]);
    } else {
      final filtered = _allNotes
          .where((note) => note.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(filtered);
    }
  }
}