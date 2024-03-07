import 'package:flutter/material.dart';
import 'package:labvymar/Views/login.dart';
import 'package:labvymar/Views/recoverpass.dart';
import 'package:labvymar/Views/home_admin.dart';

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
        'home_admin' : (_) => HomeAdmin(), // Agregando la ruta para la vista recoverpass
      },
      initialRoute: 'login',
    );
  }
}
