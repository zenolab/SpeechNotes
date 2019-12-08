import 'dart:async';

import 'package:speech_notes/db/speech_db.dart';
import 'package:speech_notes/model/client_model.dart';



/* Bloc это ViewModel,
 а StreamController это LiveData  */
 /// Основная идея заключается в том, что наше приложение разбито на модули, реализующие бизнес-логику.
 /// Каждый модуль имеет одну или несколько Sink (труб),
 /// которые являются некоторым входным потоком для агрегирования событий извне.
 /// В качестве выходных данных выступает Stream (поток),
 /// который определяет асинхронный формат данных для наших виджетов.
 /// Чтобы воспользоваться модулем на уровне виджета, применяют StreamBuilder,
 /// который управляет потоком данных и автоматически решает проблемы подписки и перерисовки дочернего дерева виджетов.

class NotesBloc {

  /*
  StreamController.broadcast, для того чтобы слушать широковещательные события более одного раза.
  В нашем примере это не имеет особо значения, поскольку мы слушаем их только один раз,
   но неплохо было бы реализовать это на будущее.
   */
  final _clientController = StreamController<List<Note>>.broadcast();
 // final _clientController = StreamController<Client>.broadcast();

  //getter
  get clients => _clientController.stream;

  /*
  Закрыть потоки.
   Таким образом мы предотвратим мемори лики.
   В нашем примере мы закрываем их используя dispose method в StatefulWidget
   */
  dispose() {
    _clientController.close();
  }


  /*
  getClients получает данные из БД (Client table) асинхронно.
  Мы будем использовать этот метод всегда, когда нам будет необходимо обновить таблицу,
  следовательно стоит поместить его в тело конструктора.
   */
  getClients() async {
    //Sink - труба
    // Sink -  add whatever data we want into the Sink
    // Для добавление чего-то в поток StreamController выставляет "вход" называемый StreamSink,
    // он доступен через свойство sink
    _clientController.sink.add(await DBProvider.db.getAllClients()); // add whatever data we want into the Sink
  }

  NotesBloc() {
    getClients();
  }

//  blockUnblock(Note client) {
//    DBProvider.db.blockOrUnblock(client);
//    getClients();
//  }

  delete(int id) {
    DBProvider.db.deleteClient(id);
    getClients();
  }

  add(Note client) {
    print(" --Bloc new Client name ${client.txt} ");
    DBProvider.db.newClient(client);
    getClients();

  }

}