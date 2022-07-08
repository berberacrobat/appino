import 'package:latlng/latlng.dart';

class ForeageStation {
  String name = "";
  int forageId = 0;
  LatLng position;

  ForeageStation({
    required this.position,
  });

  ForeageStation.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        forageId = json['forageId'],
        position = json['position'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'forageId': forageId,
        'position': position.toJson(),
      };

  @override
  toString() {
    return "$name - $forageId - $position";
  }
}
