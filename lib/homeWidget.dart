import 'dart:convert';

import 'package:appino/fruitDetails.dart';
import 'package:appino/fruit_map.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeWidget extends StatefulWidget {
  final Color color;
  final List fruits0 = [
    {
      'name': 'Banana',
      'id': '0101',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQALJiATjTXuSriYCuWy9Ai0jO0e-nMaY6a_w&usqp=CAU'
    },
    {
      'name': 'Apple',
      'id': '0101737',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZ1WaR8X7ZIqOEZsTWpOTz-r-WnkMXkV--RA&usqp=CAU'
    }
  ];

  HomeWidget(this.color, {Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetPageState();
}

class _HomeWidgetPageState extends State<HomeWidget> {
  late List fruits = [];

  @override
  void initState() {
    super.initState();
    print("initState() called .");
    _getData();
  }

  void _getData() async {
    //String url = 'http://127.0.0.1:8000/api/forages/';
    String url = 'https://api.fouraging.com/api/forages';
    final response = await http.get(Uri.parse(url));
    //.get(Uri.parse(url), headers: {"Access-Control-Allow-Origin": "*"});

    // print(response.body.toString());
    setState(() {
      fruits = jsonDecode(response.body);

      print(fruits.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 3,
          children: fruits
              .map((fruit) => InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              //FruiteDetailsWidget(Colors.brown, fruit)
                              FruitMarkersPage(fruit)),
                    ),
                    child: Column(
                      children: [
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          color: Color.fromARGB(255, 158, 216, 165),
                          child: Image(
                            height: 80,
                            width: 80,
                            image: NetworkImage(fruit['image']),
                          ),
                        ),
                        Text(
                          fruit['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 56, 92, 55)),
                        )
                      ],
                    ),
                  ))
              .toList()),
    );
  }
}


/* Card(
                      elevation: 3,
                      color: Color.fromARGB(255, 137, 218, 179),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Image(
                              image: NetworkImage(fruit['image']),
                            ),
                          ),
                          Text(fruit['name'])
                        ],
                      ),
                    ), */