import 'package:flutter/material.dart';
import 'package:labvymar/Views/recoverpass.dart';
import 'package:labvymar/conectionmysql.dart';

class CambiarPassword extends StatelessWidget {
  const CambiarPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    GlobalKey<FormState> _formKey =
        GlobalKey<FormState>(); // Crea la clave del formulario

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: isSmallScreen
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Logo(),
                  _FormContent(
                      formKey: _formKey), // Pasa la clave del formulario
                ],
              )
            : Container(
                color: Colors.white,
                padding: const EdgeInsets.all(32.0),
                constraints: const BoxConstraints(maxWidth: 800),
                child: Row(
                  children: [
                    Expanded(child: _Logo()),
                    Expanded(
                      child: Center(
                          child: _FormContent(
                              formKey:
                                  _formKey)), // Pasa la clave del formulario
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

//---------------------------------------//
//----------- Clase de logo -------------//
//---------------------------------------//

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 700;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: isSmallScreen ? 200 : 300,
          height: isSmallScreen ? 200 : 300,
          child: Image.asset('assets/VYMAR.png'),
        ),
      ],
    );
  }
}

//----------------------------------------------------------------//
//----------- Clase Formulario de cambiar contraseña -------------//
//----------------------------------------------------------------//

class _FormContent extends StatefulWidget {
  final GlobalKey<FormState>
      formKey; // Agrega la clave del formulario como argumento

  const _FormContent({Key? key, required this.formKey}) : super(key: key);

  @override
  __FormContentState createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final APIService apiService = APIService();

  String Oldpassword = '';
  String password = '';

  bool _isPasswordVisible = false;
  bool _isPasswordVisible1 = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      constraints: const BoxConstraints(maxWidth: 310),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Restablece tu contraseña',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Form(
            key: widget.formKey, // Usar la clave del formulario
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  onChanged: (value) {
                    Oldpassword = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Favor de ingresar la contraseña actual';
                    }
                    return null;
                  },
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Contraseña Actual',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                _gap(),
                TextFormField(
                  onChanged: (value) {
                    password = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Favor de ingresar la nueva contraseña';
                    }
                    if (value.length < 8) {
                      return 'La nueva contraseña debe tener al menos 8 caracteres';
                    }
                    return null;
                  },
                  obscureText: !_isPasswordVisible1,
                  decoration: InputDecoration(
                    labelText: 'Nueva Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible1
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible1 = !_isPasswordVisible1;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          _gap(),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF094293),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: () async {
                if (widget.formKey.currentState!.validate()) {
                  try {
                    // Realizar la actualización de la contraseña
                    Map<String, dynamic> response =
                        await apiService.actualizarPassword(
                      Oldpassword: Oldpassword,
                      password: password,
                    );

                    if (response['success'] == true) {
                      // Inicio de sesión exitoso, redirigir a la página de inicio de administrador
                      Navigator.pushReplacementNamed(context, 'home_admin');
                    } else {
                      // Mostrar un diálogo de error con el mensaje del servidor
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Error'),
                          content:
                              Text(response['message'] ?? 'Error desconocido'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  } catch (e) {
                    // Manejar cualquier error que pueda ocurrir durante la actualización
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Inténtalo nuevamente'),
                        content: Text('La contraseña actual es incorrecta.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Aceptar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          _gap(),

          //-------------------------------------------------------------//
          //----------- Hyperbinculo a recuperar contraseña -------------//
          //-------------------------------------------------------------//
          SizedBox(
            width: double.infinity,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  // Llama al método cerrarSesion para eliminar el token
                  await apiService.cerrarSesion();

                  // Redirige directamente a la página de inicio de sesión
                  Navigator.pushReplacementNamed(context, 'login');
                },
                child: const Material(
                  color: Color.fromARGB(0, 0, 0, 0),
                  child: Center(
                    // Centra el texto
                    child: Text(
                      'Regresar a Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(
                            0xFF094293), // Cambia el color para que parezca un enlace
                        decoration: TextDecoration
                            .underline, // Agrega subrayado al texto
                        decorationThickness:
                            2.0, // Ajusta el grosor de la línea de subrayado
                        decorationColor: const Color(
                            0xFF094293), // Color de la línea de subrayado
                        decorationStyle: TextDecorationStyle
                            .solid, // Estilo de la línea de subrayado
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Resto del código
        ],
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
