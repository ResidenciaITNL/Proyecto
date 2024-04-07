import 'package:flutter/material.dart';
import 'package:labvymar/Views/AdministrarUsuarios.dart';
import 'package:labvymar/Views/ConsultaMedica.dart';
import 'package:labvymar/Views/EstudioMedico.dart';
import 'package:labvymar/Views/InventarioMedicamento.dart';
import 'package:labvymar/Views/Recepcion.dart';
import 'package:labvymar/Views/login.dart';

class CuentaUser extends StatelessWidget {
  CuentaUser({Key? key}) : super(key: key);

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
          color: Colors.white,
          child: Center(
            child: Container(
              width: 410,
              margin: const EdgeInsets.only(top: 25),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Información de la cuenta",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 50),
                  _nameRow("Jorge Cantú"),
                  const SizedBox(height: 25),
                  _buildInfoRow(
                      "Correo electrónico", "jorge.c@example.com", context),
                  const SizedBox(height: 15),
                  _buildInfoRow("Número de teléfono", "+528121041241", context),
                  const SizedBox(height: 15),
                  _buildInfoRow("Contraseña", "************", context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _nameRow(String label) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Color(0xFF094293),
              ),
              onPressed: () {
                // Implementar la lógica de edición aquí
                if (label == "Correo electrónico") {
                  _showEditEmailDialog(context, value);
                } else if (label == "Número de teléfono") {
                  _showEditPhoneDialog(context, value);
                } else if (label == "Contraseña") {
                  _showEditPasswordDialog(context, value);
                }
              },
            ),
          ],
        );
      },
    );
  }

void _showEditEmailDialog(BuildContext context, String currentValue) {
  TextEditingController _emailController = TextEditingController(text: currentValue);
  TextEditingController _newEmailController = TextEditingController();
  TextEditingController _confirmEmailController = TextEditingController();
  bool _isEmailValid = false;

  // Función para validar el correo electrónico
  void _validateEmail(String value) {
    // Utilizamos una expresión regular para validar el formato del correo electrónico
    bool isValidFormat = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
    // Actualizamos el estado de la validez del correo electrónico
    _isEmailValid = isValidFormat && _newEmailController.text == _confirmEmailController.text;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Editar correo electrónico"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _emailController,
                  enabled: false,
                  decoration: const InputDecoration(
                    hintText: "Correo electrónico actual",
                  ),
                ),
                TextField(
                  controller: _newEmailController,
                  onChanged: (value) {
                    setState(() {
                      _validateEmail(value);
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: "Ingrese el nuevo correo electrónico",
                  ),
                ),
                TextField(
                  controller: _confirmEmailController,
                  onChanged: (value) {
                    setState(() {
                      _validateEmail(value);
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: "Confirme el nuevo correo electrónico",
                  ),
                ),
                if (!_isEmailValid)
                  const Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: Text(
                      "Los correos electrónicos deben coincidir y tener un formato válido.",
                      style: TextStyle(color: Colors.red,),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                },
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: _isEmailValid
                    ? () {
                        // Aquí puedes realizar la lógica para guardar el nuevo correo electrónico
                        String newEmail = _newEmailController.text;
                        // Por ahora, simplemente imprimo el nuevo correo electrónico
                        print("Nuevo correo electrónico: $newEmail");
                        Navigator.of(context).pop(); // Cerrar el diálogo
                      }
                    : null,
                style: ButtonStyle(
                  backgroundColor: _isEmailValid
                      ? MaterialStateProperty.all<Color>(const Color(0xFF094293)) // Color del botón de guardar
                      : MaterialStateProperty.all<Color>(const Color(0xFFBBDEFB)), // Color de botón desactivado
                ),
                child: const Text(
                  "Guardar",
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




  void _showEditPasswordDialog(BuildContext context, String currentValue) {
    TextEditingController _currentPasswordController = TextEditingController();
    TextEditingController _newPasswordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();

    bool _isPasswordValid = false;

    // Función para validar si la contraseña cumple con los requisitos
    void _validatePassword(String value) {
      if (value.length >= 8 &&
          value.contains(RegExp(r'[A-Z]')) &&
          value.contains(RegExp(r'[a-z]')) &&
          value.contains(RegExp(r'[0-9]'))) {
        _isPasswordValid = true;
      } else {
        _isPasswordValid = false;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white, // Fondo blanco del AlertDialog
              title: const Text("Editar contraseña"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _currentPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Contraseña actual",
                    ),
                  ),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        _validatePassword(value);
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Nueva contraseña",
                    ),
                  ),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        _validatePassword(value);
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Confirmar nueva contraseña",
                    ),
                  ),
                  if (!_isPasswordValid)
                    const Text(
                      "\nRequisitos de la contraseña:\n- Mínimo de 8 caracteres\n- Mayúsculas, minúsculas y un número",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo
                  },
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: _isPasswordValid
                      ? () {
                          // Verificar si las contraseñas coinciden
                          if (_newPasswordController.text ==
                              _confirmPasswordController.text) {
                            // Aquí puedes realizar la lógica para guardar la nueva contraseña
                            String newPassword = _newPasswordController.text;
                            // Por ahora, simplemente imprimo la nueva contraseña
                            print("Nueva contraseña: $newPassword");
                            Navigator.of(context).pop(); // Cerrar el diálogo
                          } else {
                            // Mostrar mensaje si las contraseñas no coinciden
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Las contraseñas no coinciden."),
                              ),
                            );
                          }
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: _isPasswordValid
                        ? MaterialStateProperty.all<Color>(const Color(
                            0xFF094293)) // Color del botón de guardar
                        : MaterialStateProperty.all<Color>(const Color(
                            0xFFBBDEFB)), // Color de botón desactivado
                  ),
                  child: const Text(
                    "Guardar",
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

  void _showEditPhoneDialog(BuildContext context, String currentValue) {
    TextEditingController _phoneController =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Verifica tu número de teléfono celular."),
          content: TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              hintText: "Ingrese el nuevo número de teléfono celular",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes realizar la lógica para guardar el nuevo número de teléfono celular
                String newPhone = _phoneController.text;
                // Por ahora, simplemente imprimo el nuevo número de teléfono celular
                print("Nuevo número de teléfono celular: $newPhone");
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFF094293)) // Color del botón de guardar
                  ),
              child: const Text(
                "Guardar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
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
                MaterialPageRoute(builder: (context) => const Login()),
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
