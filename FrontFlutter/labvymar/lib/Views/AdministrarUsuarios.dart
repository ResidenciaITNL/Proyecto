import 'package:flutter/material.dart';

class HomeAdmin extends StatelessWidget {
  HomeAdmin({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;

    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        backgroundColor: Colors.white, // Establece el color de fondo blanco
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
                    // Manejar la navegación hacia la vista home
                    Navigator.pushReplacementNamed(context, 'home_admin');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0), // Ajusta el espacio superior e inferior
                    child: Image.asset(
                      'assets/VYMAR_logo.png', // Ruta de la imagen
                      height: 60, // Altura de la imagen
                      width: 60, // Ancho de la imagen
                    ),
                  ),
                ),
                if (isLargeScreen) Expanded(child: _navBarItems())
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
        drawer: isLargeScreen ? null : _drawer(),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/fondo.jpg'), // Ruta de tu imagen
              fit: BoxFit.cover, // Ajusta la imagen para cubrir el contenedor
              colorFilter: ColorFilter.mode(const Color.fromARGB(123, 0, 0, 0).withOpacity(0.6), BlendMode.darken), // Añade una capa oscura semi-transparente
            ),
          ),
          child: const Center(
            child: Text(
              "¡Bienvenido!",
              style: TextStyle(
                fontSize: 24, // Tamaño de fuente ajustable según tus preferencias
                fontWeight: FontWeight.bold, // Puedes ajustar el peso de la fuente según lo desees
                color: Colors.white, // Color del texto
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawer() => Drawer(
        child: ListView(
          children: _menuItems
              .map((item) => ListTile(
                    onTap: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                    title: Text(item),
                  ))
              .toList(),
        ),
      );

  Widget _navBarItems() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _menuItems
            .map(
              (item) => InkWell(
                onTap: () {},
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
    return PopupMenuButton<Menu>(
      icon: const Icon(Icons.person, color: Color(0xFF094293)), // Asigna el color blanco al icono
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder( // Ajusta los bordes
        borderRadius: BorderRadius.circular(8), // Radio de borde
      ),
      color: Color.fromARGB(255, 255, 255, 255), // Fondo blanco
      onSelected: (Menu item) {},
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        const PopupMenuItem<Menu>(
          value: Menu.itemOne,
          child: ListTile(
            title: Text('Cuenta'),
          ),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.itemThree,
          child: ListTile(
            title: Text('Cerrar Sesión'),
          ),
        ),
      ],
    );
  }
}
