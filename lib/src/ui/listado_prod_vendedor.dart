import 'package:e_surprise/src/model/producto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class ListadoProdVendedorView extends StatefulWidget {
  const ListadoProdVendedorView({Key? key}) : super(key: key);

  @override
  _ListadoProdVendedorViewState createState() =>
      _ListadoProdVendedorViewState();
}

final productosRef = FirebaseDatabase.instance.reference().child('productos');

class _ListadoProdVendedorViewState extends State<ListadoProdVendedorView> {
  List<Producto>? items;
  StreamSubscription<Event>? addProductos;
  StreamSubscription<Event>? changeProductos;

  @override
  void initState() {
    super.initState();

    items = [];

    addProductos = productosRef.onChildAdded.listen(_addProducto);
    //changeProductos = productosRef.onChildChanged.listen(_updateAlumno);
  }

  @override
  void dispose() {
    super.dispose();
    changeProductos?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //title: 'Listado de Alumnos',
      resizeToAvoidBottomInset: false,
      body: Center(
        child: ListView.builder(
          itemCount: items!.length,
          padding: EdgeInsets.only(top: 12.0),
          itemBuilder: (context, position) {
            return Column(children: <Widget>[
              Divider(
                height: 7.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: Text(
                        '${items?[position].nombre}',
                        style:
                            TextStyle(color: Colors.blue[700], fontSize: 25.0),
                      ),

                      subtitle: Text(
                        '${items?[position].descripcion}',
                        style:
                            TextStyle(color: Colors.blue[400], fontSize: 18.0),
                      ),
                      leading: Column(
                        children: <Widget>[
                          Card(
                            elevation: 10,
                            child: Container(
                              height: 48.0,
                              child: Image.network(
                                '${items?[position].imagePath}',
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        ],
                      ),
                      //onTap: () => updateAlu(context, items![position]),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        _borrarProducto(context, items![position], position),
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red[900],
                    ),
                  ),
                  IconButton(
                    onPressed: () => verProducto(context, items![position]),
                    icon: Icon(
                      Icons.remove_red_eye_outlined,
                      color: Colors.blue,
                    ),
                  ),
                ],
              )
            ]);
          },
        ),
      ),
    );
  }

  void _addProducto(Event evento) {
    setState(() {
      items!.add(new Producto.fromSnapshot(evento.snapshot));
    });
  }

  void _borrarProducto(
      BuildContext context, Producto alumno, int position) async {
    await productosRef.child(alumno.id!).remove().then((_) {
      setState(() {
        items!.removeAt(position);
      });
    });
  }
/*
  void infoAlumno(BuildContext context, Alumno alumno) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: builde)
    );
  }
*/

  void verProducto(BuildContext context, Producto alumno) async {
    //await Navigator.push(
    //    context, MaterialPageRoute(builder: (context) => InfoAlumno(alumno)));
  }
}
