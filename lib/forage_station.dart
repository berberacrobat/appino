import 'dart:convert';
import 'package:latlng/latlng.dart';

class ForeageStation {
  String? name = "";
  String? description = "";
  String forage_image = "";
  String forage_name = "";
  int forage = 0;
  LatLng? position;
  List? documents;
/*   List documents = [
    "https://cdn-icons-png.flaticon.com/512/9356/9356230.png",
    "https://cdn-icons-png.flaticon.com/512/9356/9356230.png"
  ]; */

  ForeageStation({
    required this.position,
  });

  ForeageStation.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        forage_image = json['forage_image'],
        forage_name = json['forage_name'],
        //forage_image =
        // "https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA3L2pvYjk1MC0wNjEtcC5wbmc.png",
        forage = json['forage'],
        position = json['position'],
        documents = json['documents'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'forage_image': forage_image,
        //'forage_image':
        //   "https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA3L2pvYjk1MC0wNjEtcC5wbmc.png",
        'forage_name': forage_name,
        'forageId': forage,
        // 'position': position?.toJson(),
        'position': position?.toJson(),
        'documents': documents
      };

  @override
  toString() {
    return " $forage_name - $name - $description - $forage - $position";
  }
}
