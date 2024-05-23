import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:labvymar/Views/Navbar_widgets.dart';
import 'package:labvymar/conectionmysql.dart';

//----------------------------------------------------------//
//----------------- Clase de EstudioMed --------------------//
//----------------------------------------------------------//

class EstudioMed extends StatefulWidget {
  EstudioMed({super.key});

  @override
  _EstudioMedState createState() => _EstudioMedState();
}

class _EstudioMedState extends State<EstudioMed> {
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
    _allRows = await _pacientesDataRows(context);
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
                Expanded(child: _buildUserDataTable()),
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
                hintText: 'Buscar por nombre, estudio medico, consulta, etc.',
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

  //--------------------------------------------------------------//
  //-------- Widget de la tabla de la lista de pacientes ---------//
  //--------------------------------------------------------------//

  Widget _buildUserDataTable() {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        double screenWidth = MediaQuery.of(context).size.width;
        double columnSpacing =
            screenWidth * 0.02; // Espacio de columna predeterminado
        double fontSize =
            screenWidth * 0.015; // Tamaño de fuente predeterminado
        double fontSizeEdit =
            screenWidth * 0.015; // Tamaño de fuente predeterminado
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
                'Estudio Medico',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // DataColumn(
            //   label: Text(
            //     'Consulta',
            //     style: TextStyle(
            //       fontSize: fontSize,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            DataColumn(
              label: Text(
                'Realizar Estudio',
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

  //-------------------------------------------------------------//
  //-------- Lista de pacientes que se obtiene del API  ---------//
  //-------------------------------------------------------------//

  Future<List<DataRow>> _pacientesDataRows(BuildContext context) async {
    final List<Map<String, dynamic>> users = await apiService.getPacientes();
    users.sort((a, b) => b['pacienteId'].compareTo(a['pacienteId']));

    final double screenWidth2 = MediaQuery.of(context).size.width;
    double fontSize = screenWidth2 * 0.014;
    double iconSize = screenWidth2 * 0.021;

    return users.where((user) {
      // Convertir el valor de 'consulta' a booleano o verificar si es 'Si'
      String estudioMedicoStr = user['estudio_medico'].toString().toLowerCase();
      bool estudioMedico =
          estudioMedicoStr == 'true' || estudioMedicoStr == 'si';
      return estudioMedico;
    }).map((user) {
      // Convertir los valores de 'estudio_medico' y 'consulta' a booleanos si son cadenas
      bool estudioMedico =
          user['estudio_medico'].toString().toLowerCase() == 'true';
      bool consulta = user['consulta'].toString().toLowerCase() == 'true';

      String nombreCompleto = user['nombre'] + ' ' + user['apellido'];

      // Asignar valor predeterminado si 'estudio_detalle' es null o está vacío
      String estudioDetalle = user['estudio_detalle']?.toString() ?? '';
      if (estudioDetalle.isEmpty) {
        estudioDetalle = 'Vuelve a seleccionar el estudio';
      }

      return DataRow(cells: [
        DataCell(Text(
          nombreCompleto.toString(),
          style: TextStyle(fontSize: fontSize),
        )),
        DataCell(
          Container(
            child: Text(
              estudioDetalle,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        ),
        // DataCell(
        //   Container(
        //     alignment: Alignment.center,
        //     child: Text(
        //       user['consulta'].toString(),
        //       style: TextStyle(fontSize: fontSize),
        //     ),
        //   ),
        // ),
        DataCell(
          Center(
            child: IconButton(
              icon: Icon(
                Icons.assignment_add,
                color: const Color(0xFF094293),
                size: iconSize,
              ),
              onPressed: () {
                // Obtener los datos relevantes de la fila seleccionada
                int pacienteId = user['pacienteId'];
                String nombre = user['nombre'];
                String apellido = user['apellido'];
                int edad = user['edad'];
                String sexo = user['sexo'];
                String estudio_detalle = user['estudio_detalle'];

                if(estudio_detalle == 'Prueba de embarazo'){
                  // Llamar al método para mostrar el diálogo de edición
                  _showCapturarPruebaEmbarazo(context, pacienteId, nombre, apellido,
                      edad, sexo, estudioMedico, estudio_detalle);

                } else if(estudio_detalle == 'Antidoping 3'){
                  // Llamar al método para mostrar el diálogo de edición
                  _showCapturarAntidoping3(context, pacienteId, nombre, apellido,
                      edad, sexo, estudioMedico, estudio_detalle);

                } else if(estudio_detalle == 'Antidoping 5'){
                  // Llamar al método para mostrar el diálogo de edición
                  _showCapturarAntidoping5(context, pacienteId, nombre, apellido,
                      edad, sexo, estudioMedico, estudio_detalle);

                }
              },
            ),
          ),
        ),
      ]);
    }).toList();
  }
}

//-------------------------------------------------------------//
//-------- ShowDialog del estudio medico Antidoping 5 ---------//
//-------------------------------------------------------------//

void _showCapturarAntidoping5(
  BuildContext context,
  int pacienteId,
  String nombre,
  String apellido,
  int edad,
  String sexo,
  bool estudioMedico,
  String estudio_detalle,
) {
  final APIService apiService = APIService();

  TextEditingController nombreCompletoController =
      TextEditingController(text: '$nombre $apellido');
  TextEditingController edadController =
      TextEditingController(text: edad.toString());
  TextEditingController sexoController = TextEditingController(text: sexo);
  DateTime fechaActual = DateTime.now();
  TextEditingController contenidoController = TextEditingController();

  TextEditingController marihuanaNormalController = TextEditingController();
  TextEditingController marihuanaResultadoController = TextEditingController();

  TextEditingController cocainaNormalController = TextEditingController();
  TextEditingController cocainaResultadoController = TextEditingController();

  TextEditingController AnfetaminasNormalController = TextEditingController();
  TextEditingController AnfetaminasResultadoController =
      TextEditingController();

  TextEditingController MetanfetaminasNormalController =
      TextEditingController();
  TextEditingController MetanfetaminasResultadoController =
      TextEditingController();

  TextEditingController OpiaceosNormalController = TextEditingController();
  TextEditingController OpiaceosResultadoController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Estudio medico: $estudio_detalle',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
            content: SingleChildScrollView(
              child: Container(
                width:
                    constraints.maxWidth * 0.70, // Ancho del 95% de la pantalla
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            controller: nombreCompletoController,
                            decoration: InputDecoration(
                                labelText: 'Nombre del paciente'),
                            readOnly: true, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            controller: edadController,
                            decoration: InputDecoration(labelText: 'Edad'),
                            keyboardType: TextInputType.number,
                            readOnly: true, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            controller: sexoController,
                            decoration: InputDecoration(labelText: 'Sexo'),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            readOnly: true, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Fecha'),
                            initialValue:
                                '${fechaActual.toLocal()}'.split(' ')[0],
                            readOnly: true, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                      ],
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'ANTIDOPING EN ORINA',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold, // Establece la letra en negrita
                        fontSize: 18, // Establece el tamaño de la letra en 18
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                'Estudio',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                'Valor normal',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                'Resultado',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                'Marihuana',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: marihuanaNormalController,
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: marihuanaResultadoController,
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                'Cocaina',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller:
                                cocainaNormalController, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller:
                                cocainaResultadoController, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                'Anfetaminas',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller:
                                AnfetaminasNormalController, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller:
                                AnfetaminasResultadoController, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                'Metanfetaminas',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller:
                                MetanfetaminasNormalController, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller:
                                MetanfetaminasResultadoController, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                'Opiaceos',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller:
                                OpiaceosNormalController, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller:
                                OpiaceosResultadoController, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                      ],
                    ),
                    const SizedBox(height: 5),
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
                onPressed: () async {
                  // Validar los datos antes de enviar la actualización
                  if (marihuanaNormalController.text.isNotEmpty) {
                    String marihuanaNormal = marihuanaNormalController.text;
                    String marihuanaResultado =
                        marihuanaResultadoController.text;

                    String cocainaNormal = cocainaNormalController.text;
                    String cocainaResultado = cocainaResultadoController.text;

                    String anfetaminasNormal = AnfetaminasNormalController.text;
                    String anfetaminasResultado =
                        AnfetaminasResultadoController.text;

                    String metanfetaminasNormal =
                        MetanfetaminasNormalController.text;
                    String metanfetaminasResultado =
                        MetanfetaminasResultadoController.text;

                    String opiaceosNormal = OpiaceosNormalController.text;
                    String opiaceosResultado = OpiaceosResultadoController.text;

                    Map<String, dynamic> estudioData = {
                      'pacienteId': pacienteId,
                      'VN_M': marihuanaNormal,
                      'V_M': marihuanaResultado,
                      'VN_C': cocainaNormal,
                      'V_C': cocainaResultado,
                      'VN_A': anfetaminasNormal,
                      'V_A': anfetaminasResultado,
                      'VN_ME': metanfetaminasNormal,
                      'V_ME': metanfetaminasResultado,
                      'VN_O': opiaceosNormal,
                      'V_O': opiaceosResultado,
                    };

                    try {
                      // Llamar al método updatePaciente de APIService para actualizar el paciente
                      await apiService.createAntidoping5(estudioData);

                      // Mostrar mensaje de éxito
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Estudio medico capturado con éxito.'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                      Navigator.of(context).pop(); // Cerrar el diálogo

                      Navigator.pushReplacementNamed(context, 'EstudioMedico');
                    } catch (e) {
                      // Manejar cualquier error que pueda ocurrir durante la actualización
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Inténtalo nuevamente'),
                            content: Text(
                                'Hubo un error al capturar el estudio medico.'),
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
                    // Mostrar alerta si no se ingresan datos válidos
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Inténtalo nuevamente'),
                          content: Text(
                              'Por favor ingresa el contenido del estudio medico.'),
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

//-------------------------------------------------------------//
//-------- ShowDialog del estudio medico Antidoping 3 ---------//
//-------------------------------------------------------------//

void _showCapturarAntidoping3(
  BuildContext context,
  int pacienteId,
  String nombre,
  String apellido,
  int edad,
  String sexo,
  bool estudioMedico,
  String estudio_detalle,
) {
  final APIService apiService = APIService();

  TextEditingController nombreCompletoController =
      TextEditingController(text: '$nombre $apellido');
  TextEditingController edadController =
      TextEditingController(text: edad.toString());
  TextEditingController sexoController = TextEditingController(text: sexo);
  DateTime fechaActual = DateTime.now();
  TextEditingController contenidoController = TextEditingController();

  TextEditingController marihuanaNormalController = TextEditingController();
  TextEditingController marihuanaResultadoController = TextEditingController();

  TextEditingController cocainaNormalController = TextEditingController();
  TextEditingController cocainaResultadoController = TextEditingController();

  TextEditingController AnfetaminasNormalController = TextEditingController();
  TextEditingController AnfetaminasResultadoController =
      TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Estudio medico: $estudio_detalle',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
            content: SingleChildScrollView(
              child: Container(
                width:
                    constraints.maxWidth * 0.70, // Ancho del 95% de la pantalla
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            controller: nombreCompletoController,
                            decoration: InputDecoration(
                                labelText: 'Nombre del paciente'),
                            readOnly: true, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            controller: edadController,
                            decoration: InputDecoration(labelText: 'Edad'),
                            keyboardType: TextInputType.number,
                            readOnly: true, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            controller: sexoController,
                            decoration: InputDecoration(labelText: 'Sexo'),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            readOnly: true, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Fecha'),
                            initialValue:
                                '${fechaActual.toLocal()}'.split(' ')[0],
                            readOnly: true, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                      ],
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'ANTIDOPING EN ORINA',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold, // Establece la letra en negrita
                        fontSize: 18, // Establece el tamaño de la letra en 18
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                'Estudio',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                'Valor normal',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                'Resultado',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                'Marihuana',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: marihuanaNormalController,
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: marihuanaResultadoController,
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                'Cocaina',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller:
                                cocainaNormalController, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller:
                                cocainaResultadoController, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                'Anfetaminas',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller:
                                AnfetaminasNormalController, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller:
                                AnfetaminasResultadoController, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                      ],
                    ),
                    const SizedBox(height: 5),
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
                onPressed: () async {
                  // Validar los datos antes de enviar la actualización
                  if (marihuanaNormalController.text.isNotEmpty) {
                    String marihuanaNormal = marihuanaNormalController.text;
                    String marihuanaResultado =
                        marihuanaResultadoController.text;

                    String cocainaNormal = cocainaNormalController.text;
                    String cocainaResultado = cocainaResultadoController.text;

                    String anfetaminasNormal = AnfetaminasNormalController.text;
                    String anfetaminasResultado =
                        AnfetaminasResultadoController.text;

                    Map<String, dynamic> estudioData = {
                      'pacienteId': pacienteId,
                      'VN_M': marihuanaNormal,
                      'V_M': marihuanaResultado,
                      'VN_C': cocainaNormal,
                      'V_C': cocainaResultado,
                      'VN_A': anfetaminasNormal,
                      'V_A': anfetaminasResultado,
                    };

                    try {
                      // Llamar al método updatePaciente de APIService para actualizar el paciente
                      await apiService.createAntidoping3(estudioData);

                      // Mostrar mensaje de éxito
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Estudio medico capturado con éxito.'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                      Navigator.of(context).pop(); // Cerrar el diálogo

                      Navigator.pushReplacementNamed(context, 'EstudioMedico');
                    } catch (e) {
                      // Manejar cualquier error que pueda ocurrir durante la actualización
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Inténtalo nuevamente'),
                            content: Text(
                                'Hubo un error al capturar el estudio medico.'),
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
                    // Mostrar alerta si no se ingresan datos válidos
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Inténtalo nuevamente'),
                          content: Text(
                              'Por favor ingresa el contenido del estudio medico.'),
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

//----------------------------------------------------------------//
//-------- ShowDialog del estudio medico Prueba Embarazo ---------//
//----------------------------------------------------------------//

void _showCapturarPruebaEmbarazo(
  BuildContext context,
  int pacienteId,
  String nombre,
  String apellido,
  int edad,
  String sexo,
  bool estudioMedico,
  String estudio_detalle,
) {
  final APIService apiService = APIService();

  TextEditingController nombreCompletoController =
      TextEditingController(text: '$nombre $apellido');
  TextEditingController edadController =
      TextEditingController(text: edad.toString());
  TextEditingController sexoController = TextEditingController(text: sexo);
  DateTime fechaActual = DateTime.now();
  TextEditingController resultadoController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Estudio medico: $estudio_detalle',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
            content: SingleChildScrollView(
              child: Container(
                width:
                    constraints.maxWidth * 0.70, // Ancho del 95% de la pantalla
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            controller: nombreCompletoController,
                            decoration: InputDecoration(
                                labelText: 'Nombre del paciente'),
                            readOnly: true, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            controller: edadController,
                            decoration: InputDecoration(labelText: 'Edad'),
                            keyboardType: TextInputType.number,
                            readOnly: true, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            controller: sexoController,
                            decoration: InputDecoration(labelText: 'Sexo'),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            readOnly: true, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Fecha'),
                            initialValue:
                                '${fechaActual.toLocal()}'.split(' ')[0],
                            readOnly: true, // Campo no editable
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                      ],
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'PRUEBA DE EMBARAZO EN SANGRE',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold, // Establece la letra en negrita
                        fontSize: 18, // Establece el tamaño de la letra en 18
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                'Resultado:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            value: resultadoController.text.isNotEmpty
                                ? resultadoController.text
                                : null,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                resultadoController.text = newValue;
                              }
                            },
                            items: <String>['Positivo', 'Negativo']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Resultado',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text(
                                '',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: constraints.maxWidth * 0.1),
                      ],
                    ),
                    const SizedBox(height: 5),
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
                onPressed: () async {
                  // Validar los datos antes de enviar la actualización
                  if (resultadoController.text.isNotEmpty) {
                    String resultado = resultadoController.text;

                    Map<String, dynamic> estudioData = {
                      'PacienteId': pacienteId,
                      'Resultado': resultado,
                    };

                    try {
                      // Llamar al método updatePaciente de APIService para actualizar el paciente
                      await apiService.createPruebaEmbarazo(estudioData);

                      // Mostrar mensaje de éxito
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Estudio medico capturado con éxito.'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                      Navigator.of(context).pop(); // Cerrar el diálogo

                      Navigator.pushReplacementNamed(context, 'EstudioMedico');
                    } catch (e) {
                      // Manejar cualquier error que pueda ocurrir durante la actualización
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Inténtalo nuevamente'),
                            content: Text(
                                'Hubo un error al capturar el estudio medico.'),
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
                    // Mostrar alerta si no se ingresan datos válidos
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Inténtalo nuevamente'),
                          content: Text(
                              'Por favor ingresa el contenido del estudio medico.'),
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

//----------------------------------------------------------------//
//-------- ShowDialog de la opcion de Eliminar Paciente  ---------//
//----------------------------------------------------------------//

void _showDeletePacienteDialog(
    BuildContext context, int pacienteId, String nombre) {
  final APIService apiService = APIService();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(
                'Seguro que quieres dar de baja al paciente seleccionado del sistema?\n\n$nombre'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Aquí puedes realizar la lógica para eliminar el paciente
                  try {
                    // Llamar al método deletePaciente de APIService para eleiminar al paciente
                    await apiService.deletePaciente(pacienteId);

                    // Mostrar mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Paciente eliminado con exito.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                    Navigator.of(context).pop(); // Cerrar el diálogo
                    Navigator.pushReplacementNamed(context, 'Recepcion');
                  } catch (e) {
                    // Manejar cualquier error que pueda ocurrir durante la actualización
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Inténtelo nuevamente'),
                          content:
                              Text('Hubo un error al eliminar al paciente.'),
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

//-------------------------------------------------------//
//-------- Clase del boton de agregar paciente  ---------//
//-------------------------------------------------------//

class _UserManagementScreenState extends State<UserManagementScreen> {
  final APIService apiService = APIService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _EdadController = TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  final TextEditingController _EstaturaController = TextEditingController();
  final TextEditingController _PesoController = TextEditingController();
  final TextEditingController _AlergiasController = TextEditingController();
  final TextEditingController _ConsultaController = TextEditingController();
  final TextEditingController _EstudioMedController = TextEditingController();
  bool _isButtonEnabled = false;

  bool isConsulted = false;
  bool isEstudioMed = false;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Estudio Medico',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  //------------------------------------------------------------//
  //-------- ShowDialog del boton de Agregar Paciente  ---------//
  //------------------------------------------------------------//

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
                      controller: _apellidoController,
                      decoration: const InputDecoration(labelText: 'Apellido'),
                      onChanged: (_) => _updateButtonState(setState),
                    ),
                    TextFormField(
                      controller: _EdadController,
                      decoration: const InputDecoration(labelText: 'Edad'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        TextInputFormatter.withFunction((oldValue, newValue) {
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
                      controller: _sexoController,
                      decoration: const InputDecoration(labelText: 'Sexo'),
                      onChanged: (_) => _updateButtonState(setState),
                    ),
                    TextFormField(
                      controller: _EstaturaController,
                      decoration: const InputDecoration(labelText: 'Estatura'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      onChanged: (_) => _updateButtonState(setState),
                    ),
                    TextFormField(
                      controller: _PesoController,
                      decoration: const InputDecoration(labelText: 'Peso'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      onChanged: (_) => _updateButtonState(setState),
                    ),
                    TextFormField(
                      controller: _AlergiasController,
                      decoration: const InputDecoration(labelText: 'Alergias'),
                      onChanged: (_) => _updateButtonState(setState),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Checkbox(
                              value: isConsulted,
                              onChanged: (newValue) {
                                setState(() {
                                  isConsulted = newValue!;
                                  _updateButtonState(setState);
                                  _EstudioMedController.text =
                                      isConsulted ? 'si' : 'no';
                                });
                              },
                            ),
                            Text('¿Estudio Medico?'),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Checkbox(
                              value: isEstudioMed,
                              onChanged: (newValue) {
                                setState(() {
                                  isEstudioMed = newValue!;
                                  _updateButtonState(setState);
                                  _ConsultaController.text =
                                      isEstudioMed ? 'si' : 'no';
                                });
                              },
                            ),
                            Text('¿Consulta Medica?'),
                          ],
                        ),
                      ],
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
                  onPressed: _isButtonEnabled
                      ? () async {
                          // Obtener los datos del formulario
                          String nombre = _nameController.text;
                          String apellido = _apellidoController.text;
                          int edad = int.parse(_EdadController.text);
                          String sexo = _sexoController.text;
                          double estatura =
                              double.parse(_EstaturaController.text);
                          double peso = double.parse(_PesoController.text);
                          String alergias = _AlergiasController.text;
                          bool? estudioMedico = isEstudioMed;
                          bool? consulta = isConsulted;

                          Map<String, dynamic> pacienteData = {
                            'Nombre': nombre,
                            'Apellido': apellido,
                            'Edad': edad,
                            'Sexo': sexo,
                            'Estatura': estatura,
                            'Peso': peso,
                            'Alergias': alergias,
                            'Estudio_Medico': estudioMedico,
                            'Consulta': consulta,
                          };

                          try {
                            // Llamar al método createPaciente de APIService
                            await apiService.createPaciente(pacienteData);

                            // Limpiar los campos y cerrar el diálogo
                            _clearControllers();

                            // Mostrar un mensaje de éxito (opcional)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Paciente agregado exitosamente'),
                                duration: Duration(seconds: 3),
                              ),
                            );

                            Navigator.of(context).pop();

                            Navigator.pushReplacementNamed(
                                context, 'Recepcion');
                          } catch (e) {
                            // Mostrar un mensaje de error en caso de fallo
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al agregar paciente: $e'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      : null,
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

  bool _isValidForm() {
    return _nameController.text.isNotEmpty &&
        _EdadController.text.isNotEmpty &&
        _EstaturaController.text.isNotEmpty &&
        _PesoController.text.isNotEmpty &&
        _AlergiasController.text.isNotEmpty;
  }

  void _updateButtonState(void Function(void Function()) setState) {
    setState(() {
      _isButtonEnabled = _isValidForm();
    });
  }

  void _clearControllers() {
    _nameController.clear();
    _EdadController.clear();
    _EstaturaController.clear();
    _PesoController.clear();
    _AlergiasController.clear();
    _ConsultaController.clear();
    _EstudioMedController.clear();
  }
}
