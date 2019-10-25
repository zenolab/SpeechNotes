import 'package:flutter/material.dart';
import 'package:speech_notes/podo/note.dart';
import 'package:speech_recognition/speech_recognition.dart';

import 'common.dart';

class Details extends StatefulWidget {
  @override
  _VoiceSampleState createState() => _VoiceSampleState();
}

class _VoiceSampleState extends State<Details> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";

  Note speechContainer =  Note();
  var txtEntryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  @override
  Widget build(BuildContext context) {
    txtEntryController.text = resultText;
    speechContainer.entry = txtEntryController.text;

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
                child: new Form(
                    child: new Column(
                  children: <Widget>[
                    new Text(
                      'Note Description:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    new TextFormField(
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Please describe a note';
                        else
                          return null;
                      },
                      controller: txtEntryController,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (txtEntryController) {
                        speechContainer.entry = this.txtEntryController.text;
                        Navigator.pop(context, speechContainer);
                      },
                      focusNode: FocusNode(),
                    ),
                    new SizedBox(height: 5.0),
                    new RaisedButton(
                      onPressed: () {
                        speechContainer.entry = txtEntryController.text;
                        Navigator.pop(context, speechContainer);
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

    speechContainer.entry = txtEntryController.text;
    return scaffold;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    txtEntryController.dispose();
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
      (String speech) => setState(() => resultText = speech),
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
      _speechRecognition.listen(locale: rus).then((result) => print('$result'));
    }
  }
}
