import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

class FruitMarkersPage extends StatefulWidget {
  var fruit = {};

  FruitMarkersPage(this.fruit, {Key? key}) : super(key: key);

  @override
  FruitMarkersPageState createState() => FruitMarkersPageState();
}

class FruitMarkersPageState extends State<FruitMarkersPage> {
  late LatLng myLocation = LatLng(37.871666, -122.272781);
  var areas = [];
  late Position _currentPosition;
  late Offset _currentLocation;
  late Widget _currentLocationMarkerWidget;
  final List allMarkersWidgets = [];

  @override
  void initState() {
    super.initState();
    areas = widget.fruit['areas'];
    print("initState() called from MAP .");
    print(areas);
  }

  final controller = MapController(
    location: LatLng(37.871666, -122.272781),
  );

  final markers = [
    LatLng(37.87688, -122.27033),
    LatLng(37.871960, -122.259094),
    LatLng(37.8570313, -122.2671869),
    LatLng(37.825496698, -122.284498862),
  ];

  void _gotoDefault() {
    controller.center = myLocation;
    setState(() {});
    print(
        "LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}");
  }

  void _onDoubleTap() {
    controller.zoom += 0.5;
    setState(() {});
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  Widget _buildMarkerWidget(Offset pos, Color color,
      [IconData icon = Icons.location_on]) {
    return Positioned(
      left: pos.dx - 24,
      top: pos.dy - 24,
      width: 48,
      height: 48,
      child: GestureDetector(
        child: Icon(
          icon,
          color: color,
          size: 48,
        ),
        onTap: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 600,
                color: const Color.fromRGBO(158, 186, 190, 1),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.share),
                        title: const Text('Share'),
                      ),
                      const ListTile(
                        leading: Icon(Icons.copy),
                        title: Text('Copy Link'),
                      ),
                      const ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('Edit'),
                      ),
                      const Text('Modal BottomSheet'),
                      ElevatedButton(
                        child: const Text('Close BottomSheet'),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ),
              );
            },
          );
          /*  showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              content: Text('You have clicked a marker!'),
            ),
          ); */
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forage'),
      ),
      body: MapLayoutBuilder(
        controller: controller,
        builder: (context, transformer) {
          final markerPositions =
              markers.map(transformer.fromLatLngToXYCoords).toList();

          final areasLocations = areas.map((item) {
            //print(item['address']['latitude']);
            return LatLng(double.parse(item['address']['latitude']),
                double.parse(item['address']['longitude']));
          }).toList();

          final areasPositions =
              areasLocations.map(transformer.fromLatLngToXYCoords).toList();

          print(markerPositions);
          print("------------");
          print(areasPositions);

          final markerWidgets = markerPositions.map(
            (pos) => _buildMarkerWidget(pos, Colors.red),
          );

          final areasWidgets = areasPositions.map(
            (pos) => _buildMarkerWidget(pos, Colors.lime),
          );

          final homeLocation = transformer.fromLatLngToXYCoords(myLocation);
          //Future<LocationPermission> permission =
          // Geolocator.requestPermission();
          //Geolocator.openLocationSettings();

          final deviceLocation = Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);

          deviceLocation.then((Position position) => {
                if (mounted)
                  {
                    setState(() {
                      _currentPosition = position;
                      _currentLocation = transformer.fromLatLngToXYCoords(
                          LatLng(_currentPosition.latitude,
                              _currentPosition.longitude));
                      _currentLocationMarkerWidget = _buildMarkerWidget(
                          _currentLocation,
                          Color.fromARGB(255, 68, 181, 141),
                          Icons.my_location);
                      allMarkersWidgets.clear();
                      allMarkersWidgets.add(_currentLocationMarkerWidget);
                      print(' Set state = position updated mm');
                    })
                  }
              });
/* 
          final currentLocation = transformer.fromLatLngToXYCoords(
              LatLng(_currentPosition.latitude, _currentPosition.longitude));

          final currentLocationMarkerWidget = _buildMarkerWidget(
              currentLocation, Color(0xFF0B4BE1), Icons.my_location); */

          final homeMarkerWidget =
              _buildMarkerWidget(homeLocation, Colors.black, Icons.home);

          final centerLocation = Offset(
              transformer.constraints.biggest.width / 2,
              transformer.constraints.biggest.height / 2);

          final centerMarkerWidget =
              _buildMarkerWidget(centerLocation, Colors.purple);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTap: _onDoubleTap,
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  final delta = event.scrollDelta;

                  controller.zoom -= delta.dy / 1000.0;
                  setState(() {});
                }
              },
              child: Stack(
                children: [
                  Map(
                    controller: controller,
                    builder: (context, x, y, z) {
                      //Legal notice: This url is only used for demo and educational purposes. You need a license key for production use.
                      //Google Maps
                      final url =
                          'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';
                      return CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  ...areasWidgets,
                  homeMarkerWidget,
                  ...allMarkersWidgets,
                  //...markerWidgets,
                  //centerMarkerWidget,
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoDefault,
        tooltip: 'My Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
