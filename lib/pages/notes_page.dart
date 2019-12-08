import 'package:flutter/material.dart';
import 'package:speech_notes/model/speech.dart';
import 'package:speech_notes/util.dart';

import '../block/notess_block.dart';
import 'details_page.dart';
import '../model/note_model.dart';

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(title: 'Note List', home:  NoteList());
  }
}

class NoteList extends StatefulWidget {
  @override
  createState() =>  NoteListState();
}

class NoteListState extends State<NoteList> {
  Stream<int> myStream;
  var _bloc;

  @override
  void initState() {
    _bloc = NotesBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Scaffold scaffold =  Scaffold(
      appBar:  AppBar(title:  Text('Note List')),
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
                    _promptRemoveNoteItem(item);
                  },
                  child: ListTile(
                    title: Text(item.txt),
                    leading: Text(item.id.toString()),
                    trailing: Icon(
                      Icons.swap_horiz,
                      color: Colors.green,
                      size: 30.0,
                    ),
                  ),
                );
              },
            );

          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton:  FloatingActionButton(
        tooltip: 'Add note',
        child: Icon(Icons.add),
        onPressed: () {
          _pushAddNoteDetailsScreen();
        },
      ),
    );
    return scaffold;
  }

  void _pushAddNoteDetailsScreen() {
       navigateToSubPage(context);
  }


  Future navigateToSubPage(context) async {
    Speech speechResult = Speech();
    speechResult =
        await Navigator.push(context, MaterialPageRoute(builder: (context) => Details()));
    _addNoteItem(speechResult);

  }

  void _addNoteItem(Speech speech) async {
    if (speech != null) {
      Note note = Note();
      note = converterToNote(speech);
      _bloc.add(note);
    }
  }

  void _removeNoteItem(Note item) {
    setState(() =>  _bloc.delete(item.id));
  }

  void _promptRemoveNoteItem(Note item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return  AlertDialog(title:  Text(' "${item.txt}" '), actions: <Widget>[
            FlatButton(
                child:  Text('Cancel'),
                // The alert is actually part of the navigation stack,
                // so to close it, need to pop it.
               onPressed: () => setState(() =>  Navigator.of(context).pop() )
            ),
             FlatButton(
                child:  Text('Remove?'),
                onPressed: () {
                  _removeNoteItem(item);
                  Navigator.of(context).pop();
                })
          ]);
        });
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

}

Note converterToNote(Speech speech) {
  return Note.entry(capitalizeFirstLetter(speech.entry));
}