import 'dart:async';
import 'dart:io';



import 'package:speech_notes/model/client_model.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';


class DBProvider {
  ///private named constructor - accessible only from its class (and library).
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database =await initDB();
    return _database;
  }

  initDB() async {
    /**
     * class Directory - a reference to a directory (or _folder_) on the file system.
     *
     * A Directory instance is an object holding a [path] on which operations can
     * be performed. The path to the directory can be [absolute] or relative.
     * You can get the parent directory using the getter [parent],
     * a property inherited from [FileSystemEntity].
     */
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path,  "SpeechDB.db");
    return await openDatabase(path,version: 1,onOpen: (db) {},
        onCreate: (Database db,int version) async {

          await db.execute("CREATE TABLE Client ("
              "id INTEGER PRIMARY KEY,"
              "txt TEXT,"
//              "last_name TEXT,"
//              "blocked BIT"
              ")");
        });

  }

  newClient(Note newClient) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Note");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
      //  "INSERT Into Client (id,first_name,last_name,blocked)"
        "INSERT Into Note (id,txt)"
           // " VALUES (?,?,?,?)",
            " VALUES (?,?)",
       // [id, newClient.firstName, newClient.phoneNumber, newClient.blocked]);
        [id, newClient.txt,]);
    return raw;
  }


//  //блокировка пользователя
//  blockOrUnblock(Note note) async {
//    final db = await database;
//    Note blocked = Note(
//        id: note.id,
//        txt: note.txt,
//       // phoneNumber: client.phoneNumber,
//       // blocked: !client.blocked);
//    var res = await db.update("Note", blocked.toMap(),
//        where: "id = ?", whereArgs: [note.id]);
//    return res;
//  }

  updateClient(Note newNote) async {
    final db = await database;
    var res = await db.update("Note", newNote.toMap(),
        where: "id = ?", whereArgs: [newNote.id]);
    return res;
  }

  getClient(int id) async {
    final db = await database;
    var res = await db.query("Note", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Note.fromMap(res.first) : null;
  }


  Future<List<Note>> getAllClients() async {
    print("--getAllClients");
    final db = await database;
    var res = await db.query("Note");
    List<Note> list =
    res.isNotEmpty ? res.map((c) => Note.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Note>> getBlockedClients() async {
    final db = await database;

    print("--getBlockedClients");
    // var res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
    var res = await db.query("Note", where: "blocked = ? ", whereArgs: [1]);

    List<Note> list =
    res.isNotEmpty ? res.map((c) => Note.fromMap(c)).toList() : [];
    return list;
  }

  deleteClient(int id) async {
    final db = await database;
    return db.delete("Note", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Clinet");
  }



}