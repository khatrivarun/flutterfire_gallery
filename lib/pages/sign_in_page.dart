import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_gallery/pages/home_page.dart';
import 'package:flutterfire_gallery/pages/login_page.dart';
import 'package:flutterfire_gallery/providers/providers.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  static final String routeName = "sign-in";

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _passwordAgain = new TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _passwordAgain.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider _authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(
          'Sign In',
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            labelText: "Enter your email address",
                          ),
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

                            if (value != this._passwordAgain.text) {
                              return 'Passwords do not match';
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
                          controller: _passwordAgain,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Enter your password again",
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Password is empty';
                            }

                            if (value != this._password.text) {
                              return 'Passwords do not match';
                            }

                            return null;
                          },
                        ),
                        FlatButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _scaffoldkey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text('Signing you in'),
                                ),
                              );

                              _authProvider
                                  .createUserWithEmailAndPassword(
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
                          child: Text('Sign in'),
                        ),
                        FlatButton(
                          onPressed: () {
                            _scaffoldkey.currentState.showSnackBar(
                              SnackBar(
                                content: Text('Signing you in'),
                              ),
                            );
                            _authProvider.signInWithGoogle().then((value) {
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
                          },
                          child: Text('Sign In With Google'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(LoginPage.routeName);
                },
                child: Text('Already have an account? Log in here.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
