import 'package:flutter/material.dart';
import 'package:labvymar/Views/ConsultaMedica.dart';
import 'package:labvymar/Views/EstudioMedico.dart';
import 'package:labvymar/Views/InventarioMedicamento.dart';
import 'package:labvymar/Views/Recepcion.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AdminUsuarios extends StatelessWidget {
  AdminUsuarios({Key? key}) : super(key: key);

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
                const Text(
                  'Administrar Usuarios',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                    height: 20), // Agrega un espacio entre el título y el botón
                ElevatedButton.icon(
                  onPressed: () {
                    // Lógica para agregar un usuario
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF094293)),
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
                const SizedBox(
                    height:
                        40), // Agrega un espacio entre el botón y el DataTable
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
        double columnSpacing = screenWidth * 0.15; // Espacio de columna predeterminado
        double fontSize = 20.0; // Tamaño de fuente predeterminado

        if (sizingInformation.deviceScreenType == DeviceScreenType.mobile) {
          columnSpacing = screenWidth * 0.1; // Ajuste para dispositivos móviles
          fontSize = 16.0;
        } else if (sizingInformation.deviceScreenType ==
            DeviceScreenType.tablet) {
          columnSpacing = screenWidth * 0.12; // Ajuste para tabletas
          fontSize = 18.0;
        }

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
                'Editar | Eliminar',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          rows: _userDataRows(),
        );
      },
    );
  }

  List<DataRow> _userDataRows() {
    // Lógica para cargar los datos de los usuarios
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

    return users.map((user) {
      return DataRow(cells: [
        DataCell(Text(
          user['name']!,
          style:
              const TextStyle(fontSize: 18.0), // Aumentar el tamaño del texto
        )),
        DataCell(Text(
          user['email']!,
          style:
              const TextStyle(fontSize: 18.0), // Aumentar el tamaño del texto
        )),
        DataCell(Text(
          user['rol']!,
          style:
              const TextStyle(fontSize: 18.0), // Aumentar el tamaño del texto
        )),
        DataCell(Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFF094293)),
              onPressed: () {
                // Lógica para editar el usuario
                // Puedes abrir un diálogo o navegar a otra pantalla para editar
                // Dependiendo de tu implementación
              },
            ),
            const Text(
              "           "
            ),
            IconButton(
              icon: const Icon(Icons.person_off_sharp, color: Colors.red),
              onPressed: () {
                // Lógica para eliminar el usuario
                // Puedes mostrar un diálogo de confirmación antes de eliminar
              },
            ),
          ],
        )),
      ]);
    }).toList();
  }
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
      color: Colors.white, // Agregar fondo blanco al contenedor principal
      child: PopupMenuButton<Menu>(
        offset: const Offset(0, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: Colors
            .white, // Asegurar que el menú desplegable también tenga un fondo blanco
        onSelected: (Menu item) {},
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
          const PopupMenuItem<Menu>(
            value: Menu.itemOne,
            child: ListTile(
              title: Text(
                'Cuenta',
                textAlign: TextAlign.right, // Alinea el texto hacia la derecha
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          const PopupMenuItem<Menu>(
            value: Menu.itemThree,
            child: ListTile(
              title: Text(
                'Cerrar Sesión',
                textAlign: TextAlign.right, // Alinea el texto hacia la derecha
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ],
        child: const SizedBox(
          width: 50, // Ancho del contenedor
          height: 50, // Alto del contenedor
          child: Icon(
            Icons.account_circle_sharp,
            size: 40, // Tamaño del icono
            color: Color(0xFF094293),
          ),
        ),
      ),
    );
  }
}
