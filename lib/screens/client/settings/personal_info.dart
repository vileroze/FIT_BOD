import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({Key? key}) : super(key: key);

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _database = FirebaseDatabase.instance.ref();

  String age = '';
  String height = '';
  String weight = '';

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {
    final userUrlRef = _database
        .child('/userDetails/' + FirebaseAuth.instance.currentUser!.uid + '/')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);

        final String uAge =
            data['age'] == 'N/A' ? 'N/A' : data['age'] as String;
        final String uHeight =
            data['height'] == 'N/A' ? 'N/A' : data['height'] as String;
        final String uWeight =
            data['weight'] == 'N/A' ? 'N/A' : data['weight'] as String;

        setState(() {
          age = uAge;
          height = uHeight;
          weight = uWeight;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.deepOrange[50],
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Extra.accentColor, //change your color here
          ),
          title: Text(
            'PERSONAL INFO',
            style: TextStyle(
              fontSize: size.width / 27,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              letterSpacing: 2.0,
              color: Extra.accentColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepOrange[50],
          elevation: 0.0,
        ),
        body: Container(
          width: size.width / 1.5,
          margin: EdgeInsets.only(left: size.width / 5.5, top: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                formField('Age', ageController, 'years'),
                SizedBox(
                  height: 20,
                ),
                formField('Weight', weightController, 'pounds'),
                SizedBox(
                  height: 20,
                ),
                formField('Height', heightController, 'cms'),
                SizedBox(
                  height: 20,
                ),
                IconButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      int flag = 0;
                      checkBioUpdate('age', flag, ageController, age);
                      checkBioUpdate('weight', flag, weightController, weight);
                      checkBioUpdate('height', flag, heightController, height);
                      if (flag == 1) {
                        Fluttertoast.showToast(
                            msg: "Biometrics updated!", // message
                            toastLength: Toast.LENGTH_SHORT, // length
                            gravity: ToastGravity.TOP, // location
                            timeInSecForIosWeb: 1,
                            backgroundColor: Extra.accentColor,
                            textColor: Colors.white,
                            fontSize: 16.0 // duration
                            );
                      }
                    }
                  },
                  icon: Icon(
                    Icons.done_all_outlined,
                    size: 53,
                    color: Extra.accentColor,
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Text(
                  'BIOMETRICS',
                  style: TextStyle(
                      fontSize: 20,
                      color: Extra.accentColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'AGE: ' + age + ' years',
                  style: TextStyle(fontSize: 17, color: Extra.accentColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'HEIGHT: ' + height + ' cms',
                  style: TextStyle(fontSize: 17, color: Extra.accentColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'WEIGHT: ' + weight + ' pounds',
                  style: TextStyle(fontSize: 17, color: Extra.accentColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget formField(
      String fieldName, TextEditingController controller, String suffix) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Extra.accentColor),
      decoration: InputDecoration(
        suffixText: suffix,
        suffixStyle: TextStyle(color: Extra.accentColor),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Extra.accentColor),
        ),
        filled: false,
        fillColor: Colors.deepOrange[50],
        labelText: fieldName,
        labelStyle: TextStyle(color: Extra.accentColor),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Extra.accentColor)),
      ),
    );
  }

  void checkBioUpdate(String bio, int flag, TextEditingController controller,
      String valueToCheck) {
    if (controller.text.isNotEmpty) {
      _database
          .child('userDetails')
          .child(FirebaseAuth.instance.currentUser!.uid)
          .update({
        bio: controller.text,
      });
      flag = 1;
    }
  }
}
