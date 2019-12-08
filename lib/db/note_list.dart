import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_notes/block/notess_block.dart';
import 'package:speech_notes/model/note_model.dart';

class NoteList extends StatefulWidget {
  final _entry;
  final Note _note ;

  NoteList.userData(String data, Note note) : this._entry = data, this._note = note;

  @override
  _NoteListState createState() => _NoteListState(_note);

}

class _NoteListState extends State<NoteList> {
  final _bloc = NotesBloc();

  _NoteListState(Note note) {
    _bloc.add(note);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter SQLite")),
      body: StreamBuilder<List<Note>>(
        stream: _bloc.notes,
        builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Note item = snapshot.data[index];

                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    _bloc.delete(item.id);
                  },
                  child: ListTile(
                    title: Text(item.txt),
                    leading: Text(item.id.toString()),
                    subtitle: Text(item.txt),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.update),
        onPressed: () async {
          setState(() {
            _bloc.getNotes();
          });
        },
      ),
    );
  }
}
