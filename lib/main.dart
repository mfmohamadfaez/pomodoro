import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Pomodoro Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer _timer;
  var f = NumberFormat('00', 'en_US');
  int _minWorkTime = 1;
  int _secWorkTime = 30;
  String strMinWorkTime = '01';
  String strSecWorkTime = '30';
  int _restTime = 5;
  int _specialRestTime = 15;
  AudioCache audioCache = AudioCache();

  // countdown function for work time
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        // if worktime hits 0, timer stop
        if (_minWorkTime == 0 && _secWorkTime == 0) {
          setState(() {
            timer.cancel();
          });
        }
        // if worktime not 0, reduce the time
        else {
          if (_secWorkTime == 0) {
            setState(() {
              _minWorkTime--;
              strMinWorkTime = f.format(_minWorkTime);
              _secWorkTime = 59;
              strSecWorkTime = f.format(_secWorkTime);
              // SystemSound.play(SystemSoundType.click);
              // audioCache.play('clock-ticking-2.mp3');
            });
          } else {
            setState(() {
              _secWorkTime--;
              strSecWorkTime = f.format(_secWorkTime);
            });
          }
        }
      },
    );
  }

  void stopTimer(){
    _timer.cancel();
  }

  // Future<AudioPlayer> playLocalAsset() async {
  //   AudioCache cache = new AudioCache();
  //   //At the next line, DO NOT pass the entire reference such as assets/yes.mp3. This will not work.
  //   //Just pass the file name only.
  //   return await cache.play("clock-ticking-1.mp3");
  // }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Work time left:',
            ),
            Text(
              '$strMinWorkTime:$strSecWorkTime',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton:
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: startTimer,
            tooltip: 'Start',
            child: Icon(Icons.play_arrow),
          ),
          Padding(padding: EdgeInsets.all(5)),
          FloatingActionButton(
            onPressed: stopTimer,
            tooltip: 'Stop',
            child: Icon(Icons.stop),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
