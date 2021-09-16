import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:e_surprise/src/model/producto.dart';

class SetProductoView extends StatefulWidget {
  SetProductoView({Key? key}) : super(key: key);

  @override
  _SetProductoViewState createState() => _SetProductoViewState();
}

final alumnoRef = FirebaseDatabase.instance.reference().child('productos');

class _SetProductoViewState extends State<SetProductoView> {
  TextEditingController? nombreController;
  TextEditingController? fechaAltaController;
  TextEditingController? descripcionController;
  TextEditingController? costoController;
  TextEditingController? numContactoController;

  DateTime? _dateTime;

  @override
  void initState() {
    super.initState();
    nombreController = new TextEditingController();
    fechaAltaController = new TextEditingController();
    descripcionController = new TextEditingController();
    costoController = new TextEditingController();
    numContactoController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          children: <Widget>[
            TextField(
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              decoration: InputDecoration(
                  icon: Icon(Icons.person), labelText: 'Nombre'),
              keyboardType: TextInputType.text,
              controller: nombreController,
            ),
            TextField(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
              decoration: InputDecoration(
                  icon: Icon(Icons.date_range_rounded),
                  labelText: 'Fecha Alta'),
              keyboardType: TextInputType.text,
              controller: fechaAltaController!
                ..text = _dateTime == null ? '' : _dateTime.toString(),
              onTap: () {
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2001),
                        lastDate: DateTime(2022))
                    .then((date) {
                  setState(() {
                    _dateTime = date;
                  });
                });
              },
            ),
            TextField(
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              decoration: InputDecoration(
                  icon: Icon(Icons.text_format_rounded),
                  labelText: 'Descripción'),
              keyboardType: TextInputType.text,
              controller: descripcionController,
            ),
            TextField(
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              decoration: InputDecoration(
                  icon: Icon(Icons.money_sharp), labelText: 'Costo'),
              keyboardType: TextInputType.number,
              controller: costoController,
            ),
            TextField(
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              decoration: InputDecoration(
                  icon: Icon(Icons.phone_android), labelText: 'Tel. Contacto'),
              keyboardType: TextInputType.phone,
              controller: numContactoController,
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                alumnoRef.push().set({
                  'nombre': nombreController!.text,
                }).then((value) {
                  nombreController!.text = '';
                });
                //debugPrint('${nombreController!.text}');
              },
              child: Text('Agregar Producto'),
            )
          ],
        ),
      ),
    );
  }
}
