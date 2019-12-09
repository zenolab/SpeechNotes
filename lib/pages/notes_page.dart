import 'package:flutter/material.dart';
import 'package:speech_notes/model/converter.dart';
import 'package:speech_notes/model/speech.dart';
import 'package:speech_notes/util.dart';

import '../block/notess_block.dart';
import 'details_page.dart';
import '../model/note_model.dart';

///Not work update ui page after back from Details Screen
///Try with Inherited widget such as  -  final bloc = MyBloc.of(context);
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
  var _bloc = NotesBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("--NoteApp build");
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
    WillPopScope willPopScope = WillPopScope(child: scaffold,onWillPop:_handleBack);

    return willPopScope;
  }

  Future<bool> _handleBack() {
    _bloc.getNotes();//work
    return Future<bool>.value(false);
  }

  void _pushAddNoteDetailsScreen() {
    navigateToSubPage(context);
  }

  Future navigateToSubPage(context) async {
    print("----NoteApp hash code ${_bloc.hashCode}");
     Navigator.push(context, MaterialPageRoute(builder: (_) => Details(_bloc)));
     Future.delayed(Duration(seconds: 1));
  }

//  void navigateToSubPage2(BuildContext context) {
//    print("----NoteApp hash code ${_bloc.hashCode}");
//    Navigator.push(context, MaterialPageRoute(builder: (_) => Details(_bloc)));
//    Future.delayed(Duration(seconds: 1));
//    print("--NoteApp recieve data in first screen");
//    _addNoteItem(speechResult);
//  }

  void _addNoteItem(Speech speech) async {
    print("--NoteApp _addNoteItem");
    if (speech != null) {
      Note note = Note();
      note = converterToNote(speech);
      _bloc.add(note);
      setState(() {
        print("--NoteApp refresh");
      });
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

