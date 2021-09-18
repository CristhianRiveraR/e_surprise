import 'package:e_surprise/src/model/producto.dart';
import 'package:e_surprise/src/ui/update_servicio.dart';
import 'package:e_surprise/src/ui/ver_servicio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class ListadoClienteView extends StatefulWidget {
  const ListadoClienteView({Key? key}) : super(key: key);

  @override
  _ListadoClienteViewState createState() => _ListadoClienteViewState();
}

var productosRef = FirebaseDatabase.instance
    .reference()
    .child('productos')
    .orderByChild('status')
    .equalTo('activo');

final solicitados = FirebaseDatabase.instance.reference().child('solicitados');
final FirebaseAuth _auth = FirebaseAuth.instance;

final productosRefInicial =
    FirebaseDatabase.instance.reference().child('productos');

class _ListadoClienteViewState extends State<ListadoClienteView> {
  List<Producto>? items;
  StreamSubscription<Event>? addProductos;
  StreamSubscription<Event>? changeProductos;
  TextEditingController? buscarController;
  @override
  void initState() {
    super.initState();

    items = [];

    addProductos = productosRef.onChildAdded.listen(_addProducto);
    buscarController = new TextEditingController();
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          keyboardType: TextInputType.text,
          controller: buscarController,
          decoration: InputDecoration(
            //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: 'Busqueda',
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                buscar();
              },
              icon: Icon(Icons.search, color: Colors.red[900]))
        ],
      ),
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
                        solicitarProducto(context, items![position], position),
                    icon: Icon(
                      Icons.shopping_cart_outlined,
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

  void buscar() async {
    productosRef = FirebaseDatabase.instance
        .reference()
        .child('productos')
        .orderByChild('nombre')
        .equalTo(buscarController!.text);

    setState(() {
      items = [];
      addProductos = productosRef.onChildAdded.listen(_addProducto);
    });
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

  void solicitarProducto(
      BuildContext context, Producto producto, int position) async {
    solicitados.push().set({
      //'producto': producto.id,
      'cliente': _auth.currentUser!.email,
      //'vendedor': producto.vendedor

      'nombre': producto.nombre,
      'fechaAlta': producto.fechaAlta,
      'descripcion': producto.descripcion,
      'numContacto': producto.numContacto,
      'latitud': producto.latitud,
      'longitud': producto.longitud,
      'imagePath': producto.imagePath,
      'costo': producto.costo,
      'vendedor': producto.vendedor
    }).then((value) {});
  }
}
