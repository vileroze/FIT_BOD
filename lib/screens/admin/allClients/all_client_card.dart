import 'package:fitness_app/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:recase/recase.dart';

class AllClientCardItem extends StatefulWidget {
  String cKey;
  String clientName;
  String clientImgUrl;
  String clientEmail;
  String clientPhone;
  int coursesTaken;
  AllClientCardItem({
    Key? key,
    required this.cKey,
    required this.clientName,
    required this.clientImgUrl,
    required this.clientEmail,
    required this.clientPhone,
    required this.coursesTaken,
  }) : super(key: key);

  @override
  State<AllClientCardItem> createState() => _AllClientCardItemState();
}

class _AllClientCardItemState extends State<AllClientCardItem> {
  final _database = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final detailFontSize = size.width / 25;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(35.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        leading: Container(
          child: CircleAvatar(
            radius: size.width / 15,
            backgroundImage: NetworkImage(widget.clientImgUrl),
          ),
        ),
        title: Text(
          widget.clientName.toString().titleCase,
          style: TextStyle(
              fontSize: size.width / 20,
              fontWeight: FontWeight.bold,
              color: Extra.accentColor),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.open_in_new,
            color: Extra.accentColor,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Color.fromRGBO(231, 88, 20, 0.7),
                    insetPadding: EdgeInsets.only(
                        bottom: 100, top: 170, right: 10, left: 10),
                    content: Container(
                      // color: Extra.accentColor,
                      height: size.height / 3,
                      width: size.width,
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: <Widget>[
                              Positioned(
                                top: -100,
                                child: CircleAvatar(
                                  radius: size.width / 5,
                                  backgroundImage:
                                      NetworkImage(widget.clientImgUrl),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 50),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Text(
                                        'Name : ' + widget.clientName.titleCase,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: detailFontSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Text(
                                        'Courses Take: ' +
                                            widget.coursesTaken.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: detailFontSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.email_rounded,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            '  ' + widget.clientEmail,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: detailFontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.local_phone_rounded,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            '  ' + widget.clientPhone,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: detailFontSize,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
