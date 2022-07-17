import 'package:latlng/latlng.dart';

class ForeageStation {
  String name = "";
  String description = "";
  String forage_image = "";
  String forage_name = "";
  int forage = 0;
  LatLng? position;

  ForeageStation({
    required this.position,
  });

  ForeageStation.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        forage_image = json['forage_image'],
        forage_name = json['forage_name'],
        forage = json['forage'],
        position = json['position'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'forage_image': forage_image,
        'forage_name': forage_name,
        'forageId': forage,
        'position': position?.toJson(),
      };

  @override
  toString() {
    return " $forage_name - $name - $description - $forage - $position";
  }
}
