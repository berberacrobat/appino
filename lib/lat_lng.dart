/// Coordinates in Degrees.
class LatLng {
  double latitude;
  double longitude;

  LatLng(this.latitude, this.longitude);

  LatLng.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'],
        longitude = json['longitude'];

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };

  @override
  toString() {
    return "latitude: $latitude - longitude: $longitude";
  }
}
