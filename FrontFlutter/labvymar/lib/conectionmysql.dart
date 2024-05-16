import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//---------------------------------------------------//
//-------- Clase de la conexion con el API  ---------//
//---------------------------------------------------//

class APIService {
  // Variable de la url base del API
  static const String baseUrl = 'http://localhost:5225/api';

  // Variable para obtener el token JWT
    final storage = const FlutterSecureStorage();


  Future<Map<String, dynamic>> login(String user, String password) async {
    if (user.isEmpty || password.isEmpty) {
      return {'error': 'Usuario y contraseña son requeridos'};
    }

    Map<String, String> payload = {
      'email': user,
      'password': password,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/Auth'),
      body: jsonEncode(payload),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      String token = responseData['token'];
      bool firstLogin = responseData['firstLogin'];

      await storage.write(key: 'token', value: token);

      print('Token JWT: $token');
      print('First Login: $firstLogin'); // Para verificar en la consola

      return {'success': true, 'token': token, 'firstLogin': firstLogin};
    } else {
      return {'error': 'Credenciales inválidas'};
    }
  }

  //---------------------------------------------------------//
  //-------- Método para obtener el token guardado  ---------//
  //---------------------------------------------------------//
  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }


  //---------------------------------------------------------//
  //--------------- Método para cerrar sesion  --------------//
  //---------------------------------------------------------//
  Future<String?> cerrarSesion() async {
    await storage.delete(key: 'token');

    String mensaje = 'Se elimino el token de manera exitosa.';

    return mensaje;
  }

  //--------------------------------------------------------------//
  //--------------- Método para cambiar contraseña  --------------//
  //--------------------------------------------------------------//

  Future<Map<String, dynamic>> actualizarPassword({
    required String Oldpassword,
    required String password
  }) async {
    String? token = await getToken(); // Obtener el token guardado

    if (token == null) {
      throw Exception('Token not found');
    }

    Map<String, String> payload = {
      'oldPassword': Oldpassword,
      'password': password,
    };

    final response = await http.put(
      Uri.parse('$baseUrl/MyAccount/change-password'), // Reemplaza 'updatePassword' con la ruta correcta en tu API
      body: jsonEncode(payload),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Añadir el token al encabezado de autorización
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update password');
    }
  }

  //---------------------------------------------------------//
  //-------- Método para obtener lista de usuarios  ---------//
  //---------------------------------------------------------//
  Future<List<Map<String, dynamic>>> getUsers() async {
    String? token = await getToken(); // Obtener el token guardado

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/Users'),
      headers: {
        'Authorization':
            'Bearer $token', // Añadir el token al encabezado de autorización
      },
    );
    print('Toke generado desde el get: $token');

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load users');
    }
  }

  //------------------------------------------------//
  //-------- Método para crear un usuario  ---------//
  //------------------------------------------------//
  Future<void> createUser(Map<String, dynamic> userData) async {
    String? token = await getToken(); // Obtener el token guardado

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/Users'),
      body: jsonEncode(userData),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Añadir el token al encabezado de autorización
      },
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create user');
    }
  }

  //-----------------------------------------------------//
  //-------- Método para actualizar un usuario  ---------//
  //-----------------------------------------------------//
  Future<void> updateUser(int userId, Map<String, dynamic> newData) async {
    String? token = await getToken(); // Obtener el token guardado

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/Users/$userId'),
      body: jsonEncode(newData),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Añadir el token al encabezado de autorización
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update user');
    }
  }

  //---------------------------------------------------//
  //-------- Método para eliminar un usuario  ---------//
  //---------------------------------------------------//
  Future<void> deleteUser(int userId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/SLC_bd/Users/$userId'),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }
}
