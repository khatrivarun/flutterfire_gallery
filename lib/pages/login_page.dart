import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_gallery/pages/home_page.dart';
import 'package:flutterfire_gallery/pages/sign_in_page.dart';
import 'package:flutterfire_gallery/providers/providers.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static final String routeName = "log-in";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthProvider _authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(
          'Log In',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          autofocus: true,
                          controller: _email,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Enter your email address"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Email address is empty';
                            }

                            if (!EmailValidator.validate(value)) {
                              return 'Please enter a valid email address';
                            }

                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          autofocus: true,
                          obscureText: true,
                          controller: _password,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Enter your password",
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Password is empty';
                            }

                            return null;
                          },
                        ),
                        FlatButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _scaffoldkey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text('Logging you in'),
                                ),
                              );

                              _authProvider
                                  .signInWithEmailAndPassword(
                                _email.text,
                                _password.text,
                              )
                                  .then((value) {
                                if (value != null) {
                                  Navigator.of(context)
                                      .pushReplacementNamed(HomePage.routeName);
                                }
                              }).catchError((error) {
                                _scaffoldkey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text(error.message),
                                    action: SnackBarAction(
                                      label: "OKAY",
                                      onPressed: () {},
                                    ),
                                  ),
                                );
                              });
                            }
                          },
                          child: Text('Log in'),
                        ),
                        FlatButton(
                          onPressed: () {
                            _authProvider.signInWithGoogle().then((value) {
                              if (value != null) {
                                Navigator.of(context)
                                    .pushReplacementNamed(HomePage.routeName);
                              }

                              _scaffoldkey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text('Logging you in'),
                                ),
                              );
                            }).catchError((error) {
                              _scaffoldkey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text(error.message),
                                  action: SnackBarAction(
                                    label: "OKAY",
                                    onPressed: () {},
                                  ),
                                ),
                              );
                            });
                          },
                          child: Text('Log In With Google'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(SignInPage.routeName);
                },
                child: Text('Don\'t have an account? Sign in here.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
