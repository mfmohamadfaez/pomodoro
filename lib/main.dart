import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:path_drawing/path_drawing.dart';
import 'package:pomodoro/CountDownTimer.dart';

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
      // home: CountDownTimer(),
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
  bool toggleStart = true;

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
            toggleStart = true;
          });
        }
        // if worktime not 0, reduce the time
        else {
          toggleStart = false;
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
        print('$_minWorkTime:$_secWorkTime');
      },
    );
  }

  // pause the timer
  void stopTimer() {
    setState(() {
      _timer.cancel();
      toggleStart = true;
    });
  }

  //reset the timer
  void resetTimer() {
    setState(() {
      _minWorkTime = 1;
      _secWorkTime = 30;
      strMinWorkTime = '01';
      strSecWorkTime = '30';
    });
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Work time left:',
            ),
            Text(
              '$strMinWorkTime:$strSecWorkTime',
              style: Theme.of(context).textTheme.headline4,
            ),
            /*Container(
              width: 400,
              height: 400,
              child: CustomPaint(
                painter: CirclePainter(),
                child: Center(
                  // child: Text('Blade Runner'),
                ),
              ),
            )*/
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: toggleStart ? startTimer : stopTimer,
            tooltip: toggleStart ? 'Start' : 'Pause',
            child: toggleStart ? Icon(Icons.play_arrow) : Icon(Icons.pause),
          ),
          Padding(padding: EdgeInsets.all(5)),
          FloatingActionButton(
            onPressed: resetTimer,
            tooltip: 'Reset',
            child: Icon(Icons.stop),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

/*class OpenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color(0xffaa44aa)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    var path1 = Path()
      ..moveTo(10, 10)
      ..arcToPoint(Offset(size.width - 10, size.height - 10),
          radius: Radius.circular(math.max(size.width, size.height)));

    // canvas.drawCircle(Offset(200, 200), 100, paint1);
    canvas.drawPath(path1, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}*/

class CirclePainter extends CustomPainter {
  Paint _paint = Paint()
    ..color = Colors.red
    ..strokeWidth = 4.0
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 3));

    Path dashPath = Path();

    double dashWidth = 5.0;
    double dashSpace = 100 / 90;
    double distance = 20.0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.moveTo(0, 0);
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth;
        distance += dashSpace;
      }
    }
    canvas.drawPath(dashPath, _paint);
    // canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return true;
  }
}

class CurvedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.lightBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    var startPoint = Offset(0, size.height / 2);
    var controlPoint1 = Offset(size.width / 4, size.height / 3);
    var controlPoint2 = Offset(3 * size.width / 4, size.height / 3);
    var endPoint = Offset(size.width, size.height / 2);

    var path = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 3));
    // path.moveTo(startPoint.dx, startPoint.dy);
    // path.cubicTo(controlPoint1.dx, controlPoint1.dy,
    //     controlPoint2.dx, controlPoint2.dy,
    //     endPoint.dx, endPoint.dy);

    canvas.drawPath(
        dashPath(path, dashArray: CircularIntervalList([15, 10])), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
