/// Coordinates in Degrees.
class LatLng2 {
  double latitude;
  double longitude;

  LatLng2(this.latitude, this.longitude);

  LatLng2.fromJson(Map<String, dynamic> json)
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
