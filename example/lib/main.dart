import 'package:flutter/material.dart';

import 'package:flutter_survicate/flutter_survicate.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  SurvicateEvent _lastEvent;

  @override
  void initState() {
    super.initState();
    FlutterSurvicate.init("YOUR_WORKPLACE_KEY", true);
    FlutterSurvicate.onEvent.listen((event) => setState(() { _lastEvent = event; }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Survicate'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('last event: $_lastEvent'),
            FlatButton(
              child: Text('EntryScreen'),
              onPressed: () => FlutterSurvicate.enterScreen('main'),
            ),
            FlatButton(
              child: Text('LeaveScreen'),
              onPressed: () => FlutterSurvicate.leaveScreen('main'),
            ),
            FlatButton(
              child: Text('InvokeEvent'),
              onPressed: () => FlutterSurvicate.invokeEvent('survey_show'),
            ),
            FlatButton(
              child: Text('Reset'),
              onPressed: () => FlutterSurvicate.reset(),
            )
          ],
        ),
      ),
    );
  }
}

