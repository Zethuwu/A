import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Registro con correo y contraseña
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Manejo de errores específicos de FirebaseAuth
      print('Error en registro: ${e.message}');
      throw e; // Lanza el error para ser manejado en el lugar donde se llama
    }
  }

  // Inicio de sesión con correo y contraseña
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Manejo de errores específicos de FirebaseAuth
      print('Error en inicio de sesión: ${e.message}');
      throw e; // Lanza el error para ser manejado en el lugar donde se llama
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
