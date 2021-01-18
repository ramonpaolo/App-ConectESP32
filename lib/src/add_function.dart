import 'dart:convert';
import 'dart:io';

import 'package:automatization/src/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class AddFunctions extends StatefulWidget {
  @override
  _AddFunctionsState createState() => _AddFunctionsState();
}

class _AddFunctionsState extends State<AddFunctions> {
  TextEditingController _controllerUrl = TextEditingController(text: "http://");
  TextEditingController _controllerEndpoint1 = TextEditingController(text: "");
  TextEditingController _controllerEndpoint2 = TextEditingController(text: "");
  TextEditingController _controllerValue1 = TextEditingController(text: "");
  TextEditingController _controllerValue2 = TextEditingController(text: "");
  TextEditingController _controllerName = TextEditingController(text: "");

  var _snack = GlobalKey<ScaffoldState>();

  snackBar(String text) {
    _snack.currentState.showSnackBar(SnackBar(
      content: Text(text, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.black,
    ));
  }

  Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File(directory.path + "/data.json");
  }

  Future writeFile() async {
    final file = await getFile();
    try {
      final json = await jsonDecode(file.readAsStringSync());
      json["objects"].insert(0, {
        "name": "${_controllerName.text}",
        "url": "${_controllerUrl.text}",
        "command": [
          "${_controllerEndpoint1.text}",
          "${_controllerEndpoint2.text}"
        ],
        "value": ["${_controllerValue1.text}", "${_controllerValue2.text}"]
      });
      file.writeAsStringSync(jsonEncode(json));
    } catch (e) {
      Map json = {
        "objects": [
          {
            "name": "${_controllerName.text}",
            "url": "${_controllerUrl.text}",
            "command": [
              "${_controllerEndpoint1.text}",
              "${_controllerEndpoint2.text}"
            ],
            "value": ["${_controllerValue1.text}", "${_controllerValue2.text}"]
          }
        ]
      };

      file.writeAsStringSync(jsonEncode(json));

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _snack,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Adicione uma função de endpoint."),
              _campForm("Digite um nome. Exemplo: Lâmpada", _controllerName),
              _campForm("Digite o IP/URL", _controllerUrl),
              _campForm(
                  "Coloque o Endpoint. Exemplo: /L", _controllerEndpoint1),
              _campForm("O que o valor L representa? Exeplo: Ligar",
                  _controllerValue1),
              _campForm(
                  "Coloque o Endpoint. Exemplo: /H", _controllerEndpoint2),
              _campForm("O que o valor H representa? Exeplo: Desligar",
                  _controllerValue2),
              Divider(),
              GestureDetector(
                onTap: () async {
                  if (_controllerUrl.text.contains("http://") ||
                      _controllerUrl.text.contains("https://")) {
                    if (_controllerEndpoint1.text.length >= 2 &&
                        _controllerEndpoint2.text.length >= 2 &&
                        _controllerValue1.text.length >= 2 &&
                        _controllerValue2.text.length >= 2 &&
                        _controllerName.text.length >= 2) {
                      await writeFile();
                      print("Okay");
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                          (route) => false);
                    } else {
                      snackBar("Dados faltando");
                      print("Dados faltando");
                    }
                  } else {
                    snackBar("Adicione uma URL válida");
                    print("Adicione uma URL válida");
                  }
                },
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.black),
                    width: size.width * 0.4,
                    height: size.height * 0.06,
                    child: Center(
                      child: Text(
                        "Criar função",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16),
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _campForm(String text, TextEditingController _controller) {
    return Column(
      children: [
        Divider(
          color: Colors.white,
        ),
        Text(text),
        Container(
          child: TextField(
            controller: _controller,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 16),
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(40)),
        ),
      ],
    );
  }
}
