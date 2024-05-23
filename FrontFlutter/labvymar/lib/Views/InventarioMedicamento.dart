import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:labvymar/Views/Navbar_widgets.dart';
import 'package:labvymar/conectionmysql.dart';
import 'package:intl/intl.dart';

//--------------------------------------------------------------//
//----------------- Clase de InvMedicamento --------------------//
//--------------------------------------------------------------//

class InvMedicamento extends StatefulWidget {
  InvMedicamento({super.key});

  @override
  _InvMedicamentoState createState() => _InvMedicamentoState();
}

class _InvMedicamentoState extends State<InvMedicamento> {
  final APIService apiService = APIService();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const int rowsPerPage = 15;
  int _currentPage = 0;
  List<DataRow> _allRows = [];
  List<DataRow> _currentRows = [];
  List<DataRow> _filteredRows = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterRows();
  }

  void _loadData() async {
    _allRows = await _medicamentoDataRows(context);
    _filteredRows = List.from(_allRows);
    _loadPage(0);
  }

  void _filterRows() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRows = _allRows.where((row) {
        return row.cells.any((cell) {
          if (cell.child is Text) {
            return (cell.child as Text).data!.toLowerCase().contains(query);
          }
          return false;
        });
      }).toList();
    });
    _loadPage(0);
  }

  void _loadPage(int page) {
    int start = page * rowsPerPage;
    int end = start + rowsPerPage;
    setState(() {
      _currentPage = page;
      _currentRows = _filteredRows.sublist(
          start, end > _filteredRows.length ? _filteredRows.length : end);
    });
  }

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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const UserManagementScreen(),
                _buildSearchBar(context),
                Expanded(child: _medicamentoDataTable()),
                _buildPaginationControls(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //--------------------------------------------------//
  //-------- Widget del buscador de la tabla ---------//
  //--------------------------------------------------//

  Widget _buildSearchBar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final bool isLargeScreen = width > 870;

    double searchBarHeight = isLargeScreen ? height * 0.04 : height * 0.07;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isLargeScreen ? width * 0.5 : width * 0.8,
            height: searchBarHeight, // Alto responsivo
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar',
                hintText: 'Buscar por nombre, descripcion, fecha, etc.',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
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
            DataColumn(
              label: Text(
                'Venta',
                style: TextStyle(
                  fontSize: fontSizeEdit,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          rows: _currentRows,
        );
      },
    );
  }

  //---------------------------------------------------//
  //-------- Widget de paginación de la tabla ---------//
  //---------------------------------------------------//

  Widget _buildPaginationControls() {
    int totalRows = _filteredRows.length;
    int totalPages = (totalRows / rowsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _currentPage > 0
              ? () {
                  _loadPage(_currentPage - 1);
                }
              : null,
        ),
        Text('Page ${_currentPage + 1} of $totalPages'),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: _currentPage < totalPages - 1
              ? () {
                  _loadPage(_currentPage + 1);
                }
              : null,
        ),
      ],
    );
  }

  //---------------------------------------------------------------//
  //-------- Lista de medicamento que se obtiene del API  ---------//
  //---------------------------------------------------------------//

  Future<List<DataRow>> _medicamentoDataRows(BuildContext context) async {
    final List<Map<String, dynamic>> medicamento =
        await apiService.getMedicamento();
    medicamento
        .sort((a, b) => b['medicamentoId'].compareTo(a['medicamentoId']));

    final double screenWidth2 = MediaQuery.of(context).size.width;
    double fontSize = screenWidth2 * 0.012;
    double iconSize = screenWidth2 * 0.016;

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
        DataCell(
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: const Color(0xFF094293),
                    size: iconSize,
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
                    Icons.delete_forever,
                    color: Colors.red,
                    size: iconSize,
                  ),
                  onPressed: () {
                    int medicamentoId = medicamento['medicamentoId'];
                    String nombre = medicamento['nombre'];
                    String contenido = medicamento['contenido'];
                    String unidad = medicamento['unidad'];

                    _showDeleteMedicamentoDialog(
                        context, medicamentoId, nombre, contenido, unidad);
                  },
                ),
              ],
            ),
          ),
        ),
        DataCell(
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.add_shopping_cart_rounded,
                    color: Colors.green,
                    size: iconSize,
                  ),
                  onPressed: () {
                    int medicamentoId = medicamento['medicamentoId'];
                    String nombre = medicamento['nombre'];
                    String contenido = medicamento['contenido'];
                    String unidad = medicamento['unidad'];
                    int stock = medicamento['stock'];
                    double precio = medicamento['precio'];

                    _showCartMedicamentoDialog(context, medicamentoId, nombre,
                        precio, stock, unidad, contenido);
                  },
                ),
              ],
            ),
          ),
        ),
      ]);
    }).toList();
  }

  //-----------------------------------------------------------------//
  //-------- ShowDialog de la opcion de Editar Medicamento  ---------//
  //-----------------------------------------------------------------//

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

void _showDeleteMedicamentoDialog(BuildContext context, int medicamentoId,
    String nombre, String contenido, String unidad) {
  final APIService apiService = APIService();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(
                'Seguro que quieres dar de baja el producto seleccionado del sistema?\n\nProducto: $nombre\nContenido: $contenido\nUnidad de medida: $unidad'),
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

//--------------------------------------------------------------------------------//
//-------- ShowDialog de la opcion de agregar al carrito el Medicamento  ---------//
//--------------------------------------------------------------------------------//

void _showCartMedicamentoDialog(BuildContext context, int medicamentoId,
    String nombre, double precio, int stock, String unidad, String contenido) {
  TextEditingController nameController = TextEditingController(text: nombre);
  TextEditingController contenidoController =
      TextEditingController(text: contenido);
  TextEditingController unidMedidaController =
      TextEditingController(text: unidad);
  TextEditingController invActualController =
      TextEditingController(text: stock.toString());
  TextEditingController precioController =
      TextEditingController(text: '\$' + precio.toString());

  int? venta = 1;
  TextEditingController cantidadVentaController =
      TextEditingController(text: venta.toString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Agregar el producto al carrito de venta',
                style: TextStyle(color: Colors.black)),
            content: SingleChildScrollView(
              child: Container(
                width: constraints.maxWidth * 0.30,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(labelText: 'Nombre'),
                            readOnly: true,
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: contenidoController,
                            decoration: InputDecoration(labelText: 'Contenido'),
                            readOnly: true,
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: unidMedidaController,
                            decoration:
                                InputDecoration(labelText: 'Unidad de medida'),
                            readOnly: true,
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: precioController,
                            decoration: InputDecoration(labelText: 'Precio'),
                            readOnly: true,
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: cantidadVentaController,
                                decoration: const InputDecoration(
                                  labelText: 'Ingresa la cantidad:',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  TextInputFormatter.withFunction(
                                      (oldValue, newValue) {
                                    if (newValue.text.isEmpty) {
                                      return newValue.copyWith(text: '');
                                    } else if (double.tryParse(newValue.text) ==
                                            null ||
                                        int.parse(newValue.text) > stock) {
                                      return oldValue;
                                    } else {
                                      return newValue;
                                    }
                                  }),
                                ],
                              ),
                              ValueListenableBuilder<TextEditingValue>(
                                valueListenable: cantidadVentaController,
                                builder: (context, value, child) {
                                  final int? cantidad =
                                      int.tryParse(value.text);
                                  if (cantidad != null && cantidad > stock) {
                                    return const Text(
                                      'No se cuenta con esa cantidad en stock',
                                      style: TextStyle(color: Colors.red),
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                      ],
                    ),
                  ],
                ),
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
                  if (cantidadVentaController.text.isNotEmpty) {
                    int cantidad =
                        int.tryParse(cantidadVentaController.text) ?? 0;
                    double countPrecio = double.tryParse(
                            precioController.text.replaceAll('\$', '')) ??
                        precio;

                    carrito.agregarItem(
                        medicamentoId, nombre, cantidad, countPrecio);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Producto agregado al carrito.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                    Navigator.of(context).pop(); // Cerrar el diálogo
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Inténtalo nuevamente'),
                          content: Text(
                              'Por favor ingresa el contenido de la receta.'),
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

class Carrito {
  final List<Map<String, dynamic>> _items = [];

  void agregarItem(
      int medicamentoId, String nombre, int cantidad, double precio) {
    _items.add({
      'medicamentoId': medicamentoId,
      'nombre': nombre,
      'cantidad': cantidad,
      'precio': precio,
    });
  }

  void eliminarItem(int medicamentoId) {
    _items.removeWhere((item) => item['medicamentoId'] == medicamentoId);
  }

  void limpiarCarrito() {
    _items.clear();
  }

  List<Map<String, dynamic>> obtenerItems() {
    return _items;
  }

  double obtenerTotal() {
    return _items.fold(
        0, (total, item) => total + item['precio'] * item['cantidad']);
  }

  List<Map<String, dynamic>> obtenerResumenVenta() {
    return _items.map((item) {
      return {
        'id': item['medicamentoId'],
        'cantidad': item['cantidad'],
      };
    }).toList();
  }
}

final Carrito carrito = Carrito(); // Instancia global del carrito

//---------------------------------------------------------//
//-------- ShowDialog de la opcion Carrito Total  ---------//
//---------------------------------------------------------//

void _showCartDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          List<Map<String, dynamic>> items = carrito.obtenerItems();
          double total = carrito.obtenerTotal();

          return AlertDialog(
            title: Text('Carrito de compras'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  ListBody(
                    children: items.map((item) {
                      return ListTile(
                        title: Text(item['nombre']),
                        subtitle: Text(
                            'Cantidad: ${item['cantidad']} - Precio: \$${item['precio']}'),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              carrito.eliminarItem(item['medicamentoId']);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${item['nombre']} eliminado del carrito.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Text('Total: \$${total.toStringAsFixed(2)}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cerrar'),
              ),
              TextButton(
                onPressed: () {
                  carrito.limpiarCarrito();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('El carrito ha sido limpiado.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Text('Limpiar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  List<Map<String, dynamic>> resumenVenta =
                      carrito.obtenerResumenVenta();

                  try {
                    Map<String, dynamic> response =
                        await APIService().enviarResumenVenta(resumenVenta);

                    if (response['success']) {
                      carrito.limpiarCarrito();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Venta finalizada con éxito.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.pushReplacementNamed(
                          context, 'InventarioMedicamento');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Error al finalizar la venta: ${response['message']}'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al conectar con el servidor: $e'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Text('Finalizar venta'),
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
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                _showCartDialog(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              icon: const Icon(
                Icons.shopping_cart_rounded,
                color: Colors.white,
                size: 20,
              ),
              label: const Text(
                'Carrito de Venta',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            const SizedBox(height: 10),
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

      Navigator.pushReplacementNamed(context, 'InventarioMedicamento');

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
