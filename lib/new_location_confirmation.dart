import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:appino/take_photo.dart';
//import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'card_picture.dart';
import 'forage_station.dart';
import 'package:async/async.dart';

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
  //late CameraDescription _cameraDescription;

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
  List<XFile>? _imageFileList;

  /*  @override
  void initState() {
    super.initState();
    print("New location initState() called .");
  }
 */
  @override
  void initState() {
    super.initState();
    _getForagesData();

    /* availableCameras().then((cameras) {
      print("Cameras: ${cameras}");
      final camera = cameras
          .where(
              (camera) => camera.lensDirection == CameraLensDirection.external)
          // (camera) => camera.lensDirection == CameraLensDirection.back)
          .toList()
          .first;
      setState(() {
        print("Camera: ${camera}");
        _cameraDescription = camera;
      });
    }).catchError((err) {
      print("Error: ${err}");
    });*/
  }

  void _getForagesData() async {
    //String url = 'http://127.0.0.1:8000/api/forages/all';
    String url = 'https://events.managerplay.com/api/forages/all';
    final response = await http.get(Uri.parse(url));
    //.get(Uri.parse(url), headers: {"Access-Control-Allow-Origin": "*"});

    // print(response.body.toString());
    if (mounted) {
      setState(() {
        forages = jsonDecode(response.body) as List;

        ///print(forages);
      });
    }
  }

  void _confirmNewLocation() async {
    //String url = 'https://api.fouraging.com/api/forages/$selectedValue/areas';

    //String url = 'http://127.0.0.1:8000/api/forages/$selectedValue/areas';
    String url =
        'https://events.managerplay.com/api/forages/$selectedValue/areas';

    print('Confirmed');
    print('selected Forage Id: ' + selectedValue!);
    widget.newForageStation.name = name;
    widget.newForageStation.description = description;

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
    //print(url);
    print("Response: " + response.body);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  Widget _previewImages() {
    if (_imageFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: ListView.builder(
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            // Why network for web?
            // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
            return SizedBox(
              width: 100,
              height: 100,
              child: Semantics(
                label: 'image_picker_example_picked_image',
                child: kIsWeb
                    ? Image.network(_imageFileList![index].path)
                    : Image.file(File(_imageFileList![index].path)),
              ),
            );
          },
          itemCount: _imageFileList!.length,
        ),
      );
    }
    return const Text("No image selected");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Color.fromARGB(255, 92, 66, 102),
      titlePadding: const EdgeInsets.all(5.0),
      title: const Text(
        'Add new location',
        style: TextStyle(
            color: Color.fromARGB(255, 196, 200, 196),
            fontSize: 16,
            fontWeight: FontWeight.bold),
      ),
      contentPadding: const EdgeInsets.all(5.0),
      content: Container(
        // width: 600,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Select Type:",
                    style: TextStyle(
                        color: Color.fromARGB(255, 196, 200, 196),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 173, 141, 175),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Color.fromARGB(255, 100, 54, 106))),
                    child: DropdownButton(
                      style: const TextStyle(
                          color: Color.fromARGB(255, 217, 221, 217)),
                      dropdownColor: Color.fromARGB(255, 173, 141, 175),
                      focusColor: Color.fromARGB(255, 213, 196, 214),
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
                        color: Color.fromARGB(255, 224, 227, 224),
                        fontWeight: FontWeight.bold),
                    filled: true,
                    fillColor: Color.fromARGB(255, 173, 141, 175)),
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
                          width: 1, color: Color.fromARGB(255, 140, 78, 146)),
                    ),
                    labelText: 'Note: ',
                    labelStyle: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 197, 199, 197),
                        fontWeight: FontWeight.bold),
                    filled: true,
                    fillColor: Color.fromARGB(255, 173, 141, 175)),
              ),
              // This component to view uploaded photos
              //SizedBox(height: 100, child: _previewImages()),
              SizedBox(
                height: 100,
                width: double.maxFinite,
                child: CardPicture(
                  onTap: () async {
                    final ImagePicker _picker = ImagePicker();
                    try {
                      //final List<XFile>? images = await _picker.pickMultiImage();
                      final List<XFile>? pickedFileList =
                          await _picker.pickMultiImage();
                      setState(() {
                        _imageFileList = pickedFileList;
                      });

                      print("Path:  ${_imageFileList?.first.path}");

                      if (_imageFileList?.first.path != null) {
                        var postUri = Uri.parse(
                            "https://events.managerplay.com/api/upload/areas/photo");
                        //var postUri =
                        // Uri.parse("https://api.fouraging.com/api/upload/areas/photo");

                        var request = http.MultipartRequest("POST", postUri);
                        request.fields['user'] = 'blahh';
                        //request.fields['file_name'] = _imageFileList!.first.name;

                        // request.files.add(http.MultipartFile.fromBytes(
                        //  'file', await _imageFileList!.first.readAsBytes()));

                        List<http.MultipartFile> newList = [];

                        for (int i = 0; i < _imageFileList!.length; i++) {
                          //var path2 = await _imageFileList[i].readAsString());
                          var stream =
                              http.ByteStream(_imageFileList![i].openRead());
                          var length = await _imageFileList![i].length();
                          var multipartFile = http.MultipartFile(
                            'pictures-$i',
                            stream,
                            length,
                            filename: _imageFileList![i].name,
                          );

                          newList.add(multipartFile);

                          //request.files.add(multipartFile);
                        }
                        print('List ${newList}');

                        request.files.addAll(newList);

                        // print("Request files${request.files}");
                        request.send().then((response) async {
                          // print('RESPONSE: $response');
                          //print('Resposne Message: ${response.toString()}');
                          var responseBody =
                              await response.stream.bytesToString();

                          // print('Resposne body: $responseBody');

                          if (response.statusCode == 200) print("Uploaded!");
                        });
                      }
                    } catch (e) {
                      print('E $e');
                    }

                    //var file = picked?.files.first;

                    /* if (picked != null) {
                print(picked.files.first.bytes);
                var postUri =
                    Uri.parse("http://127.0.0.1:8000/api/upload/areas/photo");
                var request = http.MultipartRequest("POST", postUri);
                request.fields['user'] = 'blah';
                request.fields['file_name'] = picked.files.first.name; */

                    /*  request.files.add(http.MultipartFile.fromBytes(
                    'file', picked.files.first.bytes!));
                print("Request $request");
                request.send().then((response) {
                  print('RESPONSE: $response');
                  print('response.stream: ${response}');
                  if (response.statusCode == 200) print("Uploaded!");
                }); 
              }*/
                  },
                ),
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
        /* CardPicture(
          onTap: () async {
            var picked = await FilePicker.platform.pickFiles();
            var file = picked?.files.first;

            if (picked != null) {
              print(picked.files.first.bytes);
              var postUri =
                  Uri.parse("http://127.0.0.1:8000/api/upload/areas/photo");
              var request = http.MultipartRequest("POST", postUri);
              request.fields['user'] = 'blah';
              request.fields['file_name'] = picked.files.first.name;

              /* request.files.add(http.MultipartFile.fromBytes(
                  'file',
                  File.fromRawPath(picked.files.first.bytes!)
                      .readAsBytesSync())); */
              request.files.add(http.MultipartFile.fromBytes(
                  'file', picked.files.first.bytes!));
              print("Request $request");
              request.send().then((response) {
                print('RESPONSE: $response');
                print('response.stream: ${response}');
                if (response.statusCode == 200) print("Uploaded!");
              });
            }
          },
        ), */
      ],
    );
  }
}
