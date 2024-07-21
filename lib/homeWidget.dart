import 'dart:convert';

import 'package:appino/fruitDetails.dart';
import 'package:appino/fruit_map.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeWidget extends StatefulWidget {
  final Color color;

  HomeWidget(this.color, {Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetPageState();
}

class _HomeWidgetPageState extends State<HomeWidget> {
  late List fruits = [];

  @override
  void initState() {
    super.initState();
    print("... initState() called .");
    _getData();
  }

  void _getData() async {
    print("Startt _getdata: ");
    // String url = 'http://127.0.0.1:8000/api/forages/';
    // String url = 'https://api.fouraging.com/api/forages';
    String url = 'https://events.managerplay.com/api/forages';
    final response = await http.get(Uri.parse(url));
    //.get(Uri.parse(url), headers: {"Access-Control-Allow-Origin": "*"});

    print("Bodyy: " + response.body.toString());
    if (mounted) {
      setState(() {
        fruits = jsonDecode(response.body);
        // print(fruits.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = Color.fromARGB(255, 2, 85, 108);
    return Container(
        color: widget.color,
        child: SafeArea(
          child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(0),
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              crossAxisCount: 3,
              children: fruits
                  .map((fruit) => InkWell(
                        highlightColor: Colors.red,
                        focusColor: Colors.red,
                        hoverColor: Colors.red,
                        splashColor: Colors.yellow,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  //FruiteDetailsWidget(Colors.brown, fruit)
                                  FruitMarkersPage(fruit)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              //padding: EdgeInsets.all(2),
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  //color: Colors.amber,
                                  //border: Border.all(color: bgColor),
                                  borderRadius: BorderRadius.circular(50.0)),
                              child: Image(
                                image: NetworkImage(fruit['image']),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              fruit['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 46, 46, 46),
                                // backgroundColor: Colors.red
                              ),
                            )
                          ],
                        ),
                      ))
                  .toList()),
        ));
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