import 'dart:convert';

Note clientFromJson(String str) {
  final jsonData =  json.decode(str);
  return Note.fromMap(jsonData);
}

String clientToJson(Note data) {
  return json.encode(data.toMap());
}

class Note {
  int id;
  String txt;
 // String phoneNumber;
 // bool blocked;//Блокировка/разблокировка клиента

//Extra / additionally fields
//  String lastName1;
//  String email;
//  String password;
//  int age;
//  String imagePath;

 // Note({this.id,this.firstName,this.phoneNumber,this.blocked});
  Note({this.id,this.txt});
  Note.entry(this.txt);

  // Dart предоставляет фабричные конструкторы для поддержки фабричного шаблона.
  // Конструктор фабрики может возвращать значения (объекты).
  factory Note.fromMap(Map<String, dynamic> json) => new Note(
    id: json["id"],
    txt: json["txt"],
   // phoneNumber: json["last_name"],//replace on phone_number
   // blocked: json["blocked"] == 1,
  );

  Map<String ,dynamic> toMap() => {
    "id": id,
    "txt": txt,

   // "last_name": phoneNumber,
   // "blocked" : blocked,
  };

}