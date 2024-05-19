import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:labvymar/Views/Navbar_widgets.dart';
import 'package:labvymar/conectionmysql.dart';

//--------------------------------------------------------------//
//----------------- Clase de InvMedicamento --------------------//
//--------------------------------------------------------------//

class InvMedicamento extends StatelessWidget {
  InvMedicamento({Key? key}) : super(key: key);

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
                _medicamentoDataTable(), // Tu DataTable aquí
              ],
            ),
          ),
        ),
      ),
    );
  }

  //----------------------------------------------------------------//
  //-------- Widget de la tabla de la lista de Medicamento ---------//
  //----------------------------------------------------------------//

  Widget _medicamentoDataTable() {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        double screenWidth = MediaQuery.of(context).size.width;
        double columnSpacing =
            screenWidth * 0.015; // Espacio de columna predeterminado
        double fontSize = screenWidth * 0.01; // Tamaño de fuente predeterminado
        double fontSizeEdit =
            screenWidth * 0.01; // Tamaño de fuente predeterminado

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
                'Descripcion',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Fecha de caducidad',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Contenido',
                style: TextStyle(
                  fontSize: fontSizeEdit,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Unidad de Medida',
                style: TextStyle(
                  fontSize: fontSizeEdit,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Inventario Actual',
                style: TextStyle(
                  fontSize: fontSizeEdit,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Precio',
                style: TextStyle(
                  fontSize: fontSizeEdit,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Editar | Eliminar',
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

  //---------------------------------------------------------------//
  //-------- Lista de medicamento que se obtiene del API  ---------//
  //---------------------------------------------------------------//

  List<DataRow> _userDataRows(BuildContext context) {
    final List<Map<String, String>> users = [
      {
        'nombre': 'omeprasol',
        'descripcion': 'para la gastritis',
        'fecha_cad': '02/12/2024',
        'contenido': '20 capsulas',
        'unidad_Medida': '20 mg',
        'inventario_Actual': '80',
        'precio': '120',
      },
      {
        'nombre': 'riopan',
        'descripcion': 'para la acides',
        'fecha_cad': '27/05/2025',
        'contenido': '20 bolsas',
        'unidad_Medida': '10 ml',
        'inventario_Actual': '132',
        'precio': '250',
      },
      {
        'nombre': 'aspirina',
        'descripcion': 'para el dolor de cabeza',
        'fecha_cad': '12/07/2025',
        'contenido': '20 capsulas',
        'unidad_Medida': '400 mg',
        'inventario_Actual': '206',
        'precio': '80',
      },
    ];

    final double screenWidth2 = MediaQuery.of(context).size.width;
    double fontSize = screenWidth2 * 0.009;

    return users.map((user) {
      return DataRow(cells: [
        DataCell(Text(
          user['nombre']!,
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          user['descripcion']!,
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          user['fecha_cad']!,
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          user['contenido']!,
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          user['unidad_Medida']!,
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          user['inventario_Actual']!,
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          user['precio']!,
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
                // Lógica para editar el medicamento
                _showEditMedicineDialog(
                  context,
                  user['nombre']!,
                  user['descripcion']!,
                  user['fecha_cad']!,
                  user['contenido']!,
                  user['unidad_Medida']!,
                  user['inventario_Actual']!,
                  user['precio']!,
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.person_off_sharp,
                color: Colors.red,
                size: fontSize,
              ),
              onPressed: () {
                // Lógica para eliminar el medicamento
                _showDeleteUserDialog(context, user['nombre']!);
              },
            ),
          ],
        )),
      ]);
    }).toList();
  }
}

//-----------------------------------------------------------------//
//-------- ShowDialog de la opcion de Editar Medicamento  ---------//
//-----------------------------------------------------------------//

void _showEditMedicineDialog(
    BuildContext context,
    String name,
    String description,
    String fechaCaducidad,
    String contenido,
    String unidMedida,
    String invActual,
    String precio) {
  TextEditingController nameController = TextEditingController(text: name);
  TextEditingController descriptionController =
      TextEditingController(text: description);
  TextEditingController fechaCaducidadController =
      TextEditingController(text: fechaCaducidad);
  TextEditingController contenidoController =
      TextEditingController(text: contenido);
  TextEditingController unidMedidaController =
      TextEditingController(text: unidMedida);
  TextEditingController invActualController =
      TextEditingController(text: invActual);
  TextEditingController precioController = TextEditingController(text: precio);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Editar producto',
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
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Descripción'),
                    onChanged: (value) {
                      // Aquí puedes realizar alguna acción cuando cambia el valor del TextFormField
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: fechaCaducidadController,
                    decoration:
                        InputDecoration(labelText: 'Fecha de caducidad'),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        String formattedDate =
                            '${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}';
                        setState(() {
                          fechaCaducidadController.text = formattedDate;
                        });
                      }
                    },
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: contenidoController,
                    decoration: InputDecoration(labelText: 'Contenido'),
                    onChanged: (value) {
                      // Aquí puedes realizar alguna acción cuando cambia el valor del TextFormField
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: unidMedidaController,
                    decoration: InputDecoration(labelText: 'Unidad de medida'),
                    onChanged: (value) {
                      // Aquí puedes realizar alguna acción cuando cambia el valor del TextFormField
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: invActualController,
                    decoration: InputDecoration(labelText: 'Inventario Actual'),
                    onChanged: (value) {
                      // Aquí puedes realizar alguna acción cuando cambia el valor del TextFormField
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: precioController,
                    decoration: InputDecoration(labelText: 'Precio'),
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
                  String newDescripcion = descriptionController.text;
                  String newFechaCaducidad = fechaCaducidadController
                      .text; // Aquí obtienes la nueva fecha
                  String newContenido = contenidoController.text;
                  String newUnidMedida = unidMedidaController.text;
                  String newInvActual = invActualController.text;
                  String newPrecio = precioController.text;
                  print('la actualizacion es: $newName');
                  print('la actualizacion es: $newDescripcion');
                  print('la actualizacion es: $newFechaCaducidad');
                  print('la actualizacion es: $newContenido');
                  print('la actualizacion es: $newUnidMedida');
                  print('la actualizacion es: $newInvActual');
                  print('la actualizacion es: $newPrecio');
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


//-------------------------------------------------------------------//
//-------- ShowDialog de la opcion de Eliminar Medicamento  ---------//
//-------------------------------------------------------------------//

void _showDeleteUserDialog(BuildContext context, String name) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(
                'Seguro que quieres dar de baja el producto seleccionado del sistema?\n\n$name'),
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

//-----------------------------------//
//--------  Header del body ---------//
//-----------------------------------//

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserManagementScreenState createState() => _UserManagementScreenState();
}


//----------------------------------------------------------//
//-------- Clase del boton de agregar medicamento  ---------//
//----------------------------------------------------------//

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateCadController = TextEditingController();
  final TextEditingController _contenidoController = TextEditingController();
  final TextEditingController _unidadDeMedidaController =
      TextEditingController();
  final TextEditingController _inventarioActualController =
      TextEditingController();
  final TextEditingController _precioController = TextEditingController();
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
              'Inventario de Medicamento',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _showAddmedicineDialog(context);
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFF094293)),
              ),
              icon: const Icon(
                Icons.add_circle_sharp,
                color: Colors.white,
                size: 30,
              ),
              label: const Text(
                'Agregar medicamento',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }



  //---------------------------------------------------------------//
  //-------- ShowDialog del boton de Agregar Medicamento  ---------//
  //---------------------------------------------------------------//

  void _showAddmedicineDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Center(
                child: Text('Nuevo Medicamento'),
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
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Descripción'),
                      onChanged: (_) => _updateButtonState(setState),
                    ),
                    TextFormField(
                      controller: _dateCadController,
                      decoration: const InputDecoration(
                          labelText: 'Fecha de Caducidad'),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          String formattedDate =
                              '${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}';
                          setState(() {
                            _dateCadController.text = formattedDate;
                          });
                        }
                      },
                      readOnly: true,
                    ),
                    TextFormField(
                      controller: _contenidoController,
                      decoration: const InputDecoration(labelText: 'Contenido'),
                      onChanged: (_) => _updateButtonState(setState),
                    ),
                    TextFormField(
                      controller: _unidadDeMedidaController,
                      decoration:
                          const InputDecoration(labelText: 'Unidad de Medida'),
                      onChanged: (_) => _updateButtonState(setState),
                    ),
                    TextFormField(
                      controller: _inventarioActualController,
                      decoration:
                          const InputDecoration(labelText: 'Inventario Actual'),
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
                      controller: _precioController,
                      decoration: const InputDecoration(labelText: 'Precio'),
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
        _descriptionController.text.isNotEmpty &&
        _dateCadController.text.isNotEmpty &&
        _contenidoController.text.isNotEmpty &&
        _unidadDeMedidaController.text.isNotEmpty &&
        _inventarioActualController.text.isNotEmpty &&
        _precioController.text.isNotEmpty;
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
    _descriptionController.clear();
    _dateCadController.clear();
    _contenidoController.clear();
    _unidadDeMedidaController.clear();
    _inventarioActualController.clear();
    _precioController.clear();
  }

  // Lógica para manejar la adición de medicamento
  void _handleAdd() {
    // Realizar la lógica para agregar el medicamento aquí
    _clearControllers();
    Navigator.of(context).pop();
  }
}
