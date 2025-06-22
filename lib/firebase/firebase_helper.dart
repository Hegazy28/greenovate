import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseHelper {
  static final FirebaseHelper _instance = FirebaseHelper._internal();

  factory FirebaseHelper() => _instance;

  FirebaseHelper._internal();

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Get database reference
  DatabaseReference get databaseRef => _database.ref();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Initialize Firebase
  static Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      print('Firebase initialized successfully');
    } catch (e) {
      print('Error initializing Firebase: $e');
      throw e;
    }
  }

  // Sign in with email and password
  static Future<User?> signIn(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided.';
      } else {
        throw e.message ?? 'An error occurred during sign in.';
      }
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  // Sign up with email and password
  static Future<User?> signUp(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'An account already exists for that email.';
      } else {
        throw e.message ?? 'An error occurred during sign up.';
      }
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Error signing out: $e';
    }
  }

  // Reset password
  static Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else {
        throw e.message ?? 'An error occurred sending password reset email.';
      }
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  // Update user profile
  static Future<void> updateUserProfile(
      {String? displayName, String? photoURL}) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoURL);
        await user.reload();
      } else {
        throw 'No user is currently signed in.';
      }
    } catch (e) {
      throw 'Error updating profile: $e';
    }
  }

  // Delete user account
  static Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
      } else {
        throw 'No user is currently signed in.';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw 'Please re-authenticate before deleting your account.';
      } else {
        throw e.message ?? 'An error occurred deleting the account.';
      }
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  // Re-authenticate user (needed for sensitive operations)
  static Future<void> reauthenticate(String email, String password) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
      } else {
        throw 'No user is currently signed in.';
      }
    } catch (e) {
      throw 'Error re-authenticating: $e';
    }
  }

  // Realtime Database operations

  // Write data
  static Future<void> writeData(String path, dynamic data) async {
    try {
      await _database.ref(path).set(data);
    } catch (e) {
      throw 'Error writing data: $e';
    }
  }

  // Update data
  static Future<void> updateData(
      String path, Map<String, dynamic> updates) async {
    try {
      await _database.ref(path).update(updates);
    } catch (e) {
      throw 'Error updating data: $e';
    }
  }

  // Push data (auto-generated key)
  static Future<String?> pushData(String path, dynamic data) async {
    try {
      final newRef = _database.ref(path).push();
      await newRef.set(data);
      return newRef.key;
    } catch (e) {
      throw 'Error pushing data: $e';
    }
  }

  // Read data once
  static Future<dynamic> readDataOnce(String path) async {
    try {
      final snapshot = await _database.ref(path).once();
      return snapshot.snapshot.value;
    } catch (e) {
      throw 'Error reading data: $e';
    }
  }

  // Delete data
  static Future<void> deleteData(String path) async {
    try {
      await _database.ref(path).remove();
    } catch (e) {
      throw 'Error deleting data: $e';
    }
  }

  // Listen to child added
  static Stream<DatabaseEvent> listenToChildAdded(String path) {
    return _database.ref(path).onChildAdded;
  }

  // Listen to child changed
  static Stream<DatabaseEvent> listenToChildChanged(String path) {
    return _database.ref(path).onChildChanged;
  }

  // Listen to child removed
  static Stream<DatabaseEvent> listenToChildRemoved(String path) {
    return _database.ref(path).onChildRemoved;
  }

  // Listen to data changes
  static Stream<List<int>> listenToDeviceChanges() {
    return _database.ref('/Actuators_num').onValue.map((event) {
      final data = event.snapshot.value;

      if (data == null) return <int>[];

      // If the data is already a list
      if (data is List) {
        return data.map((e) => int.parse(e.toString())).toList();
      }

      // If the data is a comma-separated string
      if (data is String) {
        return data.split(',').map((e) => int.parse(e.trim())).toList();
      }

      // If it's a single number
      if (data is num) {
        return data
            .toString()
            .split('')
            .map((digit) => int.parse(digit))
            .toList();
      }

      return <int>[];
    });
  }

  // Listen to data changes
  static Stream<double> listenToData(String path) {
    return _database.ref(path).onValue.map((event) {
      final data = event.snapshot.value;

      if (data == null) return 0.0;

      // If the data is already a double
      if (data is double) {
        return data;
      }

      // If the data is a string that can be parsed to double
      if (data is String) {
        final parsedValue = double.tryParse(data);
        return parsedValue ?? 0.0;
      }

      // If the data is a number
      if (data is num) {
        return data.toDouble();
      }

      return 0.0; // Default value if none of the above
    });
  }

  // Update data
  static Future<void> updateDevices(int newValue) async {
    try {
      await _database.ref('/Actuators_num').set(newValue);
    } catch (e) {
      throw 'Error updating data: $e';
    }
  }
}
