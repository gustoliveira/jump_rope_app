import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'FinalHomePage.dart';

void main() => runApp(MaterialApp(
      home: DefineTimesPage(),
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _ativo = 1;
  int _descanso = 0;
  int _count = _vetorAtivo[2] * 2;

  bool _flagMudarFases = false;
  bool _flagMudarAtivoDescanso = false;

  ColorSwatch _color = Colors.blue;

  // DESCANSO -> ATIVO -> QNTDVEZES -> DESCANSO -> ATIVO -> QNTDVEZES
  static List<int> _vetorAtivo = [3, 5, 3, 002, 4, 3, 003, 5, 3];
  //                              d  a  q    d  a  q    d  a  q
  //                              0  1  2    3  4  5    6  7  8

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.secondTime.listen((value) {
      if (value >=
          (_flagMudarAtivoDescanso
                  ? _vetorAtivo[_ativo]
                  : _vetorAtivo[_descanso]) +
              1) {
        setState(() {
          _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
          _color = (_flagMudarAtivoDescanso ? Colors.blue : Colors.red);
          _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
          _stopWatchTimer.onExecute.add(StopWatchExecute.start);

          _count--;
          _flagMudarAtivoDescanso = !_flagMudarAtivoDescanso;

          if (_count == 0) _flagMudarFases = true;

          if (_flagMudarFases) {
            int lenght = _vetorAtivo.length - 1;
            if (_descanso + 5 <= lenght) {
              _count = _vetorAtivo[_descanso + 5] * 2;
              _ativo += 3;
              _descanso += 3;
            } else {
              _ativo = 1;
              _descanso = 0;
              _count = _vetorAtivo[2] * 2;
            }
            _flagMudarFases = false;
          }
        });
      }
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _color,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Jump Rope",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: _color,
        child: SafeArea(
          child: Container(
            color: _color,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: StreamBuilder<int>(
                        stream: _stopWatchTimer.secondTime,
                        initialData: _stopWatchTimer.secondTime.value,
                        builder: (context, snap) {
                          final value = snap.data;
                          return Container(
                            child: Text(
                              value.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          padding: const EdgeInsets.all(4),
                          color: Colors.lightBlue,
                          shape: const StadiumBorder(),
                          onPressed: () async {
                            _stopWatchTimer.onExecute
                                .add(StopWatchExecute.start);
                          },
                          child: const Text(
                            'Start',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        RaisedButton(
                          padding: const EdgeInsets.all(4),
                          color: Colors.lightBlue,
                          shape: const StadiumBorder(),
                          onPressed: () async {
                            setState(() {
                              _ativo = 1;
                              _descanso = 0;
                              _count = _vetorAtivo[2] * 2;

                              _flagMudarFases = false;
                              _flagMudarAtivoDescanso = false;
                              _color = Colors.blue;
                            });
                            _stopWatchTimer.onExecute
                                .add(StopWatchExecute.stop);
                            _stopWatchTimer.onExecute
                                .add(StopWatchExecute.reset);
                          },
                          child: const Text(
                            'Reset',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        RaisedButton(
                          padding: const EdgeInsets.all(4),
                          color: Colors.lightBlue,
                          shape: const StadiumBorder(),
                          onPressed: () async {
                            _stopWatchTimer.onExecute
                                .add(StopWatchExecute.stop);
                          },
                          child: const Text(
                            'Stop',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
