import 'package:fitness_app/screens/trainer/profile/clientss/client_builder.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Clients extends StatefulWidget {
  const Clients({Key? key}) : super(key: key);

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  final _database = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.width / 15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 7,
              offset: Offset(0, 2), // Shadow position
            ),
          ],
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 1,
          maxChildSize: 1,
          minChildSize: 1,
          builder: (context, controller) => ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 5),
                child: ListView(
                  children: [
                    Container(
                      height: 180.0,
                      child: Image.asset('assets/line_art/clients.jpg'),
                    ),
                    ClientBuilder(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
