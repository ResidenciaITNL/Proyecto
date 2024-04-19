import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:labvymar/Views/AdministrarUsuarios.dart';
import 'package:labvymar/Views/ConsultaMedica.dart';
import 'package:labvymar/Views/Cuenta.dart';
import 'package:labvymar/Views/EstudioMedico.dart';
import 'package:labvymar/Views/InventarioMedicamento.dart';
import 'package:labvymar/Views/login.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Recep extends StatelessWidget {
  Recep({super.key});

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
        double columnSpacing =
            screenWidth * 0.02; // Espacio de columna predeterminado
        double fontSize =
            screenWidth * 0.020; // Tamaño de fuente predeterminado
        double fontSizeEdit =
            screenWidth * 0.015; // Tamaño de fuente predeterminado

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
                'Edad',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Estatura',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Peso',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Alergias',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Consulta',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Estudio Médico',
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
        'nombre': 'Alberto',
        'edad': '22',
        'estatura': '1.80',
        'peso': '70kg',
        'alergias': 'no',
        'consulta': 'si',
        'estudioMedico': 'si'
      },
      {
        'nombre': 'Jorge',
        'edad': '24',
        'estatura': '1.70',
        'peso': '75kg',
        'alergias': 'si',
        'consulta': 'si',
        'estudioMedico': 'no'
      },
      {
        'nombre': 'Victor',
        'edad': '23',
        'estatura': '1.68',
        'peso': '75kg',
        'alergias': 'no',
        'consulta': 'no',
        'estudioMedico': 'si'
      },
      {
        'nombre': 'Adrian',
        'edad': '21',
        'estatura': '1.75',
        'peso': '65kg',
        'alergias': 'no',
        'consulta': 'si',
        'estudioMedico': 'no'
      },
    ];

    final double screenWidth2 = MediaQuery.of(context).size.width;
    double fontSize = screenWidth2 * 0.018;

    return users.map((user) {
      return DataRow(cells: [
        DataCell(Text(
          user['nombre']!,
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          user['edad']!,
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          user['estatura']!,
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          user['peso']!,
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(
          Container(
            alignment: Alignment.center,
            child: Text(
              user['alergias']!,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        ),
        DataCell(
          Container(
            alignment: Alignment.center,
            child: Text(
              user['consulta']!,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        ),
        DataCell(
          Container(
            alignment: Alignment.center,
            child: Text(
              user['estudioMedico']!,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        ),
        DataCell(
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Centra los elementos horizontalmente
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: const Color(0xFF094293),
                    size: fontSize,
                  ),
                  onPressed: () {
                    // Lógica para editar el paciente
                    _showEditPacienteDialog(
                      context,
                      user['nombre']!,
                      user['edad']!,
                      user['estatura']!,
                      user['peso']!,
                      user['alergias']!,
                      user['consulta']!,
                      user['estudioMedico']!,
                    );
                  },
                ),
                SizedBox(width: 5), // Separación de 5 píxeles
                IconButton(
                  icon: Icon(
                    Icons.person_off_sharp,
                    color: Colors.red,
                    size: fontSize,
                  ),
                  onPressed: () {
                    // Lógica para eliminar el paciente
                    _showDeletePacienteDialog(context, user['nombre']!);
                  },
                ),
              ],
            ),
          ),
        ),
      ]);
    }).toList();
  }
}

void _showEditPacienteDialog(
    BuildContext context,
    String name,
    String edad,
    String estatura,
    String peso,
    String alergias,
    String consulta,
    String estudiomed) {
  TextEditingController nameController = TextEditingController(text: name);
  TextEditingController edadController = TextEditingController(text: edad);
  TextEditingController estaturaController =
      TextEditingController(text: estatura);
  TextEditingController pesoController = TextEditingController(text: peso);
  TextEditingController alergiasController =
      TextEditingController(text: alergias);
  TextEditingController consultaController =
      TextEditingController(text: consulta);
  TextEditingController estudiomedController =
      TextEditingController(text: estudiomed);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Editar datos del paciente',
                style: TextStyle(color: Colors.black)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Nombre'),
                    onChanged: (value) {
                      // Aquí puedes realizar alguna acción cuando cambia el valor del TextFormField
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: edadController,
                    decoration: InputDecoration(labelText: 'Edad'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(
                          r'^\d+')), // Permite solo números enteros positivos
                    ],
                    onChanged: (value) {
                      // Aquí puedes realizar alguna acción cuando cambia el valor del TextFormField
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: estaturaController,
                    decoration: InputDecoration(labelText: 'Estatura'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    onChanged: (value) {
                      // Aquí puedes realizar alguna acción cuando cambia el valor del TextFormField
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: pesoController,
                    decoration: InputDecoration(labelText: 'Peso'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(
                          r'^\d+')), // Permite solo números enteros positivos
                    ],
                    onChanged: (value) {
                      // Aquí puedes realizar alguna acción cuando cambia el valor del TextFormField
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: alergiasController,
                    decoration: InputDecoration(labelText: 'Alergias'),
                    onChanged: (value) {
                      // Aquí puedes realizar alguna acción cuando cambia el valor del TextFormField
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: consultaController,
                    decoration: InputDecoration(labelText: 'Consulta'),
                    onChanged: (value) {
                      // Aquí puedes realizar alguna acción cuando cambia el valor del TextFormField
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: estudiomedController,
                    decoration: InputDecoration(labelText: 'Estudio Medico'),
                    onChanged: (value) {
                      // Aquí puedes realizar alguna acción cuando cambia el valor del TextFormField
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
                child: const Text('Cancelar',
                    style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                onPressed: () {
                  String newName = nameController.text;
                  String newEdad = edadController.text;
                  String newEstatura = estaturaController.text;
                  String newPeso = pesoController.text;
                  String newAlergias = alergiasController.text;
                  String newConsulta = consultaController.text;
                  String newEstudioMed = estudiomedController.text;
                  print('la actualizacion es: $newName');
                  print('la actualizacion es: $newEdad');
                  print('la actualizacion es: $newEstatura');
                  print('la actualizacion es: $newPeso');
                  print('la actualizacion es: $newAlergias');
                  print('la actualizacion es: $newConsulta');
                  print('la actualizacion es: $newEstudioMed');
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

void _showDeletePacienteDialog(BuildContext context, String name) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(
                'Seguro que quieres dar de baja al paciente seleccionado del sistema?\n\n$name'),
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
  final TextEditingController _EdadController = TextEditingController();
  final TextEditingController _EstaturaController = TextEditingController();
  final TextEditingController _PesoController = TextEditingController();
  final TextEditingController _AlergiasController = TextEditingController();
  final TextEditingController _ConsultaController = TextEditingController();
  final TextEditingController _EstudioMedController = TextEditingController();
  bool _isButtonEnabled = false; // Estado del botón "Agregar"

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Recepción',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _showAddPacienteDialog(context);
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
                'Nuevo Paciente',
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

  void _showAddPacienteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Center(
                child: Text('Nuevo Paciente'),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      onChanged: (_) => _updateButtonState(setState),
                    ),
                    TextFormField(
                      controller: _EdadController,
                      decoration: const InputDecoration(labelText: 'Edad'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          // Evita números negativos
                          if (newValue.text.isEmpty) {
                            return newValue.copyWith(text: '');
                          } else if (double.tryParse(newValue.text) == null) {
                            return oldValue;
                          } else {
                            return newValue;
                          }
                        }),
                      ],
                      onChanged: (_) => _updateButtonState(setState),
                    ),
                    TextFormField(
                      controller: _EstaturaController,
                      decoration: const InputDecoration(labelText: 'Estatura'),
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true), // Tipo de teclado decimal
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(
                            r'^\d+\.?\d{0,2}')), // Permite solo números decimales con hasta dos decimales
                      ],
                      onChanged: (_) => _updateButtonState(setState),
                    ),
                    TextFormField(
                      controller: _PesoController,
                      decoration: const InputDecoration(labelText: 'Peso'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          // Evita números negativos
                          if (newValue.text.isEmpty) {
                            return newValue.copyWith(text: '');
                          } else if (double.tryParse(newValue.text) == null) {
                            return oldValue;
                          } else {
                            return newValue;
                          }
                        }),
                      ],
                      onChanged: (_) => _updateButtonState(setState),
                    ),
                    TextFormField(
                      controller: _AlergiasController,
                      decoration: const InputDecoration(labelText: 'Alergias'),
                      onChanged: (_) => _updateButtonState(setState),
                    ),
                    TextFormField(
                      controller: _ConsultaController,
                      decoration: const InputDecoration(labelText: 'Consulta'),
                      onChanged: (_) => _updateButtonState(setState),
                    ),
                    TextFormField(
                      controller: _EstudioMedController,
                      decoration:
                          const InputDecoration(labelText: 'EstudioMedico'),
                      onChanged: (_) => _updateButtonState(setState),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _clearControllers();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: _isButtonEnabled ? _handleAdd : null,
                  style: ButtonStyle(
                    backgroundColor: _isButtonEnabled
                        ? MaterialStateProperty.all<Color>(
                            const Color(0xFF094293))
                        : MaterialStateProperty.all<Color>(
                            const Color(0xFFBBDEFB)),
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

  // Verificar si todos los campos están llenos
  bool _isValidForm() {
    return _nameController.text.isNotEmpty &&
        _EdadController.text.isNotEmpty &&
        _EstaturaController.text.isNotEmpty &&
        _PesoController.text.isNotEmpty &&
        _AlergiasController.text.isNotEmpty &&
        _ConsultaController.text.isNotEmpty &&
        _EstudioMedController.text.isNotEmpty;
  }

  // Actualizar el estado del botón "Agregar"
  void _updateButtonState(void Function(void Function()) setState) {
    setState(() {
      _isButtonEnabled = _isValidForm();
    });
  }

  // Limpiar los controladores de texto
  void _clearControllers() {
    _nameController.clear();
    _EdadController.clear();
    _EstaturaController.clear();
    _PesoController.clear();
    _AlergiasController.clear();
    _ConsultaController.clear();
    _EstudioMedController.clear();
  }

  // Lógica para manejar la adición de medicamento
  void _handleAdd() {
    // Realizar la lógica para agregar el medicamento aquí
    _clearControllers();
    Navigator.of(context).pop();
  }
}
