import 'dart:async';
import 'dart:io';

import 'package:e_surprise/src/ui/tabs_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:e_surprise/src/model/producto.dart';

import 'listado_activos.dart';

class UpdateServicio extends StatefulWidget {
  final Producto producto;

  const UpdateServicio({Key? key, required this.producto}) : super(key: key);

  @override
  _UpdateServicioState createState() => _UpdateServicioState();
}

final productoRef = FirebaseDatabase.instance.reference().child('productos');
final FirebaseAuth _auth = FirebaseAuth.instance;

class _UpdateServicioState extends State<UpdateServicio> {
  List<Producto>? items;

  TextEditingController? nombreController;
  TextEditingController? fechaAltaController;
  TextEditingController? descripcionController;
  TextEditingController? costoController;
  TextEditingController? numContactoController;

  Location _location = Location();
  late LocationData _locationData;
  String? latitud;
  String? longitud;
  PickedFile? pickFile;

  Position? posicion;
  Completer<GoogleMapController> mapController = new Completer();
  File? imageF;

  DateTime? _dateTime;

  Widget mapa() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(0, 0),
      ),
      mapType: MapType.normal,
      onMapCreated: (GoogleMapController controller) =>
          mapController.complete(controller),
    );
  }

  Widget image(File? imageFile) {
    return GestureDetector(
      onTap: () => modal(),
      child: (imageFile != null)
          ? Card(
              elevation: 10,
              child: Container(
                height: 180.0,
                child: Image.file(imageFile),
              ),
            )
          : Card(
              elevation: 10,
              child: Container(
                height: 180.0,
                child: Image.network(
                  "${widget.producto.imagePath}",
                  fit: BoxFit.contain,
                ),
              ),
            ),
    );
  }

  localizacion() async {
    posicion = await Geolocator.getCurrentPosition();
    GoogleMapController controller = await mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(posicion!.latitude, posicion!.longitude), zoom: 1.0)));
    }
  }

  @override
  void initState() {
    super.initState();
    nombreController = new TextEditingController(text: widget.producto.nombre);
    fechaAltaController =
        new TextEditingController(text: widget.producto.fechaAlta);
    descripcionController =
        new TextEditingController(text: widget.producto.descripcion);
    costoController = new TextEditingController(text: widget.producto.costo);
    numContactoController =
        new TextEditingController(text: widget.producto.numContacto);
    this.localizacion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Servicio'),
        backgroundColor: Colors.red[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 30,
              ),
              image(imageF),
              SizedBox(
                height: 26.0,
              ),
              TextField(
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Nombre',
                    hoverColor: Colors.red),
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
                controller: fechaAltaController,
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
                    icon: Icon(Icons.phone_android),
                    labelText: 'Tel. Contacto'),
                keyboardType: TextInputType.phone,
                controller: numContactoController,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                child: Stack(
                  children: [
                    mapa(),
                    Container(
                      child: Icon(Icons.location_on_outlined),
                      alignment: Alignment.center,
                    )
                  ],
                ),
                height: 200.0,
              ),
              SizedBox(
                height: 26.0,
              ),
              ElevatedButton(
                onPressed: () => updateServicio(),

                //debugPrint('${nombreController!.text}');

                child: Text('Actualizar Servicio'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[900],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  updateServicio() async {
    if (!validaciones()) {
      showError('Verifique que haya ingresado todos los datos');
    } else {
      String url = '${widget.producto.imagePath}';
      if (pickFile != null) {
        TaskSnapshot snapshot = await subirArchivo(pickFile!);
        url = await snapshot.ref.getDownloadURL();
      }

      _location.getLocation().then((value) {
        _locationData = value;
        latitud = _locationData.latitude.toString();
        longitud = _locationData.longitude.toString();
        productoRef.child(widget.producto.id!).set({
          'nombre': nombreController!.text,
          'fechaAlta': fechaAltaController!.text,
          'descripcion': descripcionController!.text,
          'numContacto': numContactoController!.text,
          'latitud': latitud,
          'longitud': longitud,
          'imagePath': url,
          'costo': costoController!.text,
          'vendedor': _auth.currentUser!.email,
          'status': 'activo'
        }).then((_) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TabsPage()));
        });
      });
    }
  }

  bool validaciones() {
    if (nombreController!.text.isEmpty ||
        descripcionController!.text.isEmpty ||
        numContactoController!.text.isEmpty ||
        fechaAltaController!.text.isEmpty ||
        costoController!.text.isEmpty) {
      return false;
    }
    return true;
  }

  void modal() {
    Widget galleryButton = IconButton(
      icon: Icon(
        Icons.image_outlined,
        size: 30,
      ),
      onPressed: () => seleccionarImagen(ImageSource.gallery),
    );
    Widget cameraButton = IconButton(
      icon: Icon(
        Icons.camera_alt_outlined,
        size: 30,
      ),
      onPressed: () => seleccionarImagen(ImageSource.camera),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Seleccione de camara o galeria',
              style: TextStyle(fontSize: 15),
            ),
            actions: [cameraButton, galleryButton],
          );
        });
  }

  Future seleccionarImagen(ImageSource imgSrc) async {
    pickFile = await ImagePicker().getImage(source: imgSrc);
    if (imgSrc != null) {
      imageF = File(pickFile!.path);
    }

    Navigator.of(context).pop();

    setState(() {});
  }

  Future<TaskSnapshot> subirArchivo(PickedFile file) async {
    String nombre = '${UniqueKey().toString()}.jpg';

    Reference ref =
        FirebaseStorage.instance.ref().child('servicios').child('/$nombre');

    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});

    UploadTask uploadTask = ref.putFile(File(file.path), metadata);
    return uploadTask;
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Advertencia'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }
}
