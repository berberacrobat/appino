import 'package:latlng/latlng.dart';

class ForeageStation {
  final String name;
  final LatLng position;

  ForeageStation({
    required this.name,
    required this.position,
  });

  ForeageStation.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        position = json['position'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'position': position.toJson(),
      };

  @override
  toString() {
    return "$name - $position";
  }
}
