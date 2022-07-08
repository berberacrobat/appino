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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add new location'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DropdownButton(
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
            ),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Location Name: ',
              ),
            ),
            const Divider(),
            const TextField(
              maxLines: 8, //
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Note: ',
                  hintText: "Enter your text here"),
            ),
/*                     Text('New Forage place at: (${newForageStation.position}).'),
 */
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Confirm'),
          onPressed: () async {
            String url =
                'https://api.fouraging.com/api/forages/$selectedValue/areas';

            //String url =
            // 'http://127.0.0.1:8000/api/forages/$selectedValue/areas';

            print('Confirmed');
            print('selected Forage Id: ' + selectedValue!);
            widget.newForageStation.name = "hello";
            //widget.newForageStation.forageId = selectedValue as int;
            final response = await http.post(
              Uri.parse(url),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'newForageStation':
                    json.encode(widget.newForageStation.toJson()),
              }),
            );
            print(url);
            print("Response: " + response.body);
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
