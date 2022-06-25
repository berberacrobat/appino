import 'package:appino/fruitDetails.dart';
import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  const PlaceholderWidget(this.color, {Key? key}) : super(key: key);

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
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const FruiteDetailsWidget(Colors.brown, "Lemon")),
            ),
            child: const Card(
                elevation: 0,
                color: Colors.black,
                child: Image(
                  image: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZ1WaR8X7ZIqOEZsTWpOTz-r-WnkMXkV--RA&usqp=CAU'),
                )),
          ),
          const Card(
              elevation: 0,
              color: Colors.white,
              child: Image(
                image: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQALJiATjTXuSriYCuWy9Ai0jO0e-nMaY6a_w&usqp=CAU'),
              )),
          const Card(
              elevation: 0,
              color: Colors.white,
              child: Image(
                image: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZ1WaR8X7ZIqOEZsTWpOTz-r-WnkMXkV--RA&usqp=CAU'),
              )),
          const Card(
              elevation: 0,
              color: Colors.white,
              child: const Image(
                image: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAX_9sTfw5zi87bemUV-nfyRxMHnfgJK66-A&usqp=CAU'),
              )),
          const Card(
              elevation: 0,
              color: Colors.white,
              child: Image(
                image: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8JuXNZ9gmMrNPWAPdq6Wx7D9kuKsIlTV06w&usqp=CAU'),
              )),
          const Card(
              elevation: 0,
              color: Colors.white,
              child: Image(
                image: const NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAqLzoWN5_Y_0zPCz9Y4ls3LzpGeq7qwBqiQ&usqp=CAU'),
              )),
          const Card(
              elevation: 0,
              color: Colors.white,
              child: Image(
                image: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtabTpJmxcLJ0tVmBbcka8SUA9ur3_6H-sdw&usqp=CAU'),
              ))
        ],
      ),
    );
  }
}
