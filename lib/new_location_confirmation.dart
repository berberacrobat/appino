import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'forage_station.dart';

class NewLocationConfirmation extends StatefulWidget {
  final ForeageStation newForageStation;

  const NewLocationConfirmation({Key? key, required this.newForageStation})
      : super(key: key);
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: const Text(""), value: ""),
      const DropdownMenuItem(child: const Text("USA"), value: "USA"),
      const DropdownMenuItem(child: Text("Canada"), value: "Canada"),
      const DropdownMenuItem(child: const Text("Brazil"), value: "Brazil"),
      const DropdownMenuItem(child: const Text("England"), value: "England"),
    ];
    return menuItems;
  }

  @override
  State<NewLocationConfirmation> createState() =>
      _NewLocationConfirmationState();
}

class _NewLocationConfirmationState extends State<NewLocationConfirmation> {
  String? selectedValue;
  String? name;
  String? description;
  List<Map> items = [
    {
      "id": 1,
      "name": "Apple",
      "description": "",
      "image": "https://api.fouraging.com/public/storage/icons/Apple.png"
    },
    {
      "id": 2,
      "name": "Blackberry",
      "description": "",
      "image": "https://api.fouraging.com/public/storage/icons/BLACKBERRY.png"
    }
  ];
  List forages = [];

  @override
  void initState() {
    super.initState();
    print("New location initState() called .");
    _getForagesData();
  }

  void _getForagesData() async {
    //String url = 'http://127.0.0.1:8000/api/forages/all';
    String url = 'https://api.fouraging.com/api/forages/all';
    final response = await http.get(Uri.parse(url));
    //.get(Uri.parse(url), headers: {"Access-Control-Allow-Origin": "*"});

    // print(response.body.toString());
    if (mounted) {
      setState(() {
        forages = jsonDecode(response.body) as List;
        print(forages);
      });
    }
  }

  void _confirmNewLocation() async {
    String url = 'https://api.fouraging.com/api/forages/$selectedValue/areas';

    // String url = 'http://127.0.0.1:8000/api/forages/$selectedValue/areas';

    print('Confirmed');
    print('selected Forage Id: ' + selectedValue!);
    widget.newForageStation.name = name!;
    widget.newForageStation.description = description!;

    //widget.newForageStation.forageId = selectedValue as int;
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'newForageStation': json.encode(widget.newForageStation.toJson()),
      }),
    );
    print(url);
    print("Response: " + response.body);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(190, 207, 158, 1),
      titlePadding: const EdgeInsets.all(10.0),
      title: const Text(
        'Add new location',
        style: TextStyle(
            color: Color.fromARGB(255, 57, 99, 59),
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
      contentPadding: const EdgeInsets.all(10.0),
      content: Container(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Select Type:",
                    style: TextStyle(
                        color: Color.fromARGB(255, 57, 99, 59),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(210, 219, 194, 1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: const Color.fromARGB(255, 57, 99, 59))),
                    child: DropdownButton(
                      style: const TextStyle(
                          color: Color.fromARGB(255, 57, 99, 59)),
                      dropdownColor: const Color.fromRGBO(190, 207, 158, 1),
                      focusColor: const Color.fromRGBO(210, 219, 194, 1),
                      value: selectedValue,
                      items: forages.map((forage) {
                        return DropdownMenuItem<String>(
                          value: forage['id'].toString(),
                          child: Text(forage['name']),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                          print(" selected value: " + newValue);
                        });
                      },
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 42,
                      underline: const SizedBox(),
                    ),
                  )
                ],
              ),
              const Divider(),
              TextField(
                onChanged: (String? newValue) {
                  setState(() {
                    name = newValue;
                  });
                },
                style: const TextStyle(color: Color.fromARGB(255, 57, 99, 59)),
                decoration: const InputDecoration(
                    //border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                          width: 1, color: Color.fromARGB(255, 57, 99, 59)),
                    ),
                    labelText: 'Location Name: ',
                    labelStyle: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 57, 99, 59),
                        fontWeight: FontWeight.bold),
                    filled: true,
                    fillColor: Color.fromRGBO(210, 219, 194, 1)),
              ),
              const Divider(),
              TextField(
                onChanged: (String? newValue) {
                  setState(() {
                    description = newValue;
                  });
                },
                style: const TextStyle(color: Color.fromARGB(255, 57, 99, 59)),
                maxLines: 8, //
                decoration: const InputDecoration(
                    //border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                          width: 1, color: Color.fromARGB(255, 57, 99, 59)),
                    ),
                    labelText: 'Note: ',
                    labelStyle: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 57, 99, 59),
                        fontWeight: FontWeight.bold),
                    filled: true,
                    fillColor: Color.fromRGBO(210, 219, 194, 1)),
              ),
/*                     Text('New Forage place at: (${newForageStation.position}).'),
 */
            ],
          ),
        ),
      ),
      actions: <Widget>[
        if (selectedValue != null)
          TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromRGBO(210, 219, 194, 1))),
            onPressed: _confirmNewLocation,
            child: const Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                'Confirm',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 25, 93, 76),
                ),
              ),
            ),
          ),
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromRGBO(210, 219, 194, 1))),
          child: const Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 25, 93, 76),
              ),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
