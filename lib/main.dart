import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_gallery/pages/pages.dart';
import 'package:flutterfire_gallery/providers/providers.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(new Root());
}

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>(
                create: (context) => AuthProvider(),
              ),
              ChangeNotifierProxyProvider<AuthProvider, ImagesProvider>(
                create: (_) => new ImagesProvider(
                  userId: null,
                ),
                update: (context, value, previous) {
                  if (value != null)
                    return ImagesProvider(
                      userId: value.userModel != null
                          ? value.userModel.uid
                          : previous.userId,
                    );
                  else
                    return ImagesProvider(userId: null);
                },
              ),
            ],
            child: MaterialApp(
              title: 'FlutterFire Gallery',
              debugShowCheckedModeBanner: false,
              routes: {
                SignInPage.routeName: (context) => SignInPage(),
                LoginPage.routeName: (context) => LoginPage(),
                HomePage.routeName: (context) => HomePage(),
                ImagePage.routeName: (context) => ImagePage(),
              },
              home: SplashPage(),
            ),
          );
        }

        if (snapshot.hasError) {
          print("error");
        }

        return MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
