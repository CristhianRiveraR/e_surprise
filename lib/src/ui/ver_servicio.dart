import 'package:e_surprise/src/model/producto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class InfServicio extends StatefulWidget {
  final Producto producto;
  InfServicio(this.producto);

  @override
  _InfServicioState createState() => _InfServicioState();
}

final serviciosRref = FirebaseDatabase.instance.reference().child('productos');

class _InfServicioState extends State<InfServicio> {
  List<Producto>? items;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Información del Servicio'),
        backgroundColor: Colors.red[900],
      ),
      body: Container(
        height: 400.0,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                new Text(
                  "Nombre: ${widget.producto.nombre}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                Divider(),
                new Text(
                  "Descripción: ${widget.producto.descripcion}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                Padding(padding: EdgeInsets.only(top: 8.0)),
                Divider(),
                new Text(
                  "Fecha Alta: ${widget.producto.fechaAlta}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                Padding(padding: EdgeInsets.only(top: 8.0)),
                Divider(),
                new Text(
                  "No. Contacto: ${widget.producto.numContacto}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                Padding(padding: EdgeInsets.only(top: 8.0)),
                Divider(),
                new Text(
                  "Vendedor: ${widget.producto.vendedor}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                Padding(padding: EdgeInsets.only(top: 8.0)),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
