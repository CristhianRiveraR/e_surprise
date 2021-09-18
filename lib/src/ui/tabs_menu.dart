import 'package:e_surprise/src/ui/login.dart';
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
String? rol = "vendedor";

class TabsPage extends StatefulWidget {
  TabsPage({Key? key, this.user}) : super(key: key);
  User? user;
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<void> getUserData() async {
    User? userData = await FirebaseAuth.instance.currentUser;

    setState(() {
      user = userData;
      email = userData!.email;
    });

    final query = FirebaseDatabase.instance
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
  }

  @override
  void initState() {
    super.initState();
    this.checkAuth();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final tabBar;
    final tabBarView;
    int tabLength = 0;
    if (rol == 'vendedor') {
      tabLength = 3;

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
        ],
      );

      tabBarView = TabBarView(
        children: <Widget>[
          SetProductoView(),
          ListadoProdVActivosView(),
          ListadoProdInactivosView()
        ],
      );
    } else {
      tabLength = 2;

      tabBar = TabBar(
        tabs: [
          Tab(
            icon: Icon(Icons.list),
            text: 'Servicios',
          ),
          Tab(
            icon: Icon(Icons.check),
            text: 'Solicitados',
          ),
        ],
      );
      tabBarView = TabBarView(
        children: <Widget>[ListadoClienteView(), ListadoPedidosView()],
      );
    }

    return DefaultTabController(
      length: tabLength,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Center(
            child: Text('Bienvenid@: ${user!.email}'),
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
}
