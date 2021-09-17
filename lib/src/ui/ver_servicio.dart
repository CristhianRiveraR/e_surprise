import 'dart:async';

import 'package:e_surprise/src/model/producto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

class InfServicio extends StatefulWidget {
  final Producto producto;
  InfServicio(this.producto);

  @override
  _InfServicioState createState() => _InfServicioState();
}

final serviciosRref = FirebaseDatabase.instance.reference().child('productos');

class _InfServicioState extends State<InfServicio> {
  List<Producto>? items;

  Location _location = Location();
  late LocationData _locationData;
  String? latitud;
  String? longitud;

  Position? posicion;
  Completer<GoogleMapController> mapController = new Completer();

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

  localizacion() async {
    posicion = await Geolocator.getCurrentPosition();
    GoogleMapController controller = await mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(posicion!.latitude, posicion!.longitude), zoom: 2.0)));
    }
  }

  @override
  void initState() {
    super.initState();
    this.localizacion();
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
        //height: 400.0,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                Card(
                  elevation: 10,
                  child: Container(
                    height: 180.0,
                    child: Image.network(
                      "${widget.producto.imagePath}",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
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
                new Text(
                  "Ubicación:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                Padding(padding: EdgeInsets.only(top: 8.0)),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
