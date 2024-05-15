import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class APIService {
  static const String baseUrl =
      'http://localhost:5225/api'; // Cambia si es necesario

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

      // Guardar el token de manera segura
      await storage.write(key: 'token', value: token);

      print('Token JWT: $token'); // Imprime el token en la consola
      return {'success': true, 'token': token};
    } else {
      return {'error': 'Credenciales inválidas'};
    }
  }

  // Método para obtener el token guardado
  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  // Método para obtener todos los usuarios
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

  // Método para crear un usuario
  Future<void> createUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/SLC_bd/Users'),
      body: jsonEncode(userData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create user');
    }
  }

  // Método para actualizar un usuario
  Future<void> updateUser(int userId, Map<String, dynamic> newData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/SLC_bd/Users/$userId'),
      body: jsonEncode(newData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update user');
    }
  }

  // Método para eliminar un usuario
  Future<void> deleteUser(int userId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/SLC_bd/Users/$userId'),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }
}
