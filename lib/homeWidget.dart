import 'package:appino/fruitDetails.dart';
import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
  final Color color;
  final List fruits = [
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
  Widget build(BuildContext context) {
    return Container(
      color: color,
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
                              FruiteDetailsWidget(Colors.brown, fruit)),
                    ),
                    child: Card(
                        elevation: 0,
                        color: Colors.black,
                        child: Image(
                          image: NetworkImage(fruit['image']),
                        )),
                  ))
              .toList()),
    );
  }
}
