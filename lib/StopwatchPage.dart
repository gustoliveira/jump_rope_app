import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

import 'package:stop_watch_timer/stop_watch_timer.dart';

class StopwatchPage extends StatefulWidget {
  List<Map<String, dynamic>> vetorAtivo;

  StopwatchPage({this.vetorAtivo});

  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  int _ativo = 0;
  int _descanso = 0;
  int _count = 0;
  int _serieAtual = 0;
  int _countSeries = 0;
  int _countQntd = 0;

  bool _flagMudarFases = false;
  bool _flagMudarAtivoDescanso = false;
  bool _isPaused = false;
  bool _isOver = false;

  ColorSwatch _color = Colors.blue;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.secondTime.listen((value) {
      if (value >= (_flagMudarAtivoDescanso ? _ativo : _descanso) + 1) {
        setState(() {
          Wakelock.enable();

          _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
          _color = (_flagMudarAtivoDescanso ? Colors.blue : Colors.red);
          _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
          _stopWatchTimer.onExecute.add(StopWatchExecute.start);

          if (_flagMudarAtivoDescanso) _countQntd++;

          _count--;
          _flagMudarAtivoDescanso = !_flagMudarAtivoDescanso;

          if (_count == 0) _flagMudarFases = true;

          if (_flagMudarFases) {
            int lenght = widget.vetorAtivo.length;
            if (_serieAtual == lenght - 1) {
              _isOver = true;
              Wakelock.disable();
              _color = Colors.green;
              _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
            } else {
              _serieAtual++;
            }

            _ativo = widget.vetorAtivo[_serieAtual]["tempoAtivo"];
            _descanso = widget.vetorAtivo[_serieAtual]["tempoDescanso"];
            _count =
                widget.vetorAtivo[_serieAtual]["controladorQntdRepeticao"] * 2;

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Text(
                          "$_countQntd/$_countSeries",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                                fontSize: 90,
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
                        ButtonTheme(
                          minWidth: 100,
                          height: 60,
                          shape: const StadiumBorder(),
                          child: RaisedButton(
                            padding: const EdgeInsets.all(4),
                            color: Colors.green,
                            shape: const StadiumBorder(),
                            child: Text(
                              _isPaused ? "Retomar" : "Começar",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (!_isOver) {
                                _stopWatchTimer.onExecute
                                    .add(StopWatchExecute.start);
                                _ativo = widget.vetorAtivo[_serieAtual]
                                    ["tempoAtivo"];
                                _descanso = widget.vetorAtivo[_serieAtual]
                                    ["tempoDescanso"];
                                _count = widget.vetorAtivo[_serieAtual]
                                        ["controladorQntdRepeticao"] *
                                    2;

                                for (int i = 0;
                                    i < widget.vetorAtivo.length;
                                    i++) {
                                  _countSeries += widget.vetorAtivo[i]
                                      ["controladorQntdRepeticao"];
                                }
                                setState(() {
                                  _isPaused = false;
                                });
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        RaisedButton(
                          padding: const EdgeInsets.all(4),
                          color: Colors.lightBlue,
                          shape: const StadiumBorder(),
                          onPressed: () async {
                            setState(() {
                              _ativo =
                                  widget.vetorAtivo[_serieAtual]["tempoAtivo"];
                              _descanso = widget.vetorAtivo[_serieAtual]
                                  ["tempoDescanso"];
                              _count = widget.vetorAtivo[_serieAtual]
                                      ["controladorQntdRepeticao"] *
                                  2;

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
                        ButtonTheme(
                          minWidth: 100,
                          height: 60,
                          shape: const StadiumBorder(),
                          child: RaisedButton(
                            padding: const EdgeInsets.all(4),
                            color: Colors.deepPurpleAccent,
                            shape: const StadiumBorder(),
                            onPressed: () async {
                              if (!_isOver) {
                                _stopWatchTimer.onExecute
                                    .add(StopWatchExecute.stop);
                                setState(() {
                                  _isPaused = true;
                                  // Wakelock.disable();
                                });
                              } else {
                                return null;
                              }
                            },
                            child: const Text(
                              "Pausar",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
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
