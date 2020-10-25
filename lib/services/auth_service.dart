import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_gallery/exceptions/exceptions.dart';
import 'package:flutterfire_gallery/models/models.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth _firebaseAuth;
  GoogleSignIn _googleSignIn;

  AuthService() {
    this._firebaseAuth = FirebaseAuth.instance;
    this._googleSignIn = new GoogleSignIn();
  }

  Future<UserModel> checkForUser() async {
    final User user = this._firebaseAuth.currentUser;

    if (user == null) {
      return null;
    } else {
      return new UserModel(uid: user.uid, emailAddress: user.email);
    }
  }

  Future<UserModel> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await this._googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
        await this._firebaseAuth.signInWithCredential(credential);

    return new UserModel(
      uid: userCredential.user.uid,
      emailAddress: userCredential.user.email,
    );
  }

  Future<UserModel> createUserWithEmailAndPassword(
      String emailAddress, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      return new UserModel(
        uid: userCredential.user.uid,
        emailAddress: userCredential.user.email,
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        throw new AuthException(
          message: 'The password provided is too weak.',
        );
      } else if (error.code == 'email-already-in-use') {
        throw new AuthException(
          message: 'The account already exists for that email.',
        );
      }

      return null;
    }
  }

  Future<UserModel> signInUserWithEmailAndPassword(
      String emailAddress, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      return new UserModel(
        uid: userCredential.user.uid,
        emailAddress: userCredential.user.email,
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        throw new AuthException(
          message: 'No user found for that email.',
        );
      } else if (error.code == 'wrong-password') {
        throw new AuthException(
          message: 'Wrong password provided for that user.',
        );
      }

      return null;
    }
  }

  Future<void> signOut() async {
    await this._firebaseAuth.signOut();
    await this._googleSignIn.signOut();
  }
}
