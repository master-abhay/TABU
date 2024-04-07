import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  AuthServices() {
    _firebaseAuth.authStateChanges().listen(authStateChangesStreamListener);
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;
  User? get user {
    return _user;
  }

  Future<bool> login(String email, String password) async {
    try {
      final _creadential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (_creadential.user != null) {
        _user = _creadential.user;
        print("printing user form the auth services class ${_user}");
        return true;
      }
    } catch (e) {
      print("Error while signing in $e");
    }
    return false;
  }

  Future<bool> logOut() async {
    try {
      _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> register(String email, String password) async {
    try {
      final _credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (_credential.user != null) {
        _user = _credential.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  void authStateChangesStreamListener(User? user) {
    if (user != null) {
      _user = user;
    } else {
      user = null;
    }
  }
}
