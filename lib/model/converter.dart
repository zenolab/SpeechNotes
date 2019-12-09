import 'package:speech_notes/model/speech.dart';

import '../util.dart';
import 'note_model.dart';

Note converterToNote(Speech speech) {
  return Note.entry(capitalizeFirstLetter(speech.entry));
}