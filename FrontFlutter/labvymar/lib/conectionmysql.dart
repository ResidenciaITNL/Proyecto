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

  //----------------------------------------//
  //-- Método para obtener iniciar sesion --//
  //----------------------------------------//

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

      // print('Token JWT: $token');
      // print('First Login: $firstLogin'); // Para verificar en la consola

      return {'success': true, 'token': token, 'firstLogin': firstLogin};
    } else {
      return {'error': 'Credenciales inválidas'};
    }
  }

  //-------------------------------------------//
  //-- Método para obtener el token guardado --//
  //-------------------------------------------//

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  //-------------------------------//
  //-- Método para cerrar sesion --//
  //-------------------------------//

  Future<void> cerrarSesion() async {
    try {
      await storage.delete(key: 'token');
      print('El token se eliminó correctamente.');
    } catch (e) {
      print('Error al eliminar el token: $e');
    }
  }

  //------------------------------------------------//
  //-- Método para cambiar contraseña del usuario --//
  //------------------------------------------------//

  Future<Map<String, dynamic>> actualizarPassword({
    required String Oldpassword,
    required String password,
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
      Uri.parse('$baseUrl/MyAccount/change-password'),
      body: jsonEncode(payload),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      responseBody['success'] = true;
      return responseBody;
    } else {
      Map<String, dynamic> errorResponse = {
        'success': false,
        'message':
            jsonDecode(response.body)['message'] ?? 'Failed to update password',
      };
      return errorResponse;
    }
  }

  //---------------------------------------//
  //-- Método para cambiar email usuario --//
  //---------------------------------------//

  Future<Map<String, dynamic>> actualizarEmail({
    required String Oldemail,
    required String email,
  }) async {
    String? token = await getToken(); // Obtener el token guardado

    if (token == null) {
      throw Exception('Token not found');
    }

    Map<String, String> payload = {
      'oldEmail': Oldemail,
      'email': email,
    };

    final response = await http.put(
      Uri.parse('$baseUrl/MyAccount/change-email'),
      body: jsonEncode(payload),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      responseBody['success'] = true;
      return responseBody;
    } else {
      Map<String, dynamic> errorResponse = {
        'success': false,
        'message':
            jsonDecode(response.body)['message'] ?? 'Failed to update password',
      };
      return errorResponse;
    }
  }

  //------------------------------------------------//
  //-- Método para obtener los datos de la cuenta --//
  //------------------------------------------------//

  Future<List<Map<String, dynamic>>> getMicuenta() async {
    String? token = await getToken(); // Obtener el token guardado

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/MyAccount'),
      headers: {
        'Authorization':
            'Bearer $token', // Añadir el token al encabezado de autorización
      },
    );
    // print('Toke generado desde el get: $token');

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load mi cuenta');
    }
  }

  //--------------------------------------------//
  //-- Método para cambiar cedula del usuario --//
  //--------------------------------------------//

  Future<Map<String, dynamic>> actualizarCedula({
    required String Oldcedula,
    required String cedula,
  }) async {
    String? token = await getToken(); // Obtener el token guardado

    if (token == null) {
      throw Exception('Token not found');
    }

    Map<String, String> payload = {
      'oldCedula': Oldcedula,
      'cedula': cedula,
    };

    final response = await http.put(
      Uri.parse('$baseUrl/MyAccount/change-cedula'),
      body: jsonEncode(payload),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      responseBody['success'] = true;
      return responseBody;
    } else {
      Map<String, dynamic> errorResponse = {
        'success': false,
        'message':
            jsonDecode(response.body)['message'] ?? 'Failed to update cedula',
      };
      return errorResponse;
    }
  }

  //--------------------------------------------//
  //-- Método para cambiar Titulo del usuario --//
  //--------------------------------------------//

  Future<Map<String, dynamic>> actualizarTitulo({
    required String Oldtitulo,
    required String titulo,
  }) async {
    String? token = await getToken(); // Obtener el token guardado

    if (token == null) {
      throw Exception('Token not found');
    }

    Map<String, String> payload = {
      'oldTitulo': Oldtitulo,
      'titulo': titulo,
    };

    final response = await http.put(
      Uri.parse('$baseUrl/MyAccount/change-titulo'),
      body: jsonEncode(payload),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      responseBody['success'] = true;
      return responseBody;
    } else {
      Map<String, dynamic> errorResponse = {
        'success': false,
        'message':
            jsonDecode(response.body)['message'] ?? 'Failed to update titulo',
      };
      return errorResponse;
    }
  }

  //--------------------------------------------//
  //-- Método para cambiar Titulo del usuario --//
  //--------------------------------------------//

  Future<Map<String, dynamic>> actualizarInstitucion({
    required String Oldinstitucion,
    required String institucion,
  }) async {
    String? token = await getToken(); // Obtener el token guardado

    if (token == null) {
      throw Exception('Token not found');
    }

    Map<String, String> payload = {
      'oldInstitucion': Oldinstitucion,
      'institucion': institucion,
    };

    final response = await http.put(
      Uri.parse('$baseUrl/MyAccount/change-institucion'),
      body: jsonEncode(payload),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      responseBody['success'] = true;
      return responseBody;
    } else {
      Map<String, dynamic> errorResponse = {
        'success': false,
        'message': jsonDecode(response.body)['message'] ??
            'Failed to update institucion',
      };
      return errorResponse;
    }
  }

  //-----------------------------------------//
  //-- Método para cambiar Año del usuario --//
  //-----------------------------------------//

  Future<Map<String, dynamic>> actualizarYear({
    required String Oldyear,
    required int year,
  }) async {
    String? token = await getToken(); // Obtener el token guardado

    if (token == null) {
      throw Exception('Token not found');
    }

    Map<String, dynamic> payload = {
      'oldYear': Oldyear,
      'year': year.toString(), // Convertir el año a String
    };

    final response = await http.put(
      Uri.parse('$baseUrl/MyAccount/change-year'),
      body: jsonEncode(payload),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      responseBody['success'] = true;
      return responseBody;
    } else {
      Map<String, dynamic> errorResponse = {
        'success': false,
        'message':
            jsonDecode(response.body)['message'] ?? 'Failed to update year',
      };
      return errorResponse;
    }
  }

  //--------------------------------------------------------------------------//
  //--------------------------------------------------------------------------//
  //-------------------------- MODULO DE USUARIOS ----------------------------//
  //--------------------------------------------------------------------------//
  //--------------------------------------------------------------------------//

  //-------------------------------------------//
  //-- Método para obtener lista de usuarios --//
  //-------------------------------------------//

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
    // print('Toke generado desde el get: $token');

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load users');
    }
  }

  //----------------------------------//
  //-- Método para crear un usuario --//
  //----------------------------------//

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

    if (response.statusCode == 200) {
      // Usuario creado exitosamente, no es necesario hacer nada más aquí
      return;
    } else {
      throw Exception('Failed to create user');
    }
  }

  //----------------------------------------------//
  //-- Método para actualizar datos del usuario --//
  //----------------------------------------------//

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

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

  //-------------------------------------//
  //-- Método para eliminar un usuario --//
  //-------------------------------------//

  Future<void> deleteUser(int userId) async {
    String? token = await getToken(); // Obtener el token guardado

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/Users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Añadir el token al encabezado de autorización
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  //--------------------------------------------------------------------------//
  //--------------------------------------------------------------------------//
  //-------------------------- MODULO DE PACIENTES ---------------------------//
  //--------------------------------------------------------------------------//
  //--------------------------------------------------------------------------//

  //--------------------------------------------//
  //-- Método para obtener lista de pacientes --//
  //--------------------------------------------//

  Future<List<Map<String, dynamic>>> getPacientes() async {
    String? token = await getToken(); // Obtener el token guardado

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/Pacientes'),
      headers: {
        'Authorization':
            'Bearer $token', // Añadir el token al encabezado de autorización
      },
    );
    // print('Toke generado desde el get: $token');

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load pacientes');
    }
  }

  //-----------------------------------//
  //-- Método para crear un paciente --//
  //-----------------------------------//

  Future<void> createPaciente(Map<String, dynamic> pacienteData) async {
    String? token = await getToken(); // Obtener el token guardado

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/Pacientes'),
      body: jsonEncode(pacienteData),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Añadir el token al encabezado de autorización
      },
    );

    if (response.statusCode == 200) {
      // Usuario creado exitosamente, no es necesario hacer nada más aquí
      return;
    } else {
      throw Exception('Failed to create paciente');
    }
  }

  //-----------------------------------------------//
  //-- Método para actualizar datos del paciente --//
  //-----------------------------------------------//

  Future<void> updatePaciente(
      int pacienteId, Map<String, dynamic> newData) async {
    String? token = await getToken(); // Obtener el token guardado

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/Pacientes/$pacienteId'),
      body: jsonEncode(newData),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Añadir el token al encabezado de autorización
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update paciente');
    }
  }

  //-------------------------------------//
  //-- Método para eliminar un usuario --//
  //-------------------------------------//

  Future<void> deletePaciente(int PacienteId) async {
    String? token = await getToken(); // Obtener el token guardado

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/Pacientes/$PacienteId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Añadir el token al encabezado de autorización
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete paciente');
    }
  }

  //--------------------------------------------------------------------------//
  //--------------------------------------------------------------------------//
  //------------------ MODULO DE INVENTARIO DE MEDICAMENTO -------------------//
  //--------------------------------------------------------------------------//
  //--------------------------------------------------------------------------//

  //-----------------------------------------------//
  //-- Método para obtener lista de medicamentos --//
  //-----------------------------------------------//

  Future<List<Map<String, dynamic>>> getMedicamento() async {
    String? token = await getToken(); // Obtener el token guardado

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/Medicamento'),
      headers: {
        'Authorization':
            'Bearer $token', // Añadir el token al encabezado de autorización
      },
    );
    // print('Toke generado desde el get: $token');

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load medicamentos');
    }
  }

  //-----------------------------------------//
  //-- Método para ingresar un medicamento --//
  //-----------------------------------------//

  Future<void> createMedicamento(Map<String, dynamic> medicamentoData) async {
    String? token = await getToken(); // Obtener el token guardado

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/Medicamento'),
      body: jsonEncode(medicamentoData),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Añadir el token al encabezado de autorización
      },
    );

    if (response.statusCode != 200 || response.statusCode != 204) {
      // medicamento creado exitosamente, no es necesario hacer nada más aquí
      return;
    } else {
      throw Exception('Failed to create medicamento');
    }
  }

  //--------------------------------------------------//
  //-- Método para actualizar datos del medicamento --//
  //--------------------------------------------------//

  Future<void> updateMedicamento(
      int medicamentoId, Map<String, dynamic> newData) async {
    String? token = await getToken(); // Obtener el token guardado

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/Medicamento/$medicamentoId'),
      body: jsonEncode(newData),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Añadir el token al encabezado de autorización
      },
    );

    // print('medicamento actualizado: $medicamentoId');

    if (response.statusCode != 200) {
      throw Exception('Failed to update medicamento');
    }
  }

  //-----------------------------------------//
  //-- Método para eliminar un medicamento --//
  //-----------------------------------------//

  Future<void> deleteMedicamento(int medicamentoId) async {
    String? token = await getToken(); // Obtener el token guardado

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/Medicamento/$medicamentoId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Añadir el token al encabezado de autorización
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete medicamento');
    }
  }

  //---------------------------------------------//
  //-- Método para enviar el carrito de ventas --//
  //---------------------------------------------//

  Future<Map<String, dynamic>> enviarResumenVenta(
      List<Map<String, dynamic>> resumenVenta) async {
    String? token = await getToken();

    if (token == null) {
      throw Exception('Token not found');
    }

    Map<String, dynamic> payload = {
      'items': resumenVenta.map((item) {
        return {
          'id': item['id'].toString(),
          'cantidad': item['cantidad'],
        };
      }).toList(),
    };

    final response = await http.post(
      Uri.parse('$baseUrl/Medicamento/carrito'), // Reemplaza con tu endpoint
      body: jsonEncode(payload),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      responseBody['success'] = true;
      return responseBody;
    } else {
      Map<String, dynamic> errorResponse = {
        'success': false,
        'message':
            jsonDecode(response.body)['message'] ?? 'Failed to create sale',
      };
      return errorResponse;
    }
  }


  //------------------------------------------------------------------------------//
  //------------------------------------------------------------------------------//
  //------------------ MODULO DE INVENTARIO DE CONSULTA MEDICA -------------------//
  //------------------------------------------------------------------------------//
  //------------------------------------------------------------------------------//


  //-----------------------------------//
  //-- Método para crear un paciente --//
  //-----------------------------------//

Future<void> createReceta(Map<String, dynamic> recetaData) async {
    String? token = await getToken(); // Obtener el token guardado

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/Recetas'),
      body: jsonEncode(recetaData),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Añadir el token al encabezado de autorización
      },
    );

    if (response.statusCode == 200) {
      // Usuario creado exitosamente, no es necesario hacer nada más aquí
      return;
    } else {
      throw Exception('Failed to create paciente');
    }
  }

}
