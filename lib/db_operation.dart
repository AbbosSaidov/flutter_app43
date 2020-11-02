import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DbOperation{

  Future<Database> openDb() async{
    final database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'a2123_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) async{
        return db.execute(
          "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, texts TEXT"
              ", time TEXT, iconNumber INTEGER DEFAULT 0, completed BOOLEAN)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    ) ;
    return database;
  }
  Future<void> insertDog(Dog dog,Database da) async {
    // Get a reference to the database.
    final Database db = await da;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Dog>> dogs(Database da) async {
    // Get a reference to the database.
    final Database db = await da;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT texts,id,name,time,completed,iconNumber from dogs  GROUP BY texts');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        texts: maps[i]['texts'],
        time: maps[i]['time'],
        completed: maps[i]['completed'],
        iconNumber: maps[i]['iconNumber'],
      );
    });
  }
  Future<List<Dog>> ItemSelect(Database da,String tes) async {
    // Get a reference to the database.
    final Database db = await da;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT  * FROM dogs WHERE texts=?', [tes]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        texts: maps[i]['texts'],
        time: maps[i]['time'],
        completed: maps[i]['completed'],
        iconNumber: maps[i]['iconNumber'],
      );
    });
  }
  Future<List<Dog>> ItemSelectNot(Database da) async {
    // Get a reference to the database.
    final Database db = await da;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT  * FROM dogs');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        texts: maps[i]['texts'],
        time: maps[i]['time'],
        completed: maps[i]['completed'],
        iconNumber: maps[i]['iconNumber'],
      );
    });
  }

  Future<void> updateDog(Dog dog,Database da) async {
    // Get a reference to the database.
    final db = await da;

    // Update the given Dog.
    await db.update(
      'dogs',
      dog.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(int id,Database da) async {
    // Get a reference to the database.
    final db = await da;

    // Remove the Dog from the database.
    await db.delete(
      'dogs',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
class Dog {
  final int id;
  final String name;
  final String texts;
  final String time;
  final int completed;
  final int iconNumber;

  Dog({this.id, this.name,this.texts, this.time,  this.completed,  this.iconNumber});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'texts': texts,
      'time': time,
      'completed': completed,
      'iconNumber': iconNumber,
    };
  }

  @override
  String toString() {
    return 'Dog{id: $id, name: $name,texts: $texts,time: $time,completed: $completed,iconNumber: $iconNumber}';
  }
}