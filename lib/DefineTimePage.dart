import 'package:flutter/material.dart';
import 'StopwatchPage.dart';

class DefineTimePage extends StatefulWidget {
  final Color color;

  DefineTimePage({this.color});

  @override
  DefineTimePageState createState() => DefineTimePageState();
}

class DefineTimePageState extends State<DefineTimePage> {
  TextEditingController controladorAtivo = TextEditingController();
  TextEditingController controladorDescanso = TextEditingController();
  TextEditingController controladorQntdSeries = TextEditingController();
  TextEditingController controladorQntdRepeticao = TextEditingController();

  bool flagContinuar = true;
  bool flagStart = true;
  bool flagTempos = true;

  int qntdConfiguracoes = 0;

  List<Map<String, dynamic>> listaTempos = [];

  void addSerie() {
    listaTempos.add({
      "tempoDescanso": int.parse(controladorDescanso.text),
      "tempoAtivo": int.parse(controladorAtivo.text),
      "controladorQntdRepeticao": int.parse(controladorQntdRepeticao.text),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        color: Colors.blue,
        child: SafeArea(
          child: Container(
            child: Center(
              child: flagContinuar
                  ? ButtonTheme(
                      minWidth: 250.0,
                      height: 100.0,
                      shape: const StadiumBorder(),
                      child: RaisedButton(
                        color: Colors.green[700],
                        child: Text(
                          "Começar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            flagContinuar = false;
                          });
                        },
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              flagTempos
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: controladorQntdSeries,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          labelText: "Quantas séries",
                                          labelStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "$qntdConfiguracoes SÉRIES",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                              (flagTempos || !flagStart)
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: controladorDescanso,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          labelText: "Quanto tempo de descanso",
                                          labelStyle: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                              (flagTempos || !flagStart)
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: controladorAtivo,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          labelText: "Quanto tempo ativo",
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                        ),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                              (flagTempos || !flagStart)
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: controladorQntdRepeticao,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          labelText: "Quantas repetições",
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                        ),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RaisedButton(
                                  padding: const EdgeInsets.all(4),
                                  color: Colors.lightBlue,
                                  shape: const StadiumBorder(),
                                  child: const Text(
                                    'Voltar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      flagContinuar = true;
                                      flagTempos = true;
                                      controladorQntdSeries.text = "";
                                      controladorDescanso.text = "";
                                      controladorAtivo.text = "";
                                      controladorQntdRepeticao.text = "";
                                    });
                                  },
                                ),
                                flagStart
                                    ? Container()
                                    : ButtonTheme(
                                        minWidth: 125,
                                        height: 50,
                                        shape: const StadiumBorder(),
                                        child: RaisedButton(
                                          color: Colors.green[700],
                                          child: Text(
                                            "Começar",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              controladorDescanso.text = "";
                                              controladorAtivo.text = "";
                                              controladorQntdRepeticao.text =
                                                  "";

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      StopwatchPage(
                                                    vetorAtivo: listaTempos,
                                                  ),
                                                ),
                                              );
                                            });
                                          },
                                        ),
                                      ),
                                RaisedButton(
                                  padding: const EdgeInsets.all(4),
                                  color: Colors.lightBlue,
                                  shape: const StadiumBorder(),
                                  child: Text(
                                    flagTempos ? "Iniciar" : "Adicionar",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (controladorQntdSeries.text != "") {
                                        qntdConfiguracoes = int.parse(
                                            controladorQntdSeries.text);
                                        flagTempos = false;
                                      }

                                      if (controladorDescanso.text != "" &&
                                          controladorAtivo.text != "" &&
                                          controladorQntdRepeticao.text != "") {
                                        addSerie();

                                        if (qntdConfiguracoes ==
                                            listaTempos.length) {
                                          flagStart = false;
                                        }

                                        controladorDescanso.text = "";
                                        controladorAtivo.text = "";
                                        controladorQntdRepeticao.text = "";
                                      }
                                    });
                                  },
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
      ),
    );
  }
}
