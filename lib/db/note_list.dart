

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_notes/block/notess_block.dart';

import 'package:speech_notes/model/client_model.dart';


class NoteList extends StatefulWidget {

  var userName;
  var userPhone;
  bool blocked;

  Note _client;

  NoteList.undefined();

  NoteList.userData(String userName,String userContact) : this.userName = userName, this.userPhone = userContact {
    _client =  Note(txt: this.userName,);
  }

  @override
  _NoteListState createState() => _NoteListState(_client);

}

class _NoteListState extends State<NoteList> {

  final  bloc = NotesBloc();

  _NoteListState(Note client) {
    print(" -- OurClientsApp new Client name ${client.id} ");
    print(" -- OurClientsApp new Client phone ${client.txt} ");
    bloc.add(client);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

//    setState(() {
//      bloc.getClients();
//    });

    return Scaffold(
      appBar: AppBar(title: Text("Flutter SQLite")),
      body: StreamBuilder<List<Note>>(
        stream: bloc.clients,
        builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
          if (snapshot.hasData) {

            //recursion
//            setState(() {
//              bloc.getClients();
//            });

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Note item = snapshot.data[index];

                //recursion
//                setState(() {
//                  bloc.getClients();
//                });

                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    bloc.delete(item.id);
                  },
                  child: ListTile(
                    title: Text(item.txt),
                    leading: Text(item.id.toString()),
                    subtitle:Text(item.txt),
                    trailing: Checkbox(
                      onChanged: (bool value) {
                       // bloc.blockUnblock(item);
                        print('--NoteList  test remove this');
                      },
                     // value: item.blocked,
                    ),
                  ),
                );
              },
            );
          } else {
            //not work
//            setState(() {
//              bloc.getClients();
//            });
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.update),
        onPressed: () async {
         // Client rnd = testClients[math.Random().nextInt(testClients.length)];

          setState(() {
            bloc.getClients();
          });
        },
      ),
    );
  }

}
