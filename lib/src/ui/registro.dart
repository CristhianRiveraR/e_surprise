import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:e_surprise/src/ui/tabs_menu.dart';

class RegistroView extends StatefulWidget {
  RegistroView({Key? key}) : super(key: key);

  @override
  _RegistroViewState createState() => _RegistroViewState();
}

class _RegistroViewState extends State<RegistroView> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController? emailController;
  TextEditingController? passWordController;

  @override
  void initState() {
    super.initState();
    this.checkAuth();
    emailController = new TextEditingController();
    passWordController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final emailCampo = TextField(
      obscureText: false,
      style: style,
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordCampo = TextField(
      obscureText: true,
      style: style,
      keyboardType: TextInputType.text,
      controller: passWordController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final registroButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFFFF0005),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: registro,
        child: Text("Registrarse",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
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
                SizedBox(
                  height: 150.0,
                  child: Image.asset(
                    "assets/regalo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 35.0,
                ),
                emailCampo,
                SizedBox(
                  height: 15.0,
                ),
                passwordCampo,
                SizedBox(
                  height: 15.0,
                ),
                registroButton,
              ],
            ),
          ),
        ),
      ),
    );
  }

  checkAuth() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TabsPage()));
      }
    });
  }

  registro() async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: emailController!.text, password: passWordController!.text);
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('${e.toString()}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'),
                ),
              ],
            );
          });
    }
  }
}
