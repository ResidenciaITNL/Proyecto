import 'package:flutter/material.dart';
import 'package:labvymar/Views/recoverpass.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white, // Establecer el color de fondo blanco
      //------------------------------//
      //----------- Body -------------//
      //------------------------------//
        body: Center(
            child: isSmallScreen
                ? const Column(
                    
                    //------------------------------------------------------------------//
                    //----------- Columnas que hace llamado a las clases -------------//
                    //------------------------------------------------------------------//
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      
                      //--- Clases
                      _Logo(),
                      _FormContent(),
                    ],
                  )
                    //------------------------------------------------------------------------------------------------//
                    //----------- Contenedor que hace llamado a la logica del formulario y lo responsivo -------------//
                    //------------------------------------------------------------------------------------------------//
                : Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: const Row(
                      children: [
                        Expanded(child: _Logo()),
                        Expanded(
                          child: Center(child: _FormContent()),
                        ),
                      ],
                    ),
                  )  
                )
              );
  }
}

//---------------------------------------//
//----------- Clase de logo -------------//
//---------------------------------------//

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 700;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [ 
        SizedBox(
          width: isSmallScreen ? 200 : 300,
          height: isSmallScreen ? 200 : 300,
          child: Image.asset('assets/VYMAR.png'),
        ),
      ],
    );
  }
}

//-----------------------------------------------------------//
//----------- Clase Formulario de Inciar Sesión -------------//
//-----------------------------------------------------------//


class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;


      //-----------------------------------------//
      //----------- Título ----------------------//
      //-----------------------------------------//


  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      constraints: const BoxConstraints(maxWidth: 300),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //-----------------------------------------//
          //----------- Título ----------------------//
          //-----------------------------------------//
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Iniciar Sesión', // Texto del título
              style: TextStyle(
                fontSize: 25, // Tamaño del texto
                fontWeight: FontWeight.bold, // Negrita
                color: Colors.black, // Color del texto
              ),
            ),
          ),

          //-----------------------------------------//
          //----------- Input de email -------------//
          //-----------------------------------------//
          TextFormField(
            validator: (value) {
              //--------Validacion del correo electronico
              if (value == null || value.isEmpty) {
                return 'Favor de ingresar email';
              }

              bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value);
              if (!emailValid) {
                return 'Favor de ingresar un email valido';
              }

              return null;
            },
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'ejemplo@email.com',
              prefixIcon: Icon(Icons.email_outlined),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black), // Color del borde cuando está habilitado
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF094293)), // Color del borde cuando está enfocado
              ),
              labelStyle: TextStyle(
                color: Colors.black, // Color del labelText por defecto
              ),
            ),
          ),
          _gap(),

          //----------------------------------------------//
          //----------- Input de contraseña -------------//
          //----------------------------------------------//
          TextFormField(
            //-------Validacion de contraseña
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Favor de ingresar la contraseña';
              }

              if (value.length < 6) {
                return 'Contraseña debe cumplir con 6 mas caracteres';
              }
              return null;
            },
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
                labelText: 'Contraseña',
                hintText: '******',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Color del borde cuando está habilitado
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF094293)), // Color del borde cuando está enfocado
                ),
                labelStyle: const TextStyle(
                  color: Colors.black, // Color del labelText por defecto
                ),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )),
          ),
          _gap(),

          //---------------------------------------------------------//
          //----------- Checkbox de recordar contraseña -------------//
          //---------------------------------------------------------//
          CheckboxListTile(
            checkColor: Colors.white,
            activeColor: Color(0xFF094293),
            value: _rememberMe,
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _rememberMe = value;
              });
            },
            title: const Text('Recordar contraseña'),
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            contentPadding: const EdgeInsets.all(0),
          ),
          _gap(),

          //-----------------------------------------//
          //----------- Boton de submit -------------//
          //-----------------------------------------//
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF094293),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, ),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'home_admin');
                // if (_formKey.currentState?.validate() ?? false) {
                //   /// do something
                //   Navigator.pushReplacementNamed(context, 'home_admin');
                // }
              },
            ),
          ),
          _gap(),
          
          //-------------------------------------------------------------//
          //----------- Hyperbinculo a recuperar contraseña -------------//
          //-------------------------------------------------------------//
          SizedBox(
            width: double.infinity,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecoverPass()),
                  );
                },
                child: const Material(
                  color: Color.fromARGB(0, 0, 0, 0),
                  child: Center( // Centra el texto
                    child: Text(
                      'Recuperar contraseña',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF094293), // Cambia el color para que parezca un enlace
                        decoration: TextDecoration.underline, // Agrega subrayado al texto
                        decorationThickness: 2.0, // Ajusta el grosor de la línea de subrayado
                        decorationColor: const Color(0xFF094293), // Color de la línea de subrayado
                        decorationStyle: TextDecorationStyle.solid, // Estilo de la línea de subrayado
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}