

import 'package:flutter/material.dart';
import 'package:notes_taking_app/model/notes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'notes.db');
    var db = await openDatabase(path, version: 1, onCreate: _oncreate);
    return db;
  }

  _oncreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, subject TEXT NOT NULL, note TEXT NOT NULL)');
  }

  Future<NotesModel> insert(NotesModel notesModel) async {
    var dbClient = await db;
    await dbClient?.insert('notes', notesModel.toMap());
    return notesModel;
  }

  Future<List<NotesModel>> getDataList() async {
    await db;
    final List<Map<String, Object?>> QueryResult =
        await _db!.rawQuery('SELECT * FROM notes');
    return QueryResult.map((e) => NotesModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('notes', where: 'id=?', whereArgs: [id]);
  }

  Future<int> update(NotesModel notesModel) async {
    var dbClient = await db;
    return await dbClient!
        .update('notes', notesModel.toMap(), where: 'id= ?', whereArgs: [notesModel.id]);
  }
}
