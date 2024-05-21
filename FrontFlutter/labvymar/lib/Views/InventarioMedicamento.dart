import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:labvymar/Views/Navbar_widgets.dart';
import 'package:labvymar/conectionmysql.dart';
import 'package:intl/intl.dart';

//--------------------------------------------------------------//
//----------------- Clase de InvMedicamento --------------------//
//--------------------------------------------------------------//

class InvMedicamento extends StatelessWidget {
  InvMedicamento({Key? key}) : super(key: key);

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
        double columnSpacing = screenWidth * 0.02;
        double fontSize = screenWidth * 0.014;
        double fontSizeEdit = screenWidth * 0.011;

        return FutureBuilder<List<DataRow>>(
          future: _medicamentoDataRows(context),
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
                      'Stock',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Precio',
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
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Unidad de medida',
                      style: TextStyle(
                        fontSize: fontSize,
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
                rows: snapshot
                    .data!, // Utiliza los datos devueltos por _medicamentoDataRows
              );
            }
          },
        );
      },
    );
  }

//---------------------------------------------------------------//
//-------- Lista de medicamento que se obtiene del API  ---------//
//---------------------------------------------------------------//

  Future<List<DataRow>> _medicamentoDataRows(BuildContext context) async {
    final List<Map<String, dynamic>> medicamento =
        await apiService.getMedicamento();

    final double screenWidth2 = MediaQuery.of(context).size.width;
    double fontSize = screenWidth2 * 0.012;

    return medicamento.map((medicamento) {
      DateTime fechaVencimiento;
      try {
        fechaVencimiento =
            DateFormat('yy-MM-dd').parse(medicamento['fechaVencimiento']);
      } catch (e) {
        fechaVencimiento = DateTime
            .now(); // Manejar el error o asignar una fecha predeterminada
      }

      return DataRow(cells: [
        DataCell(Text(
          medicamento['nombre']!,
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          medicamento['descripcion']!,
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          DateFormat('yy-MM-dd').format(fechaVencimiento),
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          medicamento['stock'].toString(),
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          medicamento['precio'].toString(),
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          medicamento['contenido']!,
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(Text(
          medicamento['unidad']!,
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
                int medicamentoId = medicamento['medicamentoId'];
                String nombre = medicamento['nombre'];
                String descripcion = medicamento['descripcion'];
                int stock = medicamento['stock'];
                double precio = medicamento['precio'];
                String unidad = medicamento['unidad'];
                String contenido = medicamento['contenido'];

                _showEditMedicineDialog(
                    context,
                    medicamentoId,
                    nombre,
                    descripcion,
                    fechaVencimiento,
                    stock,
                    precio,
                    unidad,
                    contenido);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.person_off_sharp,
                color: Colors.red,
                size: fontSize,
              ),
              onPressed: () {
                int medicamentoId = medicamento['medicamentoId'];
                String nombre = medicamento['nombre'];
                String contenido = medicamento['contenido'];
                String unidad = medicamento['unidad'];

                _showDeleteUserDialog(
                    context, medicamentoId, nombre, contenido, unidad);
              },
            ),
          ],
        )),
      ]);
    }).toList();
  }

  void _showEditMedicineDialog(
      BuildContext context,
      int medicamentoId,
      String nombre,
      String descripcion,
      DateTime fechaVencimiento,
      int stock,
      double precio,
      String unidad,
      String contenido) {
    TextEditingController nameController = TextEditingController(text: nombre);
    TextEditingController descriptionController =
        TextEditingController(text: descripcion);
    TextEditingController fechaCaducidadController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(fechaVencimiento));
    TextEditingController contenidoController =
        TextEditingController(text: contenido);
    TextEditingController unidMedidaController =
        TextEditingController(text: unidad);
    TextEditingController invActualController =
        TextEditingController(text: stock.toString());
    TextEditingController precioController =
        TextEditingController(text: precio.toString());

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
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Descripción'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: fechaCaducidadController,
                      decoration:
                          InputDecoration(labelText: 'Fecha de caducidad'),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: fechaVencimiento.isBefore(DateTime.now())
                              ? DateTime.now()
                              : fechaVencimiento,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
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
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: unidMedidaController,
                      decoration:
                          InputDecoration(labelText: 'Unidad de medida'),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: invActualController,
                      decoration:
                          InputDecoration(labelText: 'Inventario Actual'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: precioController,
                      decoration: InputDecoration(labelText: 'Precio'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
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
                  onPressed: () async {
                    String newName = nameController.text;
                    String newDescripcion = descriptionController.text;
                    String newFechaCaducidad = fechaCaducidadController.text;
                    String newContenido = contenidoController.text;
                    String newUnidMedida = unidMedidaController.text;
                    int newInvActual =
                        int.tryParse(invActualController.text) ?? stock;
                    double newPrecio =
                        double.tryParse(precioController.text) ?? precio;

                    try {
                      await APIService().updateMedicamento(medicamentoId, {
                        'nombre': newName,
                        'descripcion': newDescripcion,
                        'fechaVencimiento': newFechaCaducidad,
                        'stock': newInvActual,
                        'precio': newPrecio,
                        'contenido': newContenido,
                        'unidad': newUnidMedida,
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Medicamento actualizado con éxito.'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                      Navigator.of(context).pop(); // Cerrar el diálogo
                      Navigator.pushReplacementNamed(
                          context, 'InventarioMedicamento');
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Inténtalo nuevamente'),
                            content: Text(
                                'Hubo un error al actualizar el medicamento.'),
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
                    backgroundColor: Color(0xFF094293), // Color de fondo azul
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
}

//-------------------------------------------------------------------//
//-------- ShowDialog de la opcion de Eliminar Medicamento  ---------//
//-------------------------------------------------------------------//

void _showDeleteUserDialog(BuildContext context, int medicamentoId,
    String nombre, String contenido, String unidad) {
  final APIService apiService = APIService();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(
                'Seguro que quieres dar de baja el producto seleccionado del sistema?\n\n$nombre'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Aquí puedes realizar la lógica para eliminar el medicamento
                  try {
                    // Llamar al método deleteMedicamento de APIService para eliminar el medicamento
                    await apiService.deleteMedicamento(medicamentoId);

                    // Mostrar mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Medicamento eliminado con exito.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                    Navigator.of(context).pop(); // Cerrar el diálogo
                    Navigator.pushReplacementNamed(
                        context, 'InventarioMedicamento');
                  } catch (e) {
                    // Manejar cualquier error que pueda ocurrir durante la actualización
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Inténtelo nuevamente'),
                          content:
                              Text('Hubo un error al eliminar el medicamento.'),
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
                              DateFormat('yyyy-MM-dd').format(pickedDate);
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
  void _handleAdd() async {
    // Obtener los datos del formulario
    String nombre = _nameController.text;
    String descripcion = _descriptionController.text;
    String fechaVencimiento = _dateCadController.text;
    String contenido = _contenidoController.text;
    String unidadDeMedida = _unidadDeMedidaController.text;
    int inventarioActual = int.tryParse(_inventarioActualController.text) ?? 0;
    double precio = double.tryParse(_precioController.text) ?? 0.0;

    // Verificar si todos los campos requeridos están llenos
    if (nombre.isEmpty ||
        descripcion.isEmpty ||
        fechaVencimiento.isEmpty ||
        contenido.isEmpty ||
        unidadDeMedida.isEmpty ||
        inventarioActual <= 0 ||
        precio <= 0) {
      // Mostrar un mensaje de error si algún campo requerido está vacío
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor completa todos los campos.'),
          duration: Duration(seconds: 3),
        ),
      );
      return; // Salir del método si hay campos vacíos
    }

    try {
      // Llamar al método createMedicamento de APIService
      await APIService().createMedicamento({
        'nombre': nombre,
        'descripcion': descripcion,
        'fechaVencimiento': fechaVencimiento,
        'contenido': contenido,
        'unidad': unidadDeMedida,
        'stock': inventarioActual,
        'precio': precio,
      });

      // Limpiar los controladores de texto y cerrar el diálogo
      _clearControllers();
      Navigator.of(context).pop();

      // Mostrar un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medicamento agregado exitosamente'),
          duration: Duration(seconds: 3),
        ),
      );

      
                    Navigator.pushReplacementNamed(
                        context, 'InventarioMedicamento');

      // Puedes realizar cualquier otra acción necesaria después de agregar el medicamento, como recargar la lista de medicamentos.
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir durante la creación del medicamento
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al agregar medicamento: $e'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
