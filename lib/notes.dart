import 'package:flutter/material.dart';
import 'package:speech_notes/podo/note.dart';
import 'package:speech_notes/util.dart';

import 'details.dart';

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

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Scaffold scaffold = new Scaffold(
      appBar: new AppBar(title: new Text('Note List')),
      body: _buildNoteList(),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Add task',
        child: new Icon(Icons.add),
        onPressed: () {
          print("--Pressed button mic");
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
    Note speechContainer = Note();
    speechContainer =
        await Navigator.push(context, MaterialPageRoute(builder: (context) => Details()));
    _addNoteItem(speechContainer);
  }

  void _addNoteItem(Note note) {
    if (note != null) {
      setState(() => _noteItems.add(capitalizeFirstLetter(note.entry)));
    }
  }

  void _removeNoteItem(int index) {
    setState(() => _noteItems.removeAt(index));
  }

  void _promptRemoveNoteItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(title: new Text(' "${_noteItems[index]}" '), actions: <Widget>[
            new FlatButton(
                child: new Text('Cancel'),
                // The alert is actually part of the navigation stack, so to close it, we
                // need to pop it.
                onPressed: () => Navigator.of(context).pop()),
            new FlatButton(
                child: new Text('Remove?'),
                onPressed: () {
                  _removeNoteItem(index);
                  Navigator.of(context).pop();
                })
          ]);
        });
  }

  Widget _buildNoteList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        if (index < _noteItems.length) {
          return _buildNoteItem(_noteItems[index], index);
        }
      },
    );
  }

  Widget _buildNoteItem(String noteText, int index) {
    return new ListTile(title: new Text(noteText), onTap: () => _promptRemoveNoteItem(index));
  }
}
