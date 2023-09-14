import 'package:firebase_auth/firebase_auth.dart';

Future<UserCredential?> guestSignIn() async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    return userCredential;
  } catch (e) {
    print("Login failed: $e");
    return null;
  }
}
