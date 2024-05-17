import 'dart:js';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:labvymar/Views/Navbar_widgets.dart';
import 'package:labvymar/conectionmysql.dart';

//-------------------------------------------------------------//
//----------------- Clase de AdminUsuarios --------------------//
//-------------------------------------------------------------//

class AdminUsuarios extends StatefulWidget {
  AdminUsuarios({super.key});

  @override
  State<AdminUsuarios> createState() => _AdminUsuariosState();
}

//-------------------------------------------------------------//
//-------------- Clase de _AdminUsuariosState -----------------//
//-------------------------------------------------------------//

class _AdminUsuariosState extends State<AdminUsuarios> {
  final APIService apiService = APIService();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //-------------------------------------------------------------//
  //-------- Widget que hace referencia al navbar y body --------//
  //-------------------------------------------------------------//

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 870;

    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,

        //------------------------//
        //-------- Navbar --------//
        //------------------------//

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

        //------------------------//
        //--------- Body ---------//
        //------------------------//

        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(
                16.0), // Agrega un padding en todos los lados
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const UserManagementScreen(),
                _buildUserDataTable(), // Tu DataTable aquí
              ],
            ),
          ),
        ),
      ),
    );
  }

  //-------------------------------------------------------------//
  //-------- Widget de la tabla de la lista de usuarios ---------//
  //-------------------------------------------------------------//

  Widget _buildUserDataTable() {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        double screenWidth = MediaQuery.of(context).size.width;
        double columnSpacing = screenWidth * 0.05;
        double fontSize = screenWidth * 0.020;
        double fontSizeEdit = screenWidth * 0.015;

        return FutureBuilder<List<DataRow>>(
          future: _userDataRows(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child:
                    CircularProgressIndicator(), // Muestra un indicador de carga mientras se espera
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                    'Error: ${snapshot.error}'), // Muestra un mensaje de error si ocurre algún problema
              );
            } else {
              return DataTable(
                columnSpacing: columnSpacing,
                columns: [
                  DataColumn(
                    label: Text(
                      'Nombre',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Correo',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Rol',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Editar | Eliminar ',
                      style: TextStyle(
                        fontSize: fontSizeEdit,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                rows: snapshot
                    .data!, // Utiliza los datos devueltos por _userDataRows
              );
            }
          },
        );
      },
    );
  }

  //------------------------------------------------------------//
  //-------- Lista de usuarios que se obtiene del API  ---------//
  //------------------------------------------------------------//

  Future<List<DataRow>> _userDataRows(BuildContext context) async {
    final List<Map<String, dynamic>> users = await apiService.getUsers();

    final double screenWidth2 = MediaQuery.of(context).size.width;
    double fontSize = screenWidth2 * 0.018;

    return users.map((user) {
      return DataRow(cells: [
        DataCell(Text(
          user['name'], // Acceder a 'name' en minúsculas
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          user['email'], // Acceder a 'email' en minúsculas
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          user['role']
              .toString(), // Acceder a 'role' en minúsculas y convertirlo a String
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: const Color(0xFF094293),
                size: fontSize,
              ),
              onPressed: () {
                // Obtener los datos relevantes de la fila seleccionada
                int userId = user['userId'];
                String name = user['name'];
                String email = user['email'];

                // int role = user['role'];

                // Llamar al método para mostrar el diálogo de edición
                _showEditUserDialog(context, userId, name, email);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.person_off_sharp,
                color: Colors.red,
                size: fontSize,
              ),
              onPressed: () {
                // Lógica para eliminar el usuario

                // Obtener los datos relevantes de la fila seleccionada
                int userId = user['userId'];
                String name = user['name'];

                _showDeleteUserDialog(context, userId, name);
              },
            ),
          ],
        )),
      ]);
    }).toList();
  }
}

//-------------------------------------------------------------//
//-------- ShowDialog de la opcion de Editar Usuario  ---------//
//-------------------------------------------------------------//

void _showEditUserDialog(
    BuildContext context, int userId, String name, String email) {
  final Map<String, int> roleMap = {
    'Selecciona un rol': -1,
    'Doctor': 3,
    'Médico Especialista': 5,
    'Recepcionista': 4,
  };

  int? selectedRole;

  TextEditingController nameController = TextEditingController(text: name);
  TextEditingController emailController = TextEditingController(text: email);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              'Editar usuario',
              style: TextStyle(color: Colors.black),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Nombre'),
                    onChanged: (value) {
                      // Aquí puedes realizar alguna acción cuando cambia el valor del TextField
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Rol:',
                    style: TextStyle(color: Colors.black),
                  ),
                  DropdownButtonFormField<int>(
                    value: selectedRole,
                    decoration: const InputDecoration(labelText: 'Rol'),
                    items: roleMap.entries.map((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.value,
                        child: Text(entry.key),
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      setState(() {
                        selectedRole = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Validar que se haya seleccionado un rol válido
                  if (selectedRole != null && selectedRole != -1) {
                    String newName = nameController.text;
                    String sameEmail = emailController.text;
                    int newRole = selectedRole!;

                    try {
                      // Llamar al método updateUser de APIService para actualizar el usuario
                      await APIService().updateUser(userId, {
                        'name': newName,
                        'role': newRole,
                        'email': sameEmail
                      });

                      // Mostrar mensaje de éxito
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Usuario actualizado con exito.'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                      Navigator.of(context).pop(); // Cerrar el diálogo
                      Navigator.pushReplacementNamed(
                          context, 'AdministrarUsuarios');
                    } catch (e) {
                      // Manejar cualquier error que pueda ocurrir durante la actualización
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content:
                                Text('Hubo un error al actualizar el usuario.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Aceptar'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    // Mostrar alerta si no se selecciona un rol válido
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Intentalo nuevamente'),
                          content: Text('Por favor selecciona un rol válido.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF094293),
                ),
                child: Text(
                  'Guardar',
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

//---------------------------------------------------------------//
//-------- ShowDialog de la opcion de Eliminar Usuario  ---------//
//---------------------------------------------------------------//

void _showDeleteUserDialog(BuildContext context, int userId, String name) {
  final APIService apiService = APIService();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(
                'Seguro que quiere dar de baja al usuario seleccionado del sistema?\n\n$name'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Aquí puedes realizar la lógica para eliminar el usuario
                  try {
                    // Llamar al método updateUser de APIService para actualizar el usuario
                    await apiService.deleteUser(userId);

                    // Mostrar mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Usuario eliminado con exito.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                    Navigator.of(context).pop(); // Cerrar el diálogo
                    Navigator.pushReplacementNamed(
                        context, 'AdministrarUsuarios');
                  } catch (e) {
                    // Manejar cualquier error que pueda ocurrir durante la actualización
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content:
                              Text('Hubo un error al eliminar al usuario.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Color de fondo rojo
                ),
                child: Text(
                  'Eliminar',
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

//-----------------------------------//
//--------  Header del body ---------//
//-----------------------------------//

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

//------------------------------------------------------//
//-------- Clase del boton de agregar usuario  ---------//
//------------------------------------------------------//

class _UserManagementScreenState extends State<UserManagementScreen> {
  final APIService apiService = APIService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Administrar Usuarios',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _showAddUserDialog(context);
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFF094293)),
              ),
              icon: const Icon(
                Icons.person_add_alt_sharp,
                color: Colors.white,
                size: 30,
              ),
              label: const Text(
                'Agregar Usuario',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 40),
            // Tu DataTable aquí
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------//
  //-------- ShowDialog del boton de Agregar Usuario  ---------//
  //-----------------------------------------------------------//

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Mapa para asociar los roles de texto con valores numéricos
        final Map<String, int> roleMap = {
          'Selecciona un rol': -1,
          'Doctor': 3,
          'Médico Especialista': 5,
          'Recepcionista': 4,
        };

        // Variable para almacenar el rol seleccionado
        int? selectedRole;

        // Función para verificar si los campos están completos y el rol ha sido seleccionado
        List<String> validateForm() {
          List<String> errors = [];
          bool isEmailValid = _emailController.text.isNotEmpty &&
              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(_emailController.text);
          if (_nameController.text.isEmpty) {
            errors.add('El nombre es requerido.\n');
          }
          if (!isEmailValid) {
            errors.add(
                'El correo electrónico debe cumplir con el formato válido.\n');
          }
          if (_passwordController.text.isEmpty) {
            errors.add('La contraseña es requerida.\n');
          } else if (_passwordController.text.length < 8) {
            errors.add('La contraseña debe tener al menos 8 caracteres.\n');
          }
          if (selectedRole == null || selectedRole == 0) {
            errors.add('Debe seleccionar un rol.');
          }
          return errors;
        }

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Center(
                child: Text('Nuevo usuario'),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                    DropdownButtonFormField<int>(
                      value: selectedRole,
                      decoration: const InputDecoration(labelText: 'Rol'),
                      items: roleMap.entries.map((entry) {
                        return DropdownMenuItem<int>(
                          value: entry.value,
                          child: Text(entry.key),
                        );
                      }).toList(),
                      onChanged: (int? value) {
                        setState(() {
                          selectedRole = value;
                        });
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Correo'),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration:
                          const InputDecoration(labelText: 'Contraseña'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Limpiar los campos al hacer clic en "Cancelar"
                    _nameController.clear();
                    _emailController.clear();
                    _passwordController.clear();
                    selectedRole = null; // Limpiar la selección del rol
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Validar el formulario
                    List<String> errors = validateForm();
                    if (errors.isEmpty) {
                      // Si no hay errores, agregar el usuario
                      // Lógica para agregar el usuario...

                      // Obtener los datos del usuario del formulario
                      String name = _nameController.text;
                      String email = _emailController.text;
                      String password = _passwordController.text;
                      int role = selectedRole!;

                      // Crear un nuevo usuario con los datos recopilados
                      Map<String, dynamic> userData = {
                        'name': name,
                        'email': email,
                        'role': role,
                        'password': password,
                      };

                      try {
                        // Llamar al método createUser de APIService
                        await apiService.createUser(userData);

                        // Si la creación del usuario tiene éxito, limpiar los campos y cerrar el diálogo
                        _nameController.clear();
                        _emailController.clear();
                        _passwordController.clear();
                        selectedRole = null;

                        // Mostrar un mensaje de éxito (puedes agregar esto si lo deseas)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Usuario creado exitosamente'),
                            duration: Duration(seconds: 3),
                          ),
                        );

                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(
                            context, 'AdministrarUsuarios');
                      } catch (e) {
                        // Si hay un error al crear el usuario, mostrar un mensaje de error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al crear usuario: $e'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    } else {
                      // Si hay errores, mostrar el diálogo de alerta con los mensajes de error
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: errors.map((error) {
                                return Text(
                                  error,
                                  style: TextStyle(color: Colors.red),
                                );
                              }).toList(),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Aceptar'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFF094293),
                    ),
                  ),
                  child: const Text(
                    'Agregar',
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
}
