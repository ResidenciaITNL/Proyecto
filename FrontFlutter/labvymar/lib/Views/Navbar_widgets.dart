import 'package:flutter/material.dart';
import 'package:labvymar/conectionmysql.dart';

enum Menu { itemOne, itemTwo, itemThree }

class NavBarWidgets {
  static Widget drawer(BuildContext context) => Drawer(
        child: Container(
          color: Colors.white,
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

  static Widget navBarItems(BuildContext context) => Row(
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

  static Widget profileIcon(BuildContext context) => _ProfileIcon();

  static void _handleMenuTap(BuildContext context, String menuItem) {
    switch (menuItem) {
      case 'Administración':
        Navigator.pushReplacementNamed(context, 'AdministrarUsuarios');
        break;
      case 'Inventario':
        Navigator.pushReplacementNamed(context, 'InventarioMedicamento');
        break;
      case 'Recepción':
        Navigator.pushReplacementNamed(context, 'Recepcion');
        break;
      case 'Consulta Medica':
        Navigator.pushReplacementNamed(context, 'ConsultaMedica');
        break;
      case 'Estudio Medico':
        Navigator.pushReplacementNamed(context, 'EstudioMedico');
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

class _ProfileIcon extends StatelessWidget {
  _ProfileIcon({Key? key}) : super(key: key);
  final APIService apiService = APIService();

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
        onSelected: (Menu item) async {
          switch (item) {
            case Menu.itemOne:
              Navigator.pushReplacementNamed(context, 'Cuenta');
              break;
            case Menu.itemThree:
              // Llama al método cerrarSesion para eliminar el token
              await apiService.cerrarSesion();

              // Redirige directamente a la página de inicio de sesión
              Navigator.pushReplacementNamed(context, 'login');
              break;
            case Menu.itemTwo:
              // TODO: Handle this case.
              break;
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
