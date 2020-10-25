import 'package:flutter/foundation.dart';
import 'package:flutterfire_gallery/models/models.dart';
import 'package:flutterfire_gallery/services/services.dart';

class AuthProvider with ChangeNotifier {
  AuthService _authService;
  UserModel userModel;

  AuthProvider() {
    this._authService = new AuthService();
  }

  Future<UserModel> checkForUser() async {
    this.userModel = await this._authService.checkForUser();

    notifyListeners();

    return this.userModel;
  }

  Future<UserModel> signInWithGoogle() async {
    this.userModel = await this._authService.signInWithGoogle();

    notifyListeners();

    return this.userModel;
  }

  Future<UserModel> createUserWithEmailAndPassword(
      String emailAddress, String password) async {
    this.userModel = await this
        ._authService
        .createUserWithEmailAndPassword(emailAddress, password);

    notifyListeners();

    return this.userModel;
  }

  Future<UserModel> signInWithEmailAndPassword(
      String emailAddress, String password) async {
    this.userModel = await this
        ._authService
        .signInUserWithEmailAndPassword(emailAddress, password);

    notifyListeners();

    return this.userModel;
  }

  Future<void> signOut() async {
    await this._authService.signOut();
  }
}
