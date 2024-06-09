import 'package:appino/forage_station.dart';
import 'package:flutter/material.dart';

import 'markers_page.dart';

class ForageDisplayWidget extends StatelessWidget {
  //final Color color;
  //final Map fruit;
  final foreageStationId;
  final ForeageStation foreageStation;
  List images = [
    "https://api.fouraging.com/public/storage/icons/pin.png",
    "https://api.fouraging.com/public/storage/icons/pin.png"
  ];
  Color darkGreen = Color.fromARGB(255, 57, 99, 59);

  ForageDisplayWidget(this.foreageStationId, this.foreageStation, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800,
      color: const Color.fromRGBO(190, 207, 158, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            transform: Matrix4.translationValues(0.0, -50.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 252, 252, 252),
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(color: darkGreen)),
                  child: Image(
                    width: 100,
                    image: NetworkImage(foreageStation.forage_image),
                  ),
                ),
                Text(
                  foreageStation.forage_name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ListTile(
                  leading: Icon(Icons.location_pin, color: darkGreen),
                  title: Text(foreageStation.name),
                ),
                ListTile(
                  leading: Icon(
                    Icons.note,
                    color: darkGreen,
                  ),
                  title: Text(foreageStation.description),
                )
              ],
            ),
          ),
          /* ElevatedButton(
            child: const Text('Close BottomSheet'),
            onPressed: () => Navigator.pop(context),
          ) ,*/
          Expanded(
              child: ListView.builder(
                  itemCount: images.length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return Image(
                      image: NetworkImage(images[Index]),
                    );
                  }))
        ],
      ),
    );
  }
}
