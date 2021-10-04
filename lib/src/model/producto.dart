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
  String? vendedor;
  String? cliente;

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
      this.vendedor,
      this.status,
      this.cliente);

  Producto.map(dynamic obj) {
    this.nombre = obj['nombre'];
    this.fechaAlta = obj['fechaAlta'];
    this.imagePath = obj['imagePath'];
    this.descripcion = obj['descripcion'];
    this.costo = obj['costo'];
    this.numContacto = obj['numContacto'];
    this.latitud = obj['latitud'];
    this.longitud = obj['longitud'];
    this.vendedor = obj['vendedor'];
    this.status = obj['status'];
    this.cliente = obj['cliente'];
  }

  Producto.fromSnapshot(DataSnapshot snapShot) {
    id = snapShot.key;
    nombre = snapShot.value['nombre'];
    fechaAlta = snapShot.value['fechaAlta'];
    imagePath = snapShot.value['imagePath'];
    descripcion = snapShot.value['descripcion'];
    costo = snapShot.value['costo'];
    numContacto = snapShot.value['numContacto'];
    latitud = snapShot.value['latitud'];
    longitud = snapShot.value['longitud'];
    vendedor = snapShot.value['vendedor'];
    status = snapShot.value['status'];
    cliente = snapShot.value['cliente'];
  }
}
