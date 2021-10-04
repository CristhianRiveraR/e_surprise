import 'package:e_surprise/src/ui/opciones.dart';
import 'package:flutter/material.dart';

//import 'package:alumnos_app/src/ui/tabs_alumnos.dart';
import 'package:e_surprise/src/ui/login.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Servicios',
      //home: TabsPage(),
      home: OpcionesView(),
      theme: ThemeData(
        primaryColor: Colors.red[900],
        accentColor: Colors.grey[800],
      ),
    );
  }
}
