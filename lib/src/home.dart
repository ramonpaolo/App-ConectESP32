//---- Packages
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

//---- Screens
import 'package:automatization/src/add_function.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controllerName = TextEditingController();

  var _snack = GlobalKey<ScaffoldState>();

  Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File(directory.path + "/data.json");
  }

  Future readFile() async {
    try {
      final file = await getFile();
      print(await jsonDecode(file.readAsStringSync()));
      return await jsonDecode(file.readAsStringSync());
    } catch (e) {
      return null;
    }
  }

  void trocarValores(
      String value1, String value2, Map object, int index) async {
    setState(() {
      object["value"].clear();
      object["value"].insert(0, value2);
      object["value"].insert(1, value1);
    });

    final file = await getFile();
    final json = await jsonDecode(file.readAsStringSync());

    json["objects"][index]["value"] = object["value"];

    file.writeAsStringSync(jsonEncode(json));
  }

  void trocarNome(String name, Map object, int index) async {
    setState(() {
      object["name"] = name;
    });

    final file = await getFile();
    final json = await jsonDecode(file.readAsStringSync());

    json["objects"][index]["name"] = name;

    file.writeAsStringSync(jsonEncode(json));
  }

  snackBar(String text) {
    _snack.currentState.showSnackBar(SnackBar(
      content: Text(text, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.black,
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: 36,
              color: Colors.yellow,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddFunctions()));
            },
          )
        ],
      ),
      key: _snack,
      body: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
          color: Colors.white,
          child: FutureBuilder(
              future: readFile(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Bem Vindo",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(
                        "Adicione alguma função no + acima",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      return button(
                          size, snapshot.data["objects"][index], index);
                    },
                    itemCount: snapshot.data["objects"].length,
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
    );
  }

  Widget button(Size size, Map object, int index) {
    return Column(
      children: [
        Divider(
          color: Colors.transparent,
        ),
        ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: GestureDetector(
                onLongPress: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          setState(() {
                            _controllerName.text = object["name"];
                          });
                          return Container(
                            padding: EdgeInsets.all(16),
                            width: size.width,
                            height: size.height,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    width: size.width * 0.09,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                  ),
                                  Divider(
                                    color: Colors.white,
                                  ),
                                  Text("Mudar o nome:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  Container(
                                    child: TextField(
                                      onSubmitted: (c) {
                                        trocarNome(_controllerName.text, object,
                                            index);
                                      },
                                      controller: _controllerName,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(left: 16),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                  ),
                                  Divider(
                                    color: Colors.white,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print("true");
                                      trocarValores(object["value"][0],
                                          object["value"][1], object, index);
                                    },
                                    child: Container(
                                      width: size.width * 0.4,
                                      height: size.height * 0.05,
                                      decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      child: Center(
                                          child: Text(
                                        "Trocar os valores",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                onTap: () async {
                  String command = object["command"][0];
                  String command2 = object["command"][1];

                  String value = object["value"][0];
                  String value2 = object["value"][1];

                  http.Response response =
                      await http.get("${object["url"]}$command");

                  setState(() {
                    object["command"].clear();
                    object["command"].insert(0, command2);
                    object["command"].insert(1, command);
                    object["value"].clear();
                    object["value"].insert(0, value2);
                    object["value"].insert(1, value);
                  });

                  final file = await getFile();
                  final json = await jsonDecode(file.readAsStringSync());

                  json["objects"][index]["value"] = object["value"];
                  json["objects"][index]["command"] = object["command"];

                  file.writeAsStringSync(jsonEncode(json));
                },
                child: Container(
                    width: size.width * 0.5,
                    height: size.height * 0.06,
                    color: Colors.yellow,
                    child: Center(
                      child: Text(
                        object["name"] + " - " + object["value"][0],
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ))))
      ],
    );
  }
}
