import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'widget/ifnap_map_view.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _mapKey = GlobalKey<IfnapMapViewState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IfnapMapView(key: _mapKey),


          // Floating controls (bottom-right)
          Positioned(
            right: 24,
            bottom: 40,
            child: Column(
              children: [
                _MapFab(
                  icon: Icons.add,
                  onTap: () => _mapKey.currentState?.zoomIn(),
                ),
                const SizedBox(height: 12),
                _MapFab(
                  icon: Icons.my_location_rounded,
                  onTap: () => _mapKey.currentState?.flyTo(
                    Position(126.9780, 37.5665),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapFab extends StatelessWidget {
  const _MapFab({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 15,
              offset: Offset(0, 10),
            ),
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 24, color: const Color(0xFF1F2937)),
      ),
    );
  }
}