import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/auth/data/models/user_model.dart';
import '../errors/exceptions.dart';

/// Firebase Authentication Service
class FirebaseAuthService {
  static final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /// Get current user
  firebase_auth.User? get currentUser => _auth.currentUser;
  
  /// Get auth state changes stream
  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();
  
  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;
  
  /// Sign in with email and password
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    print('========= signInWithEmailAndPassword');

    try {
      print('========= signInWithEmailAndPassword 1');

      final firebase_auth.UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user == null) {
        print('========= user == null');
        throw const AuthException(
          message: 'Sign in failed',
          code: 'SIGN_IN_FAILED',
        );
      }

      print('========= user != null: ${userCredential.user?.email}');
      
      // Get user data from Firestore
      final userData = await _getUserData(userCredential.user!.uid);
      print("========= userData: ${userData.email}");
      return userData;
      
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('==== FirebaseAuthException');
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      print('==== FirebaseAuthException 2: $e');
      throw AuthException(
        message: 'An unexpected error occurred: $e',
        code: 'UNKNOWN_ERROR',
      );
    }
  }
  
  /// Sign up with email and password
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final firebase_auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (userCredential.user == null) {
        throw const AuthException(
          message: 'Sign up failed',
          code: 'SIGN_UP_FAILED',
        );
      }
      
      // Update display name
      await userCredential.user!.updateDisplayName(name);
      
      // Create user document in Firestore
      final userModel = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await _createUserDocument(userModel);
      return userModel;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthException(
        message: 'An unexpected error occurred: $e',
        code: 'UNKNOWN_ERROR',
      );
    }
  }
  
  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException(
        message: 'Sign out failed: $e',
        code: 'SIGN_OUT_FAILED',
      );
    }
  }
  
  /// Get current user data
  Future<UserModel?> getCurrentUserData() async {
    try {
      final user = currentUser;
      if (user == null) return null;
      
      return await _getUserData(user.uid);
    } catch (e) {
      print('========= getCurrentUserData error: $e, falling back to Firebase Auth user');
      // Fallback: Create user data from Firebase Auth user
      final user = currentUser;
      if (user == null) return null;
      
      return _createUserFromFirebaseAuth(user.uid);
    }
  }
  
  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw AuthException(
        message: 'Failed to send password reset email: $e',
        code: 'PASSWORD_RESET_FAILED',
      );
    }
  }
  
  /// Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw const AuthException(
          message: 'No user signed in',
          code: 'NO_USER',
        );
      }
      
      await user.updateDisplayName(displayName);
      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }
      
      // Update user document in Firestore
      await _updateUserDocument(user.uid, {
        if (displayName != null) 'name': displayName,
        if (photoURL != null) 'avatar': photoURL,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw AuthException(
        message: 'Failed to update profile: $e',
        code: 'UPDATE_PROFILE_FAILED',
      );
    }
  }
  
  /// Get user data from Firestore
  Future<UserModel> _getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      
      if (!doc.exists) {
        // Fallback: Create user data from Firebase Auth user
        print('========= Firestore document not found, creating from Firebase Auth user');
        return _createUserFromFirebaseAuth(uid);
      }
      
      final data = doc.data()!;
      return UserModel.fromJson({
        'id': uid,
        'email': data['email'] ?? '',
        'name': data['name'] ?? '',
        'avatar': data['avatar'],
        'phoneNumber': data['phoneNumber'],
        'dateOfBirth': data['dateOfBirth']?.toDate(),
        'createdAt': data['createdAt']?.toDate(),
        'updatedAt': data['updatedAt']?.toDate(),
      });
    } catch (e) {
      print('========= Firestore error: $e, falling back to Firebase Auth user');
      // Fallback: Create user data from Firebase Auth user
      return _createUserFromFirebaseAuth(uid);
    }
  }
  
  /// Create user data from Firebase Auth user (fallback)
  UserModel _createUserFromFirebaseAuth(String uid) {
    final user = currentUser;
    if (user == null) {
      throw const AuthException(
        message: 'No user found in Firebase Auth',
        code: 'NO_USER_FOUND',
      );
    }
    
    return UserModel(
      id: uid,
      email: user.email ?? '',
      name: user.displayName ?? 'User',
      avatar: user.photoURL,
      phoneNumber: user.phoneNumber,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
  
  /// Create user document in Firestore
  Future<void> _createUserDocument(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set({
        'email': user.email,
        'name': user.name,
        'avatar': user.avatar,
        'phoneNumber': user.phoneNumber,
        'dateOfBirth': user.dateOfBirth,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw AuthException(
        message: 'Failed to create user document: $e',
        code: 'CREATE_USER_DOCUMENT_FAILED',
      );
    }
  }
  
  /// Update user document in Firestore
  Future<void> _updateUserDocument(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      throw AuthException(
        message: 'Failed to update user document: $e',
        code: 'UPDATE_USER_DOCUMENT_FAILED',
      );
    }
  }
  
  /// Handle Firebase Auth exceptions
  AppException _handleFirebaseAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return const InvalidCredentialsException(
          message: 'No user found with this email',
          code: 'USER_NOT_FOUND',
        );
      case 'wrong-password':
        return const InvalidCredentialsException(
          message: 'Wrong password provided',
          code: 'WRONG_PASSWORD',
        );
      case 'email-already-in-use':
        return const AuthException(
          message: 'Email is already in use',
          code: 'EMAIL_ALREADY_IN_USE',
        );
      case 'weak-password':
        return const AuthException(
          message: 'Password is too weak',
          code: 'WEAK_PASSWORD',
        );
      case 'invalid-email':
        return const AuthException(
          message: 'Invalid email address',
          code: 'INVALID_EMAIL',
        );
      case 'user-disabled':
        return const AuthException(
          message: 'User account has been disabled',
          code: 'USER_DISABLED',
        );
      case 'too-many-requests':
        return const AuthException(
          message: 'Too many requests. Please try again later',
          code: 'TOO_MANY_REQUESTS',
        );
      case 'network-request-failed':
        return const NetworkException(
          message: 'Network error. Please check your connection',
          code: 'NETWORK_ERROR',
        );
      default:
        return AuthException(
          message: e.message ?? 'Authentication failed',
          code: e.code,
        );
    }
  }
}
