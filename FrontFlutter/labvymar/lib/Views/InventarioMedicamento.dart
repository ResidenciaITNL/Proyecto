import 'package:flutter/material.dart';
import 'package:labvymar/Views/AdministrarUsuarios.dart';
import 'package:labvymar/Views/ConsultaMedica.dart';
import 'package:labvymar/Views/EstudioMedico.dart';
import 'package:labvymar/Views/Recepcion.dart';

class InvMedicamento extends StatelessWidget {
  InvMedicamento({Key? key}) : super(key: key);

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
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/fondo.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                const Color.fromARGB(123, 0, 0, 0).withOpacity(0.6),
                BlendMode.darken,
              ),
            ),
          ),
          child: const Center(
            child: Text(
              "¡Bienvenido al Inventario del Medicamento!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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
        color: Colors.white, // Asegurar que el menú desplegable también tenga un fondo blanco
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
