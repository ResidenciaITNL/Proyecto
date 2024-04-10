import 'package:flutter/material.dart';
import 'package:labvymar/Views/ConsultaMedica.dart';
import 'package:labvymar/Views/Cuenta.dart';
import 'package:labvymar/Views/EstudioMedico.dart';
import 'package:labvymar/Views/InventarioMedicamento.dart';
import 'package:labvymar/Views/Recepcion.dart';
import 'package:labvymar/Views/login.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AdminUsuarios extends StatelessWidget {
  AdminUsuarios({super.key});

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
                if (isLargeScreen) Expanded(child: _navBarItems(context))
              ],
            ),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: _ProfileIcon()),
            )
          ],
        ),
        drawer: isLargeScreen ? null : _drawer(context),
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

  Widget _drawer(BuildContext context) => Drawer(
        child: Container(
          color: Colors.white, // Añade un fondo blanco
          child: ListView(
            children: _menuItems
                .map(
                  (item) => ListTile(
                    onTap: () {
                      _handleMenuTap(context, item);
                    },
                    title: Text(item),
                  ),
                )
                .toList(),
          ),
        ),
      );

  Widget _navBarItems(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _menuItems
            .map(
              (item) => InkWell(
                onTap: () {
                  _handleMenuTap(context, item);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 16),
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            )
            .toList(),
      );

  void _handleMenuTap(BuildContext context, String menuItem) {
    switch (menuItem) {
      case 'Administración':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminUsuarios()),
        );
        break;
      case 'Inventario':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InvMedicamento()),
        );
        break;
      case 'Recepción':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Recep()),
        );
        break;
      case 'Consulta Medica':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ConsMedica()),
        );
        break;
      case 'Estudio Medico':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EstudioMed()),
        );
        break;
      default:
        break;
    }
  }

  Widget _buildUserDataTable() {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        double screenWidth = MediaQuery.of(context).size.width;
        double columnSpacing = screenWidth * 0.05; // Espacio de columna predeterminado
        double fontSize = screenWidth * 0.020; // Tamaño de fuente predeterminado
        double fontSizeEdit = screenWidth * 0.015; // Tamaño de fuente predeterminado

        return DataTable(
          columnSpacing: columnSpacing, // Espacio entre columnas
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
          rows: _userDataRows(context),
        );
      },
    );
  }

  List<DataRow> _userDataRows(BuildContext context) {
    final List<Map<String, String>> users = [
      {
        'name': 'Usuario 1',
        'email': 'usuario1@example.com',
        'rol': 'Medico Especialista'
      },
      {'name': 'Usuario 2', 'email': 'usuario2@example.com', 'rol': 'Doctor'},
      {
        'name': 'Usuario 3',
        'email': 'usuario3@example.com',
        'rol': 'Recepcionista'
      },
    ];

    final double screenWidth2 = MediaQuery.of(context).size.width;
    double fontSize = screenWidth2 * 0.018;


    return users.map((user) {
      
      return DataRow(cells: [
        DataCell(Text(
          user['name']!,
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          user['email']!,
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          user['rol']!,
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: const Color(0xFF094293), size: fontSize,),
              onPressed: () {
                // Lógica para editar el usuario
                _showEditUserDialog(context, user['name']!, user['rol']!);
              },
            ),
            IconButton(
              icon: Icon(Icons.person_off_sharp, color: Colors.red, size: fontSize,),
              onPressed: () {
                // Lógica para eliminar el usuario
                _showDeleteUserDialog(context, user['name']!);
              },
            ),
          ],
        )),
      ]);
    }).toList();
  }

}



void _showEditUserDialog(BuildContext context, String name, String currentRole) {
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
            title: Text('Editar usuario', style: TextStyle(color: Colors.black)), // Color del título
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start, // Alinear a la izquierda
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Nombre'),
                    onChanged: (value) {
                      // Aquí puedes realizar alguna acción cuando cambia el valor del TextField
                    },
                  ),
                  SizedBox(height: 20),
                  Text('Rol:', style: TextStyle(color: Colors.black)), // Color del texto del rol
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
                child: Text('Cancelar', style: TextStyle(color: Colors.black)), // Color del texto del botón Cancelar
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
                child: Text('Guardar'),
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
            title: Text('Seguro que quiere dar de baja a $name del sistema?'),
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
                child: Text('Eliminar'),
              ),
            ],
          );
        },
      );
    },
  );
}



final List<String> _menuItems = <String>[
  'Administración',
  'Inventario',
  'Recepción',
  'Consulta Medica',
  'Estudio Medico',
];

enum Menu { itemOne, itemTwo, itemThree }

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: PopupMenuButton<Menu>(
        offset: const Offset(0, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors.white,
        onSelected: (Menu item) {
          switch (item) {
            case Menu.itemOne:
              // Navigate to "Cuenta.dart" using pushReplacement
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CuentaUser()),
              );
              break;
            case Menu.itemThree:
              // Handle "Cerrar Sesión" action
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
              break;
            case Menu.itemTwo:
              // TODO: Handle this case.
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
          const PopupMenuItem<Menu>(
            value: Menu.itemOne,
            child: ListTile(
              title: Text(
                'Cuenta',
                textAlign: TextAlign.right,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.itemThree,
            child: ListTile(
              title: Text(
                'Cerrar Sesión',
                textAlign: TextAlign.right,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ],
        child: const SizedBox(
          width: 50,
          height: 50,
          child: Icon(
            Icons.account_circle_sharp,
            size: 40,
            color: Color(0xFF094293),
          ),
        ),
      ),
    );
  }
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
                ),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(labelText: 'Rol'),
                  items: <String>['Doctor', 'Medico Especialista', 'Recepcionista']
                      .map((String value) {
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
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes realizar la lógica para agregar el usuario con los datos ingresados
                // por ejemplo, puedes acceder a los valores con _nameController.text, _emailController.text, selectedRole
                // y luego cerrar el dialogo con Navigator.of(context).pop();
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }
}