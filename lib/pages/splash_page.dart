import 'package:flutter/material.dart';
import 'package:flutterfire_gallery/pages/pages.dart';
import 'package:flutterfire_gallery/providers/providers.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Provider.of<AuthProvider>(context, listen: false)
        .checkForUser()
        .catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('An Error Occurred'),
          content: Text(
              'An error occurred when signing you in. Please try signing in again.'),
          actions: [
            FlatButton(
              child: Text('OKAY'),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
              },
            )
          ],
        ),
      );
    }).then((value) {
      if (value == null) {
        Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
