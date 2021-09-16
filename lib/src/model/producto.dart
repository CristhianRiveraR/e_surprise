import 'package:firebase_database/firebase_database.dart';

class Producto {
  String? id;
  String? nombre;
  String? fechaAlta;
  String? imagePath;
  String? descripcion;
  String? costo;
  String? numContacto;
  String? latitud;
  String? longitud;
  String? status;

  Producto(
      this.id,
      this.nombre,
      this.fechaAlta,
      this.imagePath,
      this.longitud,
      this.descripcion,
      this.costo,
      this.numContacto,
      this.latitud,
      this.status);

  Producto.map(dynamic obj) {
    this.nombre = obj['nombre'];
    this.fechaAlta = obj['fechaAlta'];
    this.imagePath = obj['imagePath'];
    this.descripcion = obj['descripcion'];
    this.costo = obj['costo'];
    this.numContacto = obj['numContacto'];
    this.latitud = obj['latitud'];
    this.longitud = obj['longitud'];
    this.status = obj['status'];
  }

  Producto.fromSnapshot(DataSnapshot snapShot) {
    nombre = snapShot.value['nombre'];
    fechaAlta = snapShot.value['fechaAlta'];
    imagePath = snapShot.value['imagePath'];
    descripcion = snapShot.value['descripcion'];
    costo = snapShot.value['costo'];
    numContacto = snapShot.value['numContacto'];
    latitud = snapShot.value['latitud'];
    longitud = snapShot.value['longitud'];
    status = snapShot.value['status'];
  }
}
