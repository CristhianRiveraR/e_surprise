import 'package:e_surprise/src/ui/login.dart';
import 'package:e_surprise/src/ui/set_producto_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
        .limitToFirst(1)
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
    //this.checkAuth();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final tabBar;
    int tabLength = 0;
    if (rol == 'vendedor') {
      tabLength = 5;

      tabBar = TabBar(
        tabs: [
          Tab(
            icon: Icon(Icons.home),
            text: 'Home',
          ),
          Tab(
            icon: Icon(Icons.list),
            text: 'Productos',
          ),
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
    } else {
      tabBar = TabBar(
        tabs: [
          Tab(
            icon: Icon(Icons.list),
            text: 'rol',
          ),
        ],
      );
    }
    return DefaultTabController(
      length: tabLength,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Bienvenid@: ${user!.email}'),
          ),
          backgroundColor: Colors.red[900],
          bottom: tabBar,
        ),
        body: TabBarView(
          children: <Widget>[
            ListadoProdVendedorView(),
            ListadoProdVendedorView(),
            SetProductoView(),
            ListadoProdVendedorView(),
            ListadoProdVendedorView()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.logout),
          onPressed: () {
            _auth.signOut();
          },
        ),
      ),
    );
  }
}
