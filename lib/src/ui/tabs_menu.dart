import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TabsPage extends StatefulWidget {
  TabsPage({Key? key}) : super(key: key);

  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    //this.checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
