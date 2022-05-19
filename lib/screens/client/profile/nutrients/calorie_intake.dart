import 'dart:convert';

import 'package:fitness_app/extra/color.dart';
import 'package:fitness_app/screens/client/profile/nutrients/food_card_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CalorieIntake extends StatefulWidget {
  const CalorieIntake({Key? key}) : super(key: key);

  @override
  State<CalorieIntake> createState() => _CalorieIntakeState();
}

Future<FoodItem> fetchNutritionalValue(String queryFood) async {
  final response = await http.get(
    Uri.parse('https://api.calorieninjas.com/v1/nutrition?query=' + queryFood),
    headers: {'X-Api-Key': 'ug3VxLEYAVWiy7rDm6ThiQ==S1WYVbOQKok7RaPR'},
  );

  // Appropriate action depending upon the
  // server response
  if (response.statusCode == 200) {
    return FoodItem.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class FoodItem {
  List<dynamic> fItems = [];

  FoodItem({
    required this.fItems,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      fItems: json['items'],
    );
  }
}

class _CalorieIntakeState extends State<CalorieIntake> {
  late Future<FoodItem> futureFood;
  final TextEditingController foodNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String foodName = '';
  String protienValue = '';
  String carbValue = '';
  String caloricValue = '';
  String servingSize = '';

  @override
  void initState() {
    super.initState();
    futureFood = fetchNutritionalValue('');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width / 1.1,
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: foodNameController,
                    validator: (value) {
                      if (value == '') {
                        return 'Name can\'t be empty';
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(255, 255, 255, 0.5),
                      labelText: 'Search food items...',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Extra.accentColor,
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      setState(() {
                        futureFood =
                            fetchNutritionalValue(foodNameController.text);
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder<FoodItem>(
            future: futureFood,
            builder: (context, snapshot) {
              final clientCards = <FoodCardItem>[];
              if (snapshot.hasData) {
                final nutritionValue = snapshot.data!.fItems as List<dynamic>;
                nutritionValue.forEach((element) {
                  final eachItem = element as Map<String, dynamic>;

                  foodName = eachItem['name'].toString();
                  servingSize = eachItem['serving_size_g'].toString();
                  protienValue = eachItem['protein_g'].toString();
                  carbValue = eachItem['carbohydrates_total_g'].toString();
                  caloricValue = eachItem['calories'].toString();

                  final citem = FoodCardItem(
                      food: foodName,
                      servingSize: servingSize,
                      protein: protienValue,
                      carb: carbValue,
                      calories: caloricValue);
                  clientCards.add(citem);
                });
                return Container(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: clientCards,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
