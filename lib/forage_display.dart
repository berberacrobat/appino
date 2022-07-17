import 'package:appino/forage_station.dart';
import 'package:flutter/material.dart';

import 'markers_page.dart';

class ForageDisplayWidget extends StatelessWidget {
  //final Color color;
  //final Map fruit;
  final foreageStationId;
  final ForeageStation foreageStation;
  Color darkGreen = Color.fromARGB(255, 57, 99, 59);

  ForageDisplayWidget(this.foreageStationId, this.foreageStation, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      color: Color.fromARGB(255, 155, 216, 156),
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
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(210, 219, 194, 1),
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
          const Text('Modal BottomSheet'),
          ElevatedButton(
            child: const Text('Close BottomSheet'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}
