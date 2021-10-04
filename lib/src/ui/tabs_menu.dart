import 'dart:async';

import 'package:e_surprise/src/model/usuario.dart';
import 'package:e_surprise/src/ui/aprobados_cliente.dart';
import 'package:e_surprise/src/ui/aprovados_vendedor.dart';
import 'package:e_surprise/src/ui/login.dart';
import 'package:e_surprise/src/ui/pendientes_cliente.dart';
import 'package:e_surprise/src/ui/pendientes_vendedor.dart';
import 'package:e_surprise/src/ui/set_producto_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'listado_activos.dart';
import 'listado_cliente.dart';
import 'listado_inactivos.dart';
import 'listado_pedidos.dart';
import 'listado_prod_vendedor.dart';

String? email = "";
String? rol = "";

final usrRef = FirebaseDatabase.instance.reference().child('usuarios');

class TabsPage extends StatefulWidget {
  final Usuario? usuario;
  TabsPage({Key? key, this.usuario}) : super(key: key);
  User? user;
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<Event>? addUsuarios;
  Usuario? usr;
  //final db = FirebaseDatabase.instance;
  //final _users_Ref = fb.reference().child("usuarios/${userID}");
  checkAuth() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginView()));
      }
    });
  }

  User? user;
/*
  Future<void> getUserData() async {
    User? userData = FirebaseAuth.instance.currentUser;

    FirebaseDatabase.instance
        .reference()
        .child("usuarios")
        .orderByChild('email')
        .equalTo(email)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        //print(values["rol"]);
        rol = values["rol"];
      });
    });

    setState(() {
      user = userData;
      email = userData!.email;
    });
  }
*/
  @override
  void initState() {
    super.initState();
    this.checkAuth();
    usr = new Usuario("", "", "");
    //getUserData();
    addUsuarios = usrRef.onChildAdded.listen(_addUsuario);
  }

  @override
  Widget build(BuildContext context) {
    final tabBar;
    final tabBarView;

    int tabLength = 0;

    if (usr!.rol == 'vendedor') {
      tabLength = 5;

      tabBar = TabBar(
        tabs: [
          Tab(
            icon: Icon(Icons.add),
            text: 'Agregar',
          ),
          Tab(
            icon: Icon(Icons.check),
            text: 'Activos',
          ),
          Tab(
            icon: Icon(Icons.cancel_outlined),
            text: 'Inactivos',
          ),
          Tab(
            icon: Icon(Icons.timelapse),
            text: 'Pendientes',
          ),
          Tab(
            icon: Icon(Icons.store),
            text: 'Aprobados',
          ),
        ],
      );

      tabBarView = TabBarView(
        children: <Widget>[
          SetProductoView(),
          ListadoProdVActivosView(),
          ListadoProdInactivosView(),
          PendientesVendedorView(),
          AprobadosVendedorView()
        ],
      );
    } else {
      tabLength = 4;

      tabBar = TabBar(
        tabs: [
          Tab(
            icon: Icon(Icons.list),
            text: 'Servicios',
          ),
          Tab(
            icon: Icon(Icons.history),
            text: 'Historial',
          ),
          Tab(
            icon: Icon(Icons.timelapse),
            text: 'Pendientes',
          ),
          Tab(
            icon: Icon(Icons.shopping_cart_sharp),
            text: 'Aprobados',
          ),
        ],
      );
      tabBarView = TabBarView(
        children: <Widget>[
          ListadoClienteView(),
          ListadoPedidosView(),
          PendientesClienteView(),
          AprobadosClienteView()
        ],
      );
    }

    return DefaultTabController(
      length: tabLength,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Center(
            child: Text('Bienvenid@: ${usr!.email}'),
          ),
          backgroundColor: Colors.red[900],
          bottom: tabBar,
        ),
        body: tabBarView,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.logout,
            color: Colors.white,
          ),
          onPressed: () {
            _auth.signOut();
          },
          backgroundColor: Colors.red[900],
        ),
      ),
    );
  }
/*
  buscar() async {
    usrRef = FirebaseDatabase.instance
        .reference()
        .child('usuarios')
        .orderByChild('email')
        .equalTo(_auth.currentUser!.email);

    addUsuarios = usrRef.onChildAdded.listen(_addUsuario);
  }
*/

  void _addUsuario(Event evento) {
    setState(() {
      Usuario usrTemp = new Usuario.fromSnapshot(evento.snapshot);

      if (usrTemp.email == _auth.currentUser!.email) {
        //usr = usrTemp;
        usr = new Usuario(usrTemp.id, usrTemp.email, usrTemp.rol);
      }
    });
  }
}
