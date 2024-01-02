import 'package:budget_planning/services/auth_service.dart';
import 'package:budget_planning/widgets/auth/log_in.dart';
import 'package:budget_planning/widgets/utils/app_validator.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _userNameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  var authService = AuthService();
  var isLoader = false;
  final appValidator = AppValidator();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      var data = {
        'username': _userNameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'remainingAmount': 0,
        'totalCredit': 0,
        'totalDebit': 0,
      };
      await authService.createUser(data, context);

      // ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
      //   const SnackBar(content: Text('Form submitted successfully')),
      // );
      setState(() {
        isLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final TextEditingController _password = TextEditingController();

    // ignore: prefer_const_declarations
    final style = const TextStyle(
      color: Colors.white,
    );

    return Scaffold(
      backgroundColor: const Color(0xff252634),
      // appBar: AppBar(
      //   title: const Text('my form'),
      // ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 250,
                    child: Text(
                      'Создать новый аккаунт',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    controller: _userNameController,
                    style: style,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration('Username', Icons.person),
                    validator: appValidator.validateUsername,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    style: style,
                    obscuringCharacter: '*',
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration('Password', Icons.lock),
                    validator: (value) {
                      return appValidator.validatePassword(
                          value!.trim(), _passwordController.text.trim());
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    style: style,
                    obscuringCharacter: '*',
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _passwordController,
                    decoration:
                        _buildInputDecoration('Confirm Password', Icons.lock),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: style,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration('Email', Icons.email),
                    validator: appValidator.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(191, 151, 0, 1),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onPressed: () {
                        isLoader ? print('Loading') : _submitForm();
                      },
                      child: isLoader
                          ? const Center(child: CircularProgressIndicator())
                          : const Text('Create'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LogIn()),
                      );
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration _buildInputDecoration(String name, IconData icon) {
  return InputDecoration(
    fillColor: const Color(0xAA494A59),
    filled: true,
    enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF949494))),
    focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255))),
    labelStyle: const TextStyle(color: Color(0xFF949494)),
    labelText: name,
    suffixIcon: Icon(
      icon,
      color: const Color(0xFF949494),
    ),
  );
}
