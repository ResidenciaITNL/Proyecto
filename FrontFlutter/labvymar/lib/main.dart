import 'package:flutter/material.dart';
import 'package:labvymar/Views/ConsultaMedica.dart';
import 'package:labvymar/Views/Cuenta.dart';
import 'package:labvymar/Views/EstudioMedico.dart';
import 'package:labvymar/Views/InventarioMedicamento.dart';
import 'package:labvymar/Views/Recepcion.dart';
import 'package:labvymar/Views/cambiarPassword.dart';
import 'package:labvymar/Views/login.dart';
import 'package:labvymar/Views/recoverpass.dart';
import 'package:labvymar/Views/home_admin.dart';
import 'package:labvymar/Views/AdministrarUsuarios.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      title: 'Laboratorio VYMAR',

      routes: {
        'login' : (_) => Login(), // Agregando la ruta para la vista login
        'recoverpass' : (_) => RecoverPass(), // Agregando la ruta para la vista recoverpass
        'cambiarPassword' : (_) => CambiarPassword(), // Agregando la ruta para la vista recoverpass
        'home_admin' : (_) => HomeAdmin(), // Agregando la ruta para la vista home_admin
        'AdministrarUsuarios' : (_) => AdminUsuarios(), // Agregando la ruta para la vista AdministrarUsuarios
        'ConsultaMedica' : (_) => ConsMedica(), // Agregando la ruta para la vista ConsultaMedica
        'EstudioMedico' : (_) => EstudioMed(), // Agregando la ruta para la vista EstudioMedico
        'InventarioMedicamento' : (_) => InvMedicamento(), // Agregando la ruta para la vista InventarioMedicamento
        'Recepcion' : (_) => Recep(), // Agregando la ruta para la vista Recepcion
        'Cuenta' : (_) => CuentaUser() // Agregando la ruta para la vista Cuenta
      },
      initialRoute: 'login',
    );
  }
}
