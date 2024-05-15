import 'dart:js';

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:labvymar/Views/Navbar_widgets.dart';
import 'package:labvymar/conectionmysql.dart';

class AdminUsuarios extends StatefulWidget {
  AdminUsuarios({super.key});

  @override
  State<AdminUsuarios> createState() => _AdminUsuariosState();
}

class _AdminUsuariosState extends State<AdminUsuarios> {
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
                      'ID',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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

  Future<List<DataRow>> _userDataRows(BuildContext context) async {
    final List<Map<String, dynamic>> users = await apiService.getUsers();

    final double screenWidth2 = MediaQuery.of(context).size.width;
    double fontSize = screenWidth2 * 0.018;

    return users.map((user) {
      return DataRow(cells: [
        DataCell(Text(
          user['userId'].toString(), // Convertir el userId a String
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          user['name'], // Acceder a 'name' en minúsculas
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          user['email'], // Acceder a 'email' en minúsculas
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          user['role'], // Acceder a 'role' en minúsculas
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
                // Lógica para editar el usuario
                _showEditUserDialog(context, user['name'], user['role']);
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
                _showDeleteUserDialog(context, user['name']);
              },
            ),
          ],
        )),
      ]);
    }).toList();
  }
}

void _showEditUserDialog(
    BuildContext context, String name, String currentRole) {
  List<String> roles = ['Doctor', 'Medico Especialista', 'Recepcionista'];
  String selectedRole = currentRole;
  TextEditingController nameController = TextEditingController(text: name);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Colors.white, // Establecer el fondo blanco
            title: Text('Editar usuario',
                style: TextStyle(color: Colors.black)), // Color del título
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinear a la izquierda
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Nombre'),
                    onChanged: (value) {
                      // Aquí puedes realizar alguna acción cuando cambia el valor del TextField
                    },
                  ),
                  SizedBox(height: 20),
                  Text('Rol:',
                      style: TextStyle(
                          color: Colors.black)), // Color del texto del rol
                  DropdownButton<String>(
                    value: selectedRole,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedRole = newValue!;
                      });
                    },
                    items: roles.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar',
                    style: TextStyle(
                        color: Colors
                            .black)), // Color del texto del botón Cancelar
              ),
              ElevatedButton(
                onPressed: () {
                  // Aquí puedes realizar la lógica para guardar los cambios del rol y del nombre
                  String newName = nameController.text;
                  String newRole = selectedRole;
                  print('El nuevo nombre es: $newName');
                  print('El nuevo rol es: $newRole');
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF094293), // Color de fondo rojo
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

void _showDeleteUserDialog(BuildContext context, String name) {
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
                onPressed: () {
                  // Aquí puedes realizar la lógica para eliminar el usuario
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

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _selectedRole = TextEditingController();

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

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? selectedRole; // Variable para almacenar el rol seleccionado

        // Función para verificar si los campos están completos y el rol ha sido seleccionado
        bool isFormValid() {
          bool isEmailValid = _emailController.text.isNotEmpty &&
              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(_emailController.text);
          return _nameController.text.isNotEmpty &&
              _emailController.text.isNotEmpty &&
              isEmailValid &&
              selectedRole != null;
        }

        // Función para validar el formato del correo electrónico
        String? validateEmail(String? value) {
          if (value == null || value.isEmpty) {
            return 'El correo electrónico es requerido.';
          }
          // Expresión regular para validar el formato del correo electrónico
          bool isValidEmail =
              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
          if (!isValidEmail) {
            return 'El correo electrónico debe cumplir con el formato válido.';
          }
          return null; // Retorna null si la validación es exitosa
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
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Correo'),
                      validator:
                          validateEmail, // Validación del correo electrónico
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        // Mostrar mensaje de error si la validación falla
                        _emailController.text.isNotEmpty &&
                                !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(_emailController.text)
                            ? 'El correo electrónico debe cumplir con el formato válido.'
                            : '',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: const InputDecoration(labelText: 'Rol'),
                      items: <String>[
                        'Doctor',
                        'Medico Especialista',
                        'Recepcionista'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
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
                    // Limpiar los campos al hacer clic en "Cancelar"
                    _nameController.clear();
                    _emailController.clear();
                    selectedRole = null; // Limpiar la selección del rol
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed:
                      isFormValid() // Habilita el botón solo si el formulario es válido
                          ? () {
                              // Aquí puedes realizar la lógica para agregar el usuario con los datos ingresados
                              // por ejemplo, puedes acceder a los valores con _nameController.text, _emailController.text, selectedRole
                              // y luego cerrar el dialogo con Navigator.of(context).pop();
                              // Limpiar los campos después de agregar el usuario
                              _nameController.clear();
                              _emailController.clear();
                              selectedRole =
                                  null; // Limpiar la selección del rol
                              Navigator.of(context).pop();
                            }
                          : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      isFormValid()
                          ? const Color(0xFF094293)
                          : const Color(0xFFBBDEFB),
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
