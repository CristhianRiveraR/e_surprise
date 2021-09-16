import 'package:e_surprise/src/ui/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TabsPage extends StatefulWidget {
  TabsPage({Key? key, this.user}) : super(key: key);
  User? user;
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fb = FirebaseDatabase.instance;
  //final _users_Ref = fb.reference().child("usuarios/${userID}");

  User? user;
  Future<void> getUserData() async {
    User? userData = await FirebaseAuth.instance.currentUser;

    setState(() {
      user = userData;
      print(userData!.email);
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Bienvenid@: ${user!.email}'),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.list),
                text: 'Listado de productos',
              ),
              Tab(
                icon: Icon(Icons.add),
                text: 'Agregar Productos',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[LoginView(), LoginView()],
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
