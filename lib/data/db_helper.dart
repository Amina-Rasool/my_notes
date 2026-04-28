import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../domain/note_model.dart';

class DBHelper {
  static Database? _db;

  // Database getter
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  // Database Initialize
  Future<Database> initDB() async {
    // Sahi path dhoondna zaroori hai
    String path = join(await getDatabasesPath(), 'notes_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Table create karte waqt await lazmi hai
        await db.execute(
          "CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT)",
        );
      },
    );
  }

  // INSERT NOTE
  Future<int> insertNote(Note note) async {
    final db = await database;
    // note.toMap() use karein aur conflict algorithm set karein
    return await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // GET ALL NOTES
  Future<List<Note>> getNotes() async {
    final db = await database;
    // Database se query karein aur results ko Map ki list mein lein
    final List<Map<String, dynamic>> maps = await db.query('notes', orderBy: "id DESC");

    // Maps ko wapas Note objects mein convert karein
    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  // UPDATE NOTE
  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // DELETE NOTE
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}