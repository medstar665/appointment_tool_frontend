import 'package:flutter/material.dart';
import 'package:medstar_appointment/services/user_management.dart';
import 'package:medstar_appointment/utility/constants.dart';
import 'package:medstar_appointment/view/desktop/desktop_home.dart';
import 'package:provider/provider.dart';

class DesktopLogin extends StatefulWidget {
  const DesktopLogin({super.key});

  @override
  State<DesktopLogin> createState() => _DesktopLoginState();
}

class _DesktopLoginState extends State<DesktopLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  bool loggingIn = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: size.width * 0.4,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    } else if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _email = newValue;
                  },
                  decoration: Constants.textDecoration.copyWith(
                    labelText: 'Email',
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: size.width * 0.4,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 6) {
                      return 'Please enter a valid password';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _password = newValue;
                  },
                  decoration: Constants.textDecoration.copyWith(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 35,
                width: 100,
                child: Consumer<UserManagement>(builder: (_, provider, __) {
                  return ElevatedButton(
                    onPressed: loggingIn
                        ? () {}
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                loggingIn = true;
                              });
                              _formKey.currentState!.save();
                              String? resp =
                                  await provider.login(_email!, _password!);
                              if (resp != null) {
                                setState(() {
                                  loggingIn = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(resp)),
                                );
                                _formKey.currentState!.reset();
                              }
                            }
                          },
                    child: loggingIn
                        ? const SizedBox(
                            height: 30,
                            width: 30,
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(fontSize: 20),
                          ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
