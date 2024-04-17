import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  static const String baseUrl = 'http://localhost:5225/api'; // Cambia si es necesario

  // Método para obtener todos los usuarios
  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/SLC_bd/Users'));
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

  Future<bool> loggin(String user, String password) async{

    Map<String, String> padeLoad = {
      'email': user,
      'password': password
    };

    final response = await http.post(
      Uri.parse('$baseUrl/Auth'),
      body: jsonEncode(padeLoad),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 200;
  }

}







