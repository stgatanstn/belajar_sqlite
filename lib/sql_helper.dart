import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static Future<Database> db() async {
    return openDatabase(
      join(await getDatabasesPath(), 'kindacode.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        await database.execute("""
          CREATE TABLE items(
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            title TEXT,
            description TEXT,
            Rating TEXT,
            image TEXT,
            createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
          )
        """);
      },
    );
  }

  // Membaca semua data
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  // Membaca satu data berdasarkan id
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Membuat data baru
  static Future<int> createItem(
      String title, String description, String Rating, String imagePath) async {
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'description': description,
      'Rating': Rating,
      'image': imagePath // Menyimpan path gambar
    };
    return await db.insert('items', data);
  }

  // Memperbarui data
  static Future<int> updateItem(int id, String title, String description,
      String Rating, String imagePath) async {
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'description': description,
      'Rating': Rating,
      'image': imagePath
    };
    return await db.update('items', data, where: "id = ?", whereArgs: [id]);
  }

  // Menghapus data
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    await db.delete('items', where: "id = ?", whereArgs: [id]);
  }
}
