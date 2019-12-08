import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:speech_notes/podo/speech.dart';
import 'package:speech_notes/util.dart';

import '../block/notess_block.dart';
import 'details.dart';
import '../model/client_model.dart';

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: 'Note List', home: new NoteList());
  }
}

class NoteList extends StatefulWidget {
  @override
  createState() => new NoteListState();
}

class NoteListState extends State<NoteList> {
  List<String> _noteItems = [];

  final bloc = NotesBloc();

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    Scaffold scaffold = new Scaffold(
      appBar: new AppBar(title: new Text('Note List')),
      body:

     // _buildNoteList(), //First

      //..................Second.......................................
      StreamBuilder<List<Note>>(
        stream: bloc.notes,
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
                    bloc.delete(item.id);
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
      //.........................................................
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Add task',
        child: new Icon(Icons.add),
        onPressed: () {
          print("--Pressed button mic");
          _pushAddNoteDetailsScreen();

        //  bloc.add(rnd);
        },
      ),
    );
    return scaffold;
  }

  void _pushAddNoteDetailsScreen() {
    navigateToSubPage(context);
  }

  Future navigateToSubPage(context) async {
    Speech speechContainer = Speech();
    speechContainer =
        await Navigator.push(context, MaterialPageRoute(builder: (context) => Details()));
    _addNoteItem(speechContainer);
  }

  void _addNoteItem(Speech speech) {
    if (speech != null) {
      setState(() => _noteItems.add(capitalizeFirstLetter(speech.entry)));
      Note note = Note();
      note.txt = capitalizeFirstLetter(speech.entry);
      bloc.add(note);
    }
  }

  void _removeNoteItem(int index) {
    setState(() => _noteItems.removeAt(index));
  }

//  void _promptRemoveNoteItem(int index) {
//    showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return new AlertDialog(title: new Text(' "${_noteItems[index]}" '), actions: <Widget>[
//            new FlatButton(
//                child: new Text('Cancel'),
//                // The alert is actually part of the navigation stack, so to close it, we
//                // need to pop it.
//                onPressed: () => Navigator.of(context).pop()),
//            new FlatButton(
//                child: new Text('Remove?'),
//                onPressed: () {
//                  _removeNoteItem(index);
//                  Navigator.of(context).pop();
//                })
//          ]);
//        });
//  }


//  Widget _buildNoteItem(String noteText, int index) {
//    return new ListTile(title: new Text(noteText), onTap: () => _promptRemoveNoteItem(index));
//  }


  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
