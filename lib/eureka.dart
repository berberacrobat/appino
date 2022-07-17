import 'dart:convert';

import 'package:appino/new_location_confirmation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:appino/lat_lng.dart';
import 'package:map/map.dart';
import 'package:http/http.dart' as http;

import 'forage_station.dart';

class EurekaMarkersPage extends StatefulWidget {
  const EurekaMarkersPage({Key? key}) : super(key: key);

  @override
  EurekaMarkersPageState createState() => EurekaMarkersPageState();
}

class EurekaMarkersPageState extends State<EurekaMarkersPage> {
  late LatLng myLocation = LatLng(37.871666, -122.272781);
  var areas = [];
  late Position _currentPosition;
  late Offset _currentLocation;
  late Widget _currentLocationMarkerWidget;
  late Widget _newPlaceLocationMarkerWidget;
  late ForeageStation newForageStation;
  late MapTransformer mapTransformer;

  final List allMarkersWidgets = [];
  final List allNewPlaceMarkersWidgets = [];

  @override
  void initState() {
    super.initState();
    print("initState() called from MAP .");
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

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "USA", child: Text("USA")),
      const DropdownMenuItem(value: "Canada", child: Text("Canada")),
      const DropdownMenuItem(value: "Brazil", child: Text("Brazil")),
      const DropdownMenuItem(value: "England", child: Text("England")),
    ];
    return menuItems;
  }

  void _dragMarker(DragUpdateDetails d) {
    print("Drag: " + d.toString());
    _newPlaceLocationMarkerWidget = _buildDraggableMarkerWidget(null,
        d.globalPosition, Color.fromARGB(255, 218, 42, 156), Icons.pin_drop);

    newForageStation = ForeageStation(
      position: mapTransformer.fromXYCoordsToLatLng(d.globalPosition),
    );

    print("Lat long: " +
        mapTransformer.fromXYCoordsToLatLng(d.globalPosition).toString());

    allNewPlaceMarkersWidgets.clear();
    allNewPlaceMarkersWidgets.add(_newPlaceLocationMarkerWidget);
  }

  void _gotoDefault() {
    controller.center =
        LatLng(_currentPosition.latitude, _currentPosition.longitude);
    setState(() {});
    print(
        "LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}");
  }

  void _addNewLocation() {
    String url = 'https://api.fouraging.com/api/forages/1/areas';
    //String url = 'http://127.0.0.1:8000/api/forages/1/areas';

    print("New Place: " + _newPlaceLocationMarkerWidget.toString());
    print("ew Forage station: " + newForageStation.toString());
    showDialog(
        context: context,
        builder: (context) =>
            NewLocationConfirmation(newForageStation: newForageStation));

    //print("POST REsponse: " + response.body);
  }

  void _onDoubleTap(MapTransformer mapTransformer, Offset position) {
    print("POSITION: " + position.toString());
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

  Widget _buildMarkerWidget(LatLng? latLng, Offset pos, Color color,
      [IconData icon = Icons.location_on]) {
    final locationLatLng = latLng;

    return Positioned(
      left: pos.dx - 24,
      top: pos.dy - 24,
      width: 48,
      height: 48,
      child: GestureDetector(
        //https://api.fouraging.com/public/storage/icons/Apple.png
        /* Image(
          image: NetworkImage(
              'https://api.fouraging.com/public/storage/icons/Apple.png'),
        )  */
        onPanUpdate: _dragMarker,
        onTap: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 600,
                color: Color.fromARGB(255, 155, 216, 156),
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
        //https://api.fouraging.com/public/storage/icons/Apple.png
        /* Image(
          image: NetworkImage(
              'https://api.fouraging.com/public/storage/icons/Apple.png'),
        )  */
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildDraggableMarkerWidget(LatLng? latLng, Offset pos, Color color,
      [IconData icon = Icons.location_on]) {
    final locationLatLng = latLng;

    return Positioned(
      left: pos.dx - 24,
      top: pos.dy - 24,
      width: 48,
      height: 48,
      child: GestureDetector(
        //https://api.fouraging.com/public/storage/icons/Apple.png
        /* Image(
          image: NetworkImage(
              'https://api.fouraging.com/public/storage/icons/Apple.png'),
        )  */
        onPanUpdate: _dragMarker,
        onTap: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 600,
                color: Color.fromARGB(255, 155, 216, 156),
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
        //https://api.fouraging.com/public/storage/icons/Apple.png
        /* Image(
          image: NetworkImage(
              'https://api.fouraging.com/public/storage/icons/Apple.png'),
        )  */
        child: const Image(
          image: NetworkImage(
              'https://api.fouraging.com/public/storage/icons/pinDrop.png'),
        )
        /* Icon(
          icon,
          color: color,
          size: 48,
        ) */
        ,
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
            mapTransformer = transformer;
            final markerPositions =
                markers.map(transformer.fromLatLngToXYCoords).toList();

            Future<LocationPermission> permission =
                Geolocator.requestPermission();
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
                            LatLng(_currentPosition.latitude,
                                _currentPosition.longitude),
                            _currentLocation,
                            Color.fromARGB(255, 34, 79, 200),
                            Icons.my_location);

                        allMarkersWidgets.clear();
                        allMarkersWidgets.add(_currentLocationMarkerWidget);
                        //print(' Set state = position updated mm');
                      })
                    }
                });
/* 
          final currentLocation = transformer.fromLatLngToXYCoords(
              LatLng(_currentPosition.latitude, _currentPosition.longitude));

          final currentLocationMarkerWidget = _buildMarkerWidget(
              currentLocation, Color(0xFF0B4BE1), Icons.my_location); */

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              //onDoubleTap: _onDoubleTap,
              onTapUp: (details) {
                final location =
                    transformer.fromXYCoordsToLatLng(details.localPosition);
                _newPlaceLocationMarkerWidget = _buildDraggableMarkerWidget(
                    location,
                    details.localPosition,
                    Color.fromRGBO(27, 227, 12, 1),
                    Icons.pin_drop);

                newForageStation = ForeageStation(position: location);

                allNewPlaceMarkersWidgets.clear();
                allNewPlaceMarkersWidgets.add(_newPlaceLocationMarkerWidget);
                setState(() {});
                //final clicked = transformer.fromLatLngToXYCoords(location);
                //print('${location.longitude}, ${location.latitude}');
                //print('${clicked.dx}, ${clicked.dy}');
                //print('${details.localPosition.dx}, ${details.localPosition.dy}');

                /* showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Text(
                      'You have clicked on (${location.longitude}, ${location.latitude}).'),
                ),
              ); */
              },
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
                    ...allMarkersWidgets,
                    if (allNewPlaceMarkersWidgets.isNotEmpty)
                      ...allNewPlaceMarkersWidgets,
                    //...markerWidgets,
                    //centerMarkerWidget,
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: allNewPlaceMarkersWidgets.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: _addNewLocation,
                    tooltip: 'Add new location',
                    child: const Icon(Icons.add),
                  ),
                  const Divider(),
                  FloatingActionButton(
                    onPressed: _gotoDefault,
                    tooltip: 'My Location',
                    child: const Icon(Icons.my_location),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: _gotoDefault,
                    tooltip: 'Add new location',
                    child: const Icon(Icons.my_location),
                  ),
                  FloatingActionButton(
                    onPressed: _gotoDefault,
                    tooltip: 'Add new location',
                    child: const Image(
                      image: NetworkImage(
                          'https://api.fouraging.com/public/storage/icons/Apple.png'),
                    ),
                  ),
                ],
              ));
  }
}
