import 'dart:async';
import 'package:speech_notes/db/speech_db.dart';
import 'package:speech_notes/model/note_model.dart';

class NotesBloc {
  final _clientController = StreamController<List<Note>>.broadcast();

  get notes => _clientController.stream;

  getNotes() async {
    _clientController.sink.add(await DBProvider.db.getAllNotes());
  }

  NotesBloc() {
    getNotes();
  }

  delete(int id) {
    DBProvider.db.deleteNote(id);
    getNotes();
  }

  add(Note note) {
    DBProvider.db.newNote(note);
    getNotes();
  }

  dispose() {
    _clientController.close();
  }
}
