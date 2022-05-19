import 'package:fitness_app/extra/color.dart';
import 'package:fitness_app/main.dart';
import 'package:fitness_app/screens/authenticate/otp_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController userTypeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String initialCountry = 'NP';
  PhoneNumber number = PhoneNumber(isoCode: 'NP');
  String dropdownValue = 'Client';
  final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var _currentSelectedValue;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/auth_page/signup2.jpg'),
            fit: BoxFit.cover),
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: Colors.transparent),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: Form(
            key: _formKey,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      left: (MediaQuery.of(context).size.width * 0.3),
                      top: size.height / 14),
                  child: Text(
                    'Welcome!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.josefinSans(
                      color: Colors.black,
                      fontSize: 42,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: (MediaQuery.of(context).size.width * 0.1),
                      top: size.height / 8),
                  child: Text(
                    'Join us today to start your fitness journey.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.josefinSans(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.2),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(25)),
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            padding: const EdgeInsets.only(
                                top: 15, left: 10, right: 10),
                            child: Column(
                              children: [
                                TextFormField(
                                  style: const TextStyle(color: Colors.black),
                                  controller: nameController,
                                  validator: (value) {
                                    if (value == '') {
                                      return 'Name can\'t be empty';
                                    }
                                  },
                                  decoration: inputDecor('Full Name'),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  height: 65,
                                  child: InputDecorator(
                                    decoration: inputDecor('User Type'),
                                    child: DropdownButton<String>(
                                      value: dropdownValue,
                                      isExpanded: true,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      elevation: 0,
                                      underline: Container(
                                        height: 0,
                                      ),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownValue = newValue!;
                                        });
                                      },
                                      items: <String>['Client', 'Trainer']
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  style: const TextStyle(color: Colors.black),
                                  controller: emailController,
                                  validator: (value) {
                                    if (value != '') {
                                      if (!(RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value!))) {
                                        return 'Invalid email';
                                      }
                                    } else {
                                      return 'Email can\'t be empty';
                                    }
                                  },
                                  decoration: inputDecor('Email'),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                InternationalPhoneNumberInput(
                                  onInputChanged: (PhoneNumber number) {
                                    print(number.phoneNumber);
                                  },
                                  onInputValidated: (bool value) {
                                    print(value);
                                  },
                                  selectorConfig: const SelectorConfig(
                                    selectorType:
                                        PhoneInputSelectorType.BOTTOM_SHEET,
                                  ),
                                  ignoreBlank: false,
                                  autoValidateMode: AutovalidateMode.disabled,
                                  selectorTextStyle:
                                      const TextStyle(color: Colors.black),
                                  initialValue: number,
                                  textFieldController: phoneController,
                                  formatInput: false,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          signed: true, decimal: true),
                                  inputBorder: OutlineInputBorder(),
                                  onSaved: (PhoneNumber number) {
                                    print('On Saved: $number');
                                  },
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  style: const TextStyle(color: Colors.black),
                                  controller: passwordController,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value != '') {
                                      if (value!.length < 6) {
                                        return 'Password must be atl leat 6 characters long';
                                      } else {
                                        if (value.contains(RegExp(r'[0-9]')) ==
                                            false) {
                                          return 'Password must contain atleast 1 number';
                                        }
                                      }
                                    } else {
                                      return 'Password can\'t be empty';
                                    }
                                  },
                                  decoration: inputDecor('Password'),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.orange.shade900,
                                      child: IconButton(
                                        color: Colors.white,
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OtpValidator(
                                                  nameController.text,
                                                  dropdownValue,
                                                  phoneController.text,
                                                  emailController.text,
                                                  passwordController.text,
                                                ),
                                              ),
                                            );
                                          } else {}
                                        },
                                        icon: const Icon(
                                          Icons.message_outlined,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AuthWrapper(),
                                                ),
                                                (route) => false);
                                      },
                                      child: Text(
                                        'Sign In',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.orange.shade900,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecor(String hint) {
    return InputDecoration(
      filled: false,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: Colors.orange.shade700),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: Colors.orange.shade700),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(color: Colors.orange.shade700),
      ),
      labelText: hint,
      labelStyle: TextStyle(color: Colors.orange.shade700),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
