import 'package:fitness_app/main.dart';
import 'package:fitness_app/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pinput/pinput.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class OtpValidator extends StatefulWidget {
  final String userName;
  final String userType;
  final String phoneNum;
  final String userEmail;
  final String userPassword;

  OtpValidator(this.userName, this.userType, this.phoneNum, this.userEmail,
      this.userPassword);
  @override
  State<OtpValidator> createState() => _OtpValidatorState();
}

class _OtpValidatorState extends State<OtpValidator> {
  final database = FirebaseDatabase.instance.ref();
  String _verificationID = '';
  Color accentColor = Colors.deepOrange.shade500;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  final TextEditingController otpController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  late String _verificationCode = '';
  String FCMToken = '';

  @override
  void initState() {
    super.initState();
    _verifyPhone();
    getToken();
  }

  void getToken() async {
    await FirebaseMessaging.instance
        .getToken()
        .then((token) => FCMToken = token.toString());
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(231, 88, 20, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(231, 88, 20, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: Color.fromRGBO(231, 88, 20, 1),
      ),
    );

    return Scaffold(
      key: _scaffoldkey,
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: accentColor, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 60,
                ),
                Text(
                  'OTP VERIFICATION',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.oswald(
                    color: accentColor,
                    fontSize: 25,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Pinput(
                  length: 6,
                  focusNode: _pinPutFocusNode,
                  controller: otpController,
                  pinAnimationType: PinAnimationType.fade,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  onCompleted: (pin) async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final cred = PhoneAuthProvider.credential(
                            verificationId: _verificationID,
                            smsCode: otpController.text);
                        await FirebaseAuth.instance
                            .signInWithCredential(cred)
                            .then((value) async {
                          if (value.user != null) {
                            final credential = EmailAuthProvider.credential(
                                email: widget.userEmail.toString().trim(),
                                password: widget.userPassword);

                            final userCredential = await FirebaseAuth
                                .instance.currentUser
                                ?.linkWithCredential(credential);

                            final userDetailsRef = database.child(
                                '/userDetails/' +
                                    FirebaseAuth.instance.currentUser!.uid);

                            if (widget.userType.toString().trim() ==
                                'Trainer') {
                              userDetailsRef.set({
                                'userName': widget.userName.toString().trim(),
                                'userType': widget.userType.toString().trim(),
                                'email': widget.userEmail.toString().trim(),
                                'phoneNumber':
                                    widget.phoneNum.toString().trim(),
                                'password':
                                    widget.userPassword.toString().trim(),
                                'profileImgUrl': '',
                                'coursesTaken': 0,
                                'verified': 'false',
                                'experience': '<1',
                                'FCMToken': FCMToken,
                              });
                            } else {
                              userDetailsRef.set({
                                'userName': widget.userName.toString().trim(),
                                'userType': widget.userType.toString().trim(),
                                'email': widget.userEmail.toString().trim(),
                                'phoneNumber':
                                    widget.phoneNum.toString().trim(),
                                'password':
                                    widget.userPassword.toString().trim(),
                                'profileImgUrl': '',
                                'coursesTaken': 0,
                                'age': 'N/A',
                                'height': 'N/A',
                                'weight': 'N/A',
                              });
                            }

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => SignIn(),
                                ),
                                (route) => false);
                          }
                        });
                      } on FirebaseAuthException catch (e) {
                        String errMsg = '';
                        print('rrrrrrrrrrrrrrrrr    ' + e.code);
                        if (e.code == 'unknown') {
                          errMsg =
                              'Credentials already linked to another account.\nTry signing in or resetting your password!';
                        } else if (e.code == 'email-already-in-use') {
                          errMsg =
                              'Credentials already linked to another account.\nTry signing in or resetting your password!';
                        } else if (e.code == 'invalid-verification-id') {
                          errMsg = 'Check credentials and try again!';
                        } else {
                          errMsg = 'Invalid PIN entered!';
                        }
                        FocusScope.of(context).unfocus();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(
                                bottom: 20, right: 20, left: 20),
                            content: Text(
                              errMsg,
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 10),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => AuthWrapper(),
                            ),
                            (route) => false);
                      },
                      child: const Text(
                        'Sign In',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                            fontSize: 18),
                      ),
                      style: const ButtonStyle(),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    const Icon(Icons.arrow_circle_right),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+977 ' + widget.phoneNum,
      timeout: const Duration(minutes: 2),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SignIn()),
                (route) => false);
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verId, int? resendToken) async {
        setState(() {});
        _verificationID = verId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationID = verificationId;
        });
      },
    );
  }
}
