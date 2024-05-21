import 'package:flutter/material.dart';

import 'package:labvymar/Views/Navbar_widgets.dart';
import 'package:labvymar/conectionmysql.dart';

//----------------------------------------------------------//
//----------------- Clase de CuentaUser --------------------//
//----------------------------------------------------------//

class CuentaUser extends StatelessWidget {
  CuentaUser({Key? key}) : super(key: key);

  final APIService apiService = APIService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 870;

    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
          leading: isLargeScreen
              ? null
              : IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, 'home_admin');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Image.asset(
                      'assets/VYMAR_logo.png',
                      height: 60,
                      width: 60,
                    ),
                  ),
                ),
                if (isLargeScreen)
                  Expanded(child: NavBarWidgets.navBarItems(context))
              ],
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: NavBarWidgets.profileIcon(context)),
            )
          ],
        ),
        drawer: isLargeScreen ? null : NavBarWidgets.drawer(context),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: apiService.getMicuenta(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error al cargar los datos'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay datos disponibles'));
            } else {
              final user = snapshot.data!.first;

              return Container(
                color: Colors.white,
                child: Center(
                  child: Container(
                    width: 420,
                    margin: const EdgeInsets.only(top: 25),
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Información de la cuenta",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 50),
                        _nameRow(user['name'] ?? 'Nombre no disponible'),
                        const SizedBox(height: 25),
                        _buildInfoRow(
                          "Correo electrónico",
                          user['email'] ?? 'Correo no disponible',
                          context,
                        ),
                        const SizedBox(height: 15),
                        _buildInfoRow(
                          "Contraseña",
                          "********",
                          context,
                        ),
                        const SizedBox(height: 15),
                        _buildInfoRow(
                          "Cédula",
                          user['cedula'] ?? 'Cedula no disponible',
                          context,
                        ),
                        const SizedBox(height: 15),
                        _buildInfoRow(
                          "Año",
                          user['year'] ?? 'Año no disponible',
                          context,
                        ),
                        const SizedBox(height: 15),
                        _buildInfoRow(
                          "Título",
                          user['titulo'] ?? 'Titulo no disponible',
                          context,
                        ),
                        const SizedBox(height: 15),
                        _buildInfoRow(
                          "Institución Educativa",
                          user['institucion'] ?? 'Institución no disponible',
                          context,
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _nameRow(String label) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, dynamic value, BuildContext context) {
    String displayValue = value.toString(); // Convertir el valor a String
    return Builder(
      builder: (BuildContext context) {
        return Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                displayValue, // Utilizar el valor convertido
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Color(0xFF094293),
              ),
              onPressed: () {
                // Implementar la lógica de edición aquí
                if (label == "Correo electrónico") {
                  _showEditEmailDialog(context, displayValue);
                } else if (label == "Número de teléfono") {
                  _showEditPhoneDialog(context, displayValue);
                } else if (label == "Contraseña") {
                  _showEditPasswordDialog(context, displayValue);
                } else if (label == "Título") {
                  _showEditTituloDialog(context, displayValue);
                } else if (label == "Cédula") {
                  _showEditCedulaDialog(context, displayValue);
                } else if (label == "Institución Educativa") {
                  _showEditInstitucionDialog(context, displayValue);
                } else if (label == "Año") {
                  _showEditYearDialog(context, displayValue);
                }
              },
            ),
          ],
        );
      },
    );
  }

  //--------------------------------------------------------------//
  //-------- ShowDialog de la opcion de Editar el email  ---------//
  //--------------------------------------------------------------//

  void _showEditEmailDialog(BuildContext context, String currentValue) {
    TextEditingController _emailController =
        TextEditingController(text: currentValue);
    TextEditingController _newEmailController = TextEditingController();
    TextEditingController _confirmEmailController = TextEditingController();
    bool _isEmailValid = false;

    // Función para validar el correo electrónico
    void _validateEmail(String value) {
      // Utilizamos una expresión regular para validar el formato del correo electrónico
      bool isValidFormat =
          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
      // Actualizamos el estado de la validez del correo electrónico
      _isEmailValid = isValidFormat &&
          _newEmailController.text == _confirmEmailController.text;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text("Editar correo electrónico"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _emailController,
                    enabled: false,
                    decoration: const InputDecoration(
                      hintText: "Correo electrónico actual",
                    ),
                  ),
                  TextField(
                    controller: _newEmailController,
                    onChanged: (value) {
                      setState(() {
                        _validateEmail(value);
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Ingrese el nuevo correo electrónico",
                    ),
                  ),
                  TextField(
                    controller: _confirmEmailController,
                    onChanged: (value) {
                      setState(() {
                        _validateEmail(value);
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Confirme el nuevo correo electrónico",
                    ),
                  ),
                  if (!_isEmailValid)
                    const Padding(
                      padding: EdgeInsets.only(top: 25.0),
                      child: Text(
                        "Los correos electrónicos deben coincidir y tener un formato válido.",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo
                  },
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: _isEmailValid
                      ? () async {
                          if (_newEmailController.text !=
                              _confirmEmailController.text) {
                            // Los correos electrónicos no coinciden
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'Los correos electrónicos no coinciden.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }

                          try {
                            // Realizar la actualización del correo electrónico
                            Map<String, dynamic> response =
                                await apiService.actualizarEmail(
                              Oldemail: _emailController.text,
                              email: _newEmailController.text,
                            );

                            if (response['success'] == true) {
                              // Actualización exitosa
                              Navigator.of(context).pop(); // Cerrar el diálogo

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Email actualizado exitosamente."),
                                ),
                              );
                            } else {
                              // Mostrar un diálogo de error con el mensaje del servidor
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Inténtelo nuevamente'),
                                  content: Text(response['message'] ??
                                      'Error desconocido'),
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
                                title: Text('Error'),
                                content: Text(
                                    'Error al actualizar el correo electrónico.'),
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
                      : null,
                  style: ButtonStyle(
                    backgroundColor: _isEmailValid
                        ? MaterialStateProperty.all<Color>(
                            const Color(0xFF094293))
                        : MaterialStateProperty.all<Color>(
                            const Color(0xFFBBDEFB)),
                  ),
                  child: const Text(
                    "Guardar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //-----------------------------------------------------------------//
  //-------- ShowDialog de la opcion de Editar el password  ---------//
  //-----------------------------------------------------------------//

  void _showEditPasswordDialog(BuildContext context, String currentValue) {
    TextEditingController _currentPasswordController = TextEditingController();
    TextEditingController _newPasswordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();

    bool _isPasswordVisible = false;
    bool _isPasswordVisible1 = false;
    bool _isPasswordVisible2 = false;
    bool _isPasswordValid = false;

    // Función para validar si la contraseña cumple con los requisitos
    void _validatePassword(String value) {
      if (value.length >= 8) {
        _isPasswordValid = true;
      } else {
        _isPasswordValid = false;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white, // Fondo blanco del AlertDialog
              title: const Text("Editar contraseña"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _currentPasswordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Contraseña actual',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: !_isPasswordVisible1,
                    onChanged: (value) {
                      setState(() {
                        _validatePassword(value);
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Nueva Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible1
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible1 = !_isPasswordVisible1;
                          });
                        },
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isPasswordVisible2,
                    onChanged: (value) {
                      setState(() {
                        _validatePassword(value);
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Confirmar nueva contraseña',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible2
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible2 = !_isPasswordVisible2;
                          });
                        },
                      ),
                    ),
                  ),
                  if (!_isPasswordValid)
                    const Text(
                      "\nRequisitos de la contraseña:\n- Mínimo de 8 caracteres",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo
                  },
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: _isPasswordValid
                      ? () async {
                          // Verificar si las contraseñas coinciden
                          if (_newPasswordController.text ==
                              _confirmPasswordController.text) {
                            try {
                              // Realizar la actualización de la contraseña
                              Map<String, dynamic> response =
                                  await apiService.actualizarPassword(
                                Oldpassword: _currentPasswordController.text,
                                password: _newPasswordController.text,
                              );

                              if (response['success'] == true) {
                                // Contraseña actualizada con éxito, redirigir o mostrar un mensaje de éxito
                                Navigator.of(context)
                                    .pop(); // Cerrar el diálogo
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Contraseña actualizada exitosamente."),
                                  ),
                                );
                              } else {
                                // Mostrar un diálogo de error con el mensaje del servidor
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Inténtalo nuevamente'),
                                    content: Text(response['message'] ??
                                        'Error desconocido'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK'),
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
                                  title: const Text('Inténtalo nuevamente'),
                                  content: const Text(
                                      'La contraseña actual es incorrecta.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else {
                            // Mostrar mensaje si las contraseñas no coinciden
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Error'),
                                content:
                                    const Text("Las contraseñas no coinciden."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: _isPasswordValid
                        ? MaterialStateProperty.all<Color>(const Color(
                            0xFF094293)) // Color del botón de guardar
                        : MaterialStateProperty.all<Color>(const Color(
                            0xFFBBDEFB)), // Color de botón desactivado
                  ),
                  child: const Text(
                    "Guardar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //-----------------------------------------------------------------//
  //-------- ShowDialog de la opcion de Editar el telefono  ---------//
  //-----------------------------------------------------------------//

  void _showEditPhoneDialog(BuildContext context, String currentValue) {
    TextEditingController _phoneController =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Verifica tu número de teléfono celular."),
          content: TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              hintText: "Ingrese el nuevo número de teléfono celular",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes realizar la lógica para guardar el nuevo número de teléfono celular
                String newPhone = _phoneController.text;
                // Por ahora, simplemente imprimo el nuevo número de teléfono celular
                print("Nuevo número de teléfono celular: $newPhone");
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFF094293)) // Color del botón de guardar
                  ),
              child: const Text(
                "Guardar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  //---------------------------------------------------------------//
  //-------- ShowDialog de la opcion de Editar el Titulo  ---------//
  //---------------------------------------------------------------//

  void _showEditTituloDialog(BuildContext context, String titulo) {
    TextEditingController _tituloController =
        TextEditingController(text: titulo);
    TextEditingController _newTituloController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Verifica tu título"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tituloController,
                enabled: false, // Bloquea la edición del título antiguo
                decoration: const InputDecoration(
                  hintText: "Título",
                ),
              ),
              TextField(
                controller: _newTituloController,
                decoration: const InputDecoration(
                  hintText: "Modifica tu título",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                String oldTitulo = _tituloController.text;
                String newTitulo = _newTituloController.text;
                try {
                  Map<String, dynamic> response =
                      await APIService().actualizarTitulo(
                    Oldtitulo: oldTitulo,
                    titulo: newTitulo,
                  );
                  if (response['success']) {
                    // Manejar el éxito, por ejemplo, mostrar un mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Título actualizado correctamente')),
                    );
                    Navigator.of(context).pop(); // Cerrar el diálogo

                    Navigator.pushReplacementNamed(context, 'Cuenta');
                  } else {
                    // Manejar el error, por ejemplo, mostrar un mensaje de error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response['message'])),
                    );
                  }
                } catch (e) {
                  // Manejar errores de conexión u otros errores
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al actualizar el título')),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xFF094293),
                ), // Color del botón de guardar
              ),
              child: const Text(
                "Guardar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  //------------------------------------------------------------//
  //-------- ShowDialog de la opcion de Editar Cedula  ---------//
  //------------------------------------------------------------//

  void _showEditCedulaDialog(BuildContext context, String cedula) {
    TextEditingController _cedulaController =
        TextEditingController(text: cedula);
    TextEditingController _newCedulaController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Verifica tu cédula"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _cedulaController,
                enabled: false, // Bloquea la edición de la cédula antigua
                decoration: const InputDecoration(
                  hintText: "Cédula",
                ),
              ),
              TextField(
                controller: _newCedulaController,
                decoration: const InputDecoration(
                  hintText: "Modifica tu cédula",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                String oldCedula = _cedulaController.text;
                String newCedula = _newCedulaController.text;
                try {
                  Map<String, dynamic> response =
                      await APIService().actualizarCedula(
                    Oldcedula: oldCedula,
                    cedula: newCedula,
                  );
                  if (response['success']) {
                    // Manejar el éxito, por ejemplo, mostrar un mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Cédula actualizada correctamente')),
                    );
                    Navigator.of(context).pop(); // Cerrar el diálogo

                    Navigator.pushReplacementNamed(context, 'Cuenta');
                  } else {
                    // Manejar el error, por ejemplo, mostrar un mensaje de error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response['message'])),
                    );
                  }
                } catch (e) {
                  // Manejar errores de conexión u otros errores
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al actualizar la cédula')),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xFF094293),
                ), // Color del botón de guardar
              ),
              child: const Text(
                "Guardar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  //-----------------------------------------------------------------//
  //-------- ShowDialog de la opcion de Editar Institución  ---------//
  //-----------------------------------------------------------------//

  void _showEditInstitucionDialog(BuildContext context, String institucion) {
    TextEditingController _institucionController =
        TextEditingController(text: institucion);
    TextEditingController _newInstitucionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Verifica tu institución"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _institucionController,
                enabled: false, // Bloquea la edición de la institución antigua
                decoration: const InputDecoration(
                  hintText: "Institución",
                ),
              ),
              TextField(
                controller: _newInstitucionController,
                decoration: const InputDecoration(
                  hintText: "Modifica tu Institución",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                String oldInstitucion = _institucionController.text;
                String newInstitucion = _newInstitucionController.text;
                try {
                  Map<String, dynamic> response =
                      await APIService().actualizarInstitucion(
                    Oldinstitucion: oldInstitucion,
                    institucion: newInstitucion,
                  );
                  if (response['success']) {
                    // Manejar el éxito, por ejemplo, mostrar un mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Institución actualizada correctamente')),
                    );
                    Navigator.of(context).pop(); // Cerrar el diálogo

                    Navigator.pushReplacementNamed(context, 'Cuenta');
                  } else {
                    // Manejar el error, por ejemplo, mostrar un mensaje de error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response['message'])),
                    );
                  }
                } catch (e) {
                  // Manejar errores de conexión u otros errores
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Error al actualizar la institución')),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xFF094293),
                ), // Color del botón de guardar
              ),
              child: const Text(
                "Guardar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  //---------------------------------------------------------//
  //-------- ShowDialog de la opcion de Editar Año  ---------//
  //---------------------------------------------------------//

  void _showEditYearDialog(BuildContext context, String year) {
    TextEditingController _yearController = TextEditingController(text: year);
    TextEditingController _newYearController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Verifica tu año"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _yearController,
                enabled: false, // Bloquea la edición del año antiguo
                decoration: const InputDecoration(
                  hintText: "Año",
                ),
              ),
              TextField(
                controller: _newYearController,
                keyboardType:
                    TextInputType.number, // Teclado numérico para el nuevo año
                decoration: const InputDecoration(
                  hintText: "Modifica el año",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                String oldYear = _yearController.text;
                int newYear = int.tryParse(_newYearController.text) ??
                    0; // Convertir a int, 0 si no se puede convertir
                try {
                  Map<String, dynamic> response =
                      await APIService().actualizarYear(
                    Oldyear: oldYear,
                    year: newYear,
                  );
                  if (response['success']) {
                    // Manejar el éxito, por ejemplo, mostrar un mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Año actualizado correctamente')),
                    );
                    Navigator.of(context).pop(); // Cerrar el diálogo

                    Navigator.pushReplacementNamed(context, 'Cuenta');
                  } else {
                    // Manejar el error, por ejemplo, mostrar un mensaje de error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response['message'])),
                    );
                  }
                } catch (e) {
                  // Manejar errores de conexión u otros errores
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al actualizar el año')),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xFF094293),
                ), // Color del botón de guardar
              ),
              child: const Text(
                "Guardar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
