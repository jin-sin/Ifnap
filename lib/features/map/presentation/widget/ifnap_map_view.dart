import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' hide Position;
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';


class IfnapMapView extends StatefulWidget {
  const IfnapMapView({
    super.key,
    this.initialZoom = 15,
    this.markers,
  });

  final double initialZoom;

  /// If provided, renders a route line + circle annotations and fits the camera.
  final List<Position>? markers;

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

    await controller.location.updateSettings(
      LocationComponentSettings(
        enabled: true,
        pulsingEnabled: true,
        pulsingColor: 0xFF2563EB,
      ),
    );

    final markers = widget.markers;
    if (markers != null && markers.isNotEmpty) {
      final currentPos = await _getCurrentPosition();
      final routePositions = [
        if (currentPos != null) Position(currentPos.lng, currentPos.lat),
        ...markers,
      ];

      if (routePositions.length >= 2) await _addRouteLine(controller, routePositions);
      await _addCircleMarkers(controller, markers, startPos: routePositions.first, hasStart: currentPos != null);
      await _fitToMarkers(controller, routePositions);
    } else {
      final position = await _getCurrentPosition();
      if (position != null) {
        await controller.flyTo(
          CameraOptions(
            center: Point(coordinates: Position(position.lng, position.lat)),
            zoom: widget.initialZoom,
          ),
          MapAnimationOptions(duration: 800),
        );
      }
    }
  }

  static const _markerColors = [
    0xFF7B9CFF,
    0xFFFE9CF4,
    0xFF0050D4,
    0xFFD4956A,
    0xFFBE6BC4,
  ];

  Future<void> _addRouteLine(MapboxMap controller, List<Position> positions) async {
    final geometry = await _fetchRoadGeometry(positions) ?? positions;
    final manager = await controller.annotations.createPolylineAnnotationManager();
    await manager.create(
      PolylineAnnotationOptions(
        geometry: LineString(coordinates: geometry),
        lineColor: 0xFF0050D4,
        lineWidth: 3.0,
        lineOpacity: 0.8,
      ),
    );
  }

  Future<List<Position>?> _fetchRoadGeometry(List<Position> positions) async {
    const token = String.fromEnvironment('MAPBOX_TOKEN');
    if (token.isEmpty) return null;

    final waypoints = positions
        .map((p) => '${p.lng.toDouble()},${p.lat.toDouble()}')
        .join(';');

    final uri = Uri.parse(
      'https://api.mapbox.com/directions/v5/mapbox/driving/$waypoints'
      '?geometries=geojson&overview=full&access_token=$token',
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final routes = data['routes'] as List?;
      if (routes == null || routes.isEmpty) return null;

      return (routes[0]['geometry']['coordinates'] as List)
          .map((c) => Position((c as List)[0] as double, c[1] as double))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> _addCircleMarkers(
    MapboxMap controller,
    List<Position> stopPositions, {
    required Position startPos,
    required bool hasStart,
  }) async {
    final manager = await controller.annotations.createCircleAnnotationManager();

    if (hasStart) {
      await manager.create(CircleAnnotationOptions(
        geometry: Point(coordinates: startPos),
        circleColor: 0xFFDFE3E6,
        circleRadius: 10.0,
        circleStrokeWidth: 3.0,
        circleStrokeColor: 0xFFFFFFFF,
      ));
    }

    for (int i = 0; i < stopPositions.length; i++) {
      await manager.create(CircleAnnotationOptions(
        geometry: Point(coordinates: stopPositions[i]),
        circleColor: _markerColors[i % _markerColors.length],
        circleRadius: 10.0,
        circleStrokeWidth: 3.0,
        circleStrokeColor: 0xFFFFFFFF,
      ));
    }
  }

  Future<void> _fitToMarkers(MapboxMap controller, List<Position> positions) async {
    var minLat = positions[0].lat.toDouble();
    var maxLat = positions[0].lat.toDouble();
    var minLng = positions[0].lng.toDouble();
    var maxLng = positions[0].lng.toDouble();

    for (final p in positions) {
      final lat = p.lat.toDouble();
      final lng = p.lng.toDouble();
      if (lat < minLat) minLat = lat;
      if (lat > maxLat) maxLat = lat;
      if (lng < minLng) minLng = lng;
      if (lng > maxLng) maxLng = lng;
    }

    const pad = 0.03;
    final camera = await controller.cameraForCoordinateBounds(
      CoordinateBounds(
        southwest: Point(coordinates: Position(minLng - pad, minLat - pad)),
        northeast: Point(coordinates: Position(maxLng + pad, maxLat + pad)),
        infiniteBounds: false,
      ),
      MbxEdgeInsets(top: 40, left: 40, bottom: 80, right: 40),
      null, null, null, null,
    );

    await controller.setCamera(camera);
  }

  Future<({double lat, double lng})?> _getCurrentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;

    var permission = await Geolocator.checkPermission();
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
      CameraOptions(center: Point(coordinates: position), zoom: zoom),
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
