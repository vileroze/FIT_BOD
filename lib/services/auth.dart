import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static String verificationId = '';
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;
  AuthService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'user not found !';
      }
      if (e.code == 'wrong-password') {
        return 'Incorrect password provided !';
      }

      return '';
    }
  }

  Future<String> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);

      return '';
    } on FirebaseAuthException catch (e) {
      return e.code.toString();
    }
  }

  // Future<String> signUp(
  //     {required String name,
  //     required String usertype,
  //     required String email,
  //     required String password,
  //     required String phoneNumber}) async {
  //   String errs = '';

  //   try {
  //     await _firebaseAuth.createUserWithEmailAndPassword(
  //         email: email, password: password);

  //     await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: '+977 ' + phoneNumber,
  //       timeout: const Duration(minutes: 2),
  //       verificationCompleted: (AuthCredential credential) async {
  //         await _firebaseAuth
  //             .signInWithCredential(credential)
  //             .then((user) async {
  //           await _firebaseStore
  //               .collection('users')
  //               .doc(_firebaseAuth.currentUser!.uid)
  //               .set(
  //             {
  //               'name': name,
  //               'userType': usertype,
  //               'email': email,
  //               'cellNumber': phoneNumber,
  //             },
  //             SetOptions(merge: true),
  //           );
  //         });
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         if (e.code == 'invalid-phone-number') {
  //           errs = 'The provided phone number is not valid';
  //         }
  //       },
  //       codeSent: (String verId, int? resendToken) async {
  //         verificationId = verId;
  //         // Update the UI - wait for the user to enter the SMS code
  //         // String smsCode = '111';

  //         // Create a PhoneAuthCredential with the code
  //         // PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //         //     verificationId: verificationId, smsCode: smsCode);

  //         // Sign the user in (or link) with the credential
  //         // await _firebaseAuth.signInWithCredential(credential);
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {},
  //     );

  //     if (errs == '') {
  //       return '';
  //     } else {
  //       return errs;
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       return 'user NOT FOUND !';
  //     }
  //     return '';
  //   }
  // }

}
