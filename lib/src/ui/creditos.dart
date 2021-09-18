import 'package:flutter/material.dart';

import 'login.dart';

class Creditos extends StatefulWidget {
  Creditos({Key? key}) : super(key: key);

  @override
  _CreditosState createState() => _CreditosState();
}

class _CreditosState extends State<Creditos> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Card(
                  elevation: 10,
                  child: Container(
                    height: 180.0,
                    child: Image.asset(
                      "assets/present.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                new Text(
                  "Presenta: Cristhian Rivera Rodríguez",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                Divider(),
                new Text(
                  "Versión: 1",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                Padding(padding: EdgeInsets.only(top: 8.0)),
                Divider(),
                new Text(
                  "Profesora: Rociío Elizabeth Pulido",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                Padding(padding: EdgeInsets.only(top: 8.0)),
                Divider(),
                new Text(
                  "Materia: Programación Móvil Avanzada",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
