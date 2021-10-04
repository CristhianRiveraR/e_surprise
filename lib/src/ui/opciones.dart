import 'package:e_surprise/src/ui/creditos.dart';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

import 'login.dart';

class OpcionesView extends StatefulWidget {
  OpcionesView({Key? key}) : super(key: key);

  @override
  _OpcionesViewState createState() => _OpcionesViewState();
}

class _OpcionesViewState extends State<OpcionesView> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  late VideoPlayerController _controller;

  login() {
    _controller.pause();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginView()));
  }

  creditos() {
    _controller.pause();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Creditos()));
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/reseniaApp.mp4');
    _controller.addListener(() {
      setState(() {});
    });
    _controller.initialize().then((value) {
      setState(() {});
    });
    _controller.play();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.red[900],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: login,
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final creditosButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.red[900],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: creditos,
        child: Text("Créditos",
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
                Container(
                  padding: const EdgeInsets.all(40.0),
                  height: 500,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        VideoPlayer(_controller),
                        VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                loginButton,
                SizedBox(
                  height: 15.0,
                ),
                creditosButton
              ],
            ),
          ),
        ),
      ),
    );
  }
}
