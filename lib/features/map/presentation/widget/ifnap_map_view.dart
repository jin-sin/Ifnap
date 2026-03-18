import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' hide Position;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class IfnapMapView extends StatefulWidget {
  const IfnapMapView({
    super.key,
    this.initialZoom = 15,
  });

  final double initialZoom;

  @override
  State<IfnapMapView> createState() => IfnapMapViewState();
}

class IfnapMapViewState extends State<IfnapMapView> {
  MapboxMap? mapboxMap;

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      onMapCreated: _onMapCreated,
      cameraOptions: CameraOptions(
        center: Point(coordinates: Position(126.9780, 37.5665)),
        zoom: widget.initialZoom,
      ),
    );
  }

  Future<void> _onMapCreated(MapboxMap controller) async {
    mapboxMap = controller;

    // Enable Mapbox's native location puck
    await controller.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        pulsingColor: 0xFF2563EB,
      ),
    );

    // Request permission and fly to current position
    final position = await _getCurrentPosition();
    if (position != null) {
      await controller.flyTo(
        CameraOptions(
          center: Point(
            coordinates: Position(position.lng, position.lat),
          ),
          zoom: widget.initialZoom,
        ),
        MapAnimationOptions(duration: 800),
      );
    }
  }

  Future<({double lat, double lng})?> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    final pos = await Geolocator.getCurrentPosition();
    return (lat: pos.latitude, lng: pos.longitude);
  }

  void flyTo(Position position, {double zoom = 15}) {
    mapboxMap?.flyTo(
      CameraOptions(
        center: Point(coordinates: position),
        zoom: zoom,
      ),
      MapAnimationOptions(duration: 500),
    );
  }

  void zoomIn() => _adjustZoom(1);
  void zoomOut() => _adjustZoom(-1);

  void _adjustZoom(double delta) {
    mapboxMap?.getCameraState().then((state) {
      mapboxMap?.flyTo(
        CameraOptions(zoom: state.zoom + delta),
        MapAnimationOptions(duration: 300),
      );
    });
  }
}
