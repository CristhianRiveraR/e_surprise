import 'package:e_surprise/src/model/producto.dart';
import 'package:e_surprise/src/ui/update_servicio.dart';
import 'package:e_surprise/src/ui/ver_servicio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class ListadoProdVActivosView extends StatefulWidget {
  const ListadoProdVActivosView({Key? key}) : super(key: key);

  @override
  _ListadoProdActivosViewState createState() => _ListadoProdActivosViewState();
}

final productosRef = FirebaseDatabase.instance
    .reference()
    .child('productos')
    .orderByChild('status')
    .equalTo('activo');

final productosRefInicial =
    FirebaseDatabase.instance.reference().child('productos');

class _ListadoProdActivosViewState extends State<ListadoProdVActivosView> {
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
                        modalEliminar(context, items![position], position),
                    icon: Icon(
                      Icons.auto_delete_outlined,
                      color: Colors.red[900],
                    ),
                  ),
                  IconButton(
                    onPressed: () => updateProducto(context, items![position]),
                    icon: Icon(
                      Icons.edit,
                      color: Colors.red[900],
                    ),
                  ),
                  IconButton(
                    onPressed: () => verProducto(context, items![position]),
                    icon: Icon(
                      Icons.remove_red_eye,
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

/*
  void infoAlumno(BuildContext context, Alumno alumno) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: builde)
    );
  }
*/

  void verProducto(BuildContext context, Producto producto) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => InfServicio(producto)));
  }

  void updateProducto(BuildContext context, Producto producto) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UpdateServicio(producto: producto)));
  }

  void _borrarProducto(
      BuildContext context, Producto alumno, int position) async {
    await productosRefInicial.child(alumno.id!).remove().then((_) {
      setState(() {
        items!.removeAt(position);
      });
    });
  }

  void bajaProducto(
      BuildContext context, Producto producto, int position) async {
    productosRefInicial.child(producto.id!).set({
      'status': 'inactivo',
      'nombre': producto.nombre!,
      'fechaAlta': producto.fechaAlta!,
      'descripcion': producto.descripcion!,
      'numContacto': producto.numContacto!,
      'latitud': producto.latitud!,
      'longitud': producto.longitud!,
      'imagePath': producto.imagePath!,
      'costo': producto.costo!,
      'vendedor': producto.vendedor!
    }).then((_) {
      setState(() {
        items!.removeAt(position);
      });
    });
  }

  void modalEliminar(BuildContext context, Producto producto, int position) {
    String nombre = producto.nombre.toString();
    Widget bajaLogica = IconButton(
      icon: Icon(
        Icons.auto_delete_outlined,
        size: 30,
      ),
      onPressed: () => bajaProducto(context, items![position], position),
    );
    Widget bajaDefinitiva = IconButton(
      icon: Icon(
        Icons.delete,
        size: 30,
      ),
      onPressed: () => _borrarProducto(context, items![position], position),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Seleccione El tipo de baja',
              style: TextStyle(fontSize: 15),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Card(
                    elevation: 10,
                    child: Container(
                      height: 180.0,
                      child: Image.network(
                        "${producto.imagePath}",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Text(
                    'Nombre: ${producto.nombre!}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  Divider(),
                  Text(
                    'Descripción: ${producto.descripcion!}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  Divider(),
                  Text(
                    'Fecha alta: ${producto.fechaAlta!}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  Divider(),
                  Text(
                    'Costo: ${producto.costo!}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  Divider(),
                ],
              ),
            ),
            actions: [bajaLogica, bajaDefinitiva],
          );
        });
  }
}
