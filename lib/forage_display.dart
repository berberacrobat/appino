import 'package:appino/forage_station.dart';

import 'package:flutter/material.dart';

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
      color: Color.fromARGB(255, 255, 255, 255),
      child: Container(
        transform: Matrix4.translationValues(0.0, -50.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  // color: Color.fromARGB(255, 20, 216, 10),
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(color: darkGreen)),
                    child: Image(
                      //width: 100,
                      image: NetworkImage(foreageStation.forage_image),
                    ),
                  ),
                  Text(
                    foreageStation.forage_name + " ID: " + foreageStationId,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_pin,
                        color: Color.fromARGB(255, 104, 47, 130)),
                    title: Text(foreageStation.name!),
                  ),
                  Container(
                    height: 110,
                    decoration: BoxDecoration(
                        //color: Color.fromARGB(255, 216, 10, 10),
                        ),
                    child: Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text(
                          foreageStation.description!,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //const Divider(),
            ListTile(
              leading: Icon(Icons.photo_album,
                  color: Color.fromARGB(255, 104, 47, 130)),
              title: Text('Photos'),
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 280,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: foreageStation.documents?.length,
                        itemBuilder: (BuildContext ctxt, int Index) {
                          //print(foreageStation.documents![Index]['url']);
                          return Image(
                            image: NetworkImage(
                                foreageStation.documents![Index]['url']),
                          );
                        }),
                  ),
                ),
              ],
            ),

            /* ElevatedButton(
              child: const Text('Close BottomSheet'),
              onPressed: () => Navigator.pop(context),
            ) ,*/
          ],
        ),
      ),
    );
  }
}
