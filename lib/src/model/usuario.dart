import 'package:firebase_database/firebase_database.dart';

class Usuario {
  String? id;
  String? email;
  String? rol;

  Usuario(this.id, this.email, this.rol);

  Usuario.map(dynamic obj) {
    this.email = obj['email'];
    this.rol = obj['rol'];
  }

  Usuario.fromSnapshot(DataSnapshot snapShot) {
    id = snapShot.key;
    email = snapShot.value['email'];
    rol = snapShot.value['rol'];
  }
}
