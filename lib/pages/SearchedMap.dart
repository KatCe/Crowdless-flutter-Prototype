import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class SearchedMap extends StatefulWidget {

  const SearchedMap({
    this.showLocation
  });

  final LatLng showLocation;

  @override
  _SearchedMapState createState() => _SearchedMapState();
}

class _SearchedMapState extends State<SearchedMap> {
  static LatLng zurich = LatLng(47.37174, 8.54226);
  static LatLng basel = LatLng(47.5596, 7.5886);
  MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  var grid_size_hori = 11;
  var grid_size_vert = 8;
  var distance_bt_grid = 1;

  var markers = <Marker>[];
  void _addMarkerFromList() {
    while (markers.isNotEmpty) {
      markers.removeLast();
    }
    var map_corner_right_up = mapController.bounds.northEast;
    var map_corner_left_down = mapController.bounds.southWest;
    for (int grid_count_hori in [
      for (var i = -2; i < grid_size_hori + 2; i += 1) i
    ]) {
      var latitude = map_corner_right_up.latitude +
          (map_corner_left_down.latitude - map_corner_right_up.latitude) /
              grid_size_hori *
              grid_count_hori;
      for (int grid_count_verti in [
        for (var i = -2; i < grid_size_vert + 2; i += 1) i
      ]) {
        var longitude = map_corner_right_up.longitude +
            (map_corner_left_down.longitude - map_corner_right_up.longitude) /
                grid_size_vert *
                grid_count_verti;
        markers.add(Marker(
          point: LatLng(latitude, longitude),
          builder: (ctx) => Container(
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.stop,
                  size: 90.0,
                  color: Colors.green.withOpacity(0.5),
                ),
              )),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("SearchedMap");
    print(widget.showLocation);
    mapController.move(widget.showLocation, 14.0);
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: widget.showLocation,
        zoom: 14.0,
      ),
      layers: [
        TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c']),
        MarkerLayerOptions(markers: markers)
      ]
    );
  }
}
