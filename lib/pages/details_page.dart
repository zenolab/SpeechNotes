import 'package:flutter/material.dart';
import 'package:speech_notes/model/speech.dart';
import 'package:speech_recognition/speech_recognition.dart';

import '../common.dart';

class Details extends StatefulWidget {

  @override
  _VoiceSampleState createState() => _VoiceSampleState();
}

class _VoiceSampleState extends State<Details> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String _resultText = "";

  Speech _speechContainer =  Speech();
  var _txtEntryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  @override
  Widget build(BuildContext context) {
    _txtEntryController.text = _resultText;
    _speechContainer.entry = _txtEntryController.text;

    Scaffold scaffold = Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  child: Icon(Icons.mic),
                  onPressed: () {
                    activateSpeech();
                  },
                  backgroundColor: Colors.lightGreen,
                ),
              ],
            ),
            Container(
                padding: EdgeInsets.all(10.0),
                child:  Form(
                    child:  Column(
                  children: <Widget>[
                     Text(
                      'Note Description:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                     TextFormField(
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Please describe a note';
                        else
                          return null;
                      },
                      controller: _txtEntryController,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (txtEntryController) {
                        _speechContainer.entry = this._txtEntryController.text;
                        Navigator.pop(context, _speechContainer);
                      },
                      focusNode: FocusNode(),
                    ),
                     SizedBox(height: 5.0),
                     RaisedButton(
                      onPressed: () {
                        _speechContainer.entry = _txtEntryController.text;
                        Navigator.pop(context, _speechContainer);
                      },
                      child: Text('Done'),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                  ],
                ))),
          ],
        ),
      ),
    );

    _speechContainer.entry = _txtEntryController.text;
    return scaffold;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _txtEntryController.dispose();
    super.dispose();
  }

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState(() => _isAvailable = result),
    );

    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(() => _resultText = speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() => _isListening = false),
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
        );
  }

  void activateSpeech() {
    if (_isAvailable && !_isListening) {
      _speechRecognition.listen(locale: eng).then((result) => print('$result'));
    }
  }
}
