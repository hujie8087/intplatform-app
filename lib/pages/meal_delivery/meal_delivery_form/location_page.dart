import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';

class LocationPage extends StatefulWidget {
  final String fcName;

  const LocationPage({super.key, required this.fcName});

  @override
  // ignore: library_private_types_in_public_api
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  late MapController _mapController;
  late Timer _timer;
  late LatLng truck;
  late double truckAngle = 0;
  late List<LatLng> _trajectoryPoints;

  @override
  void initState() {
    super.initState();

    _mapController = MapController();
    truck = const LatLng(0, 0);
    _trajectoryPoints = [];
    refreshLocation();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      refreshLocation();
    });
  }

  void refreshLocation() async {
    final fcName = widget.fcName;

    // final resp = await queryLocationOfCar(fcName);
    // var data = resp["data"];
    // if (null != data) {
    //   _trajectoryPoints.add(LatLng(data["lat"], data["lng"]));
    //   truckAngle = double.parse(data["direction"]);
    //   _mapController.move(LatLng(data["lat"], data["lng"]), _mapController.camera.zoom);
    //   // debugPrint(truckAngle.toString());
    //   // debugPrint(json.encode(data));
    //   setState(() {
    //     truck = LatLng(data["lat"], data["lng"]);
    //   });
    // }
  }

  @override
  void dispose() {
    _timer.cancel();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(0.48048604726481986, 127.98990694475927),
          initialZoom: 15,
          interactionOptions: InteractionOptions(
            flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
          ),
        ),
        mapController: _mapController,
        children: [
          TileLayer(
            // Bring your own tiles
            // urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png?layers=P', // For demonstration only
            // urlTemplate: 'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', // For demonstration only
            urlTemplate:
                'https://www.google.com/maps/vt?lyrs=s@189&gl=en&x={x}&y={y}&z={z}',
            // For demonstration only
            userAgentPackageName: 'com.example.app', // Add your app identifier
            // And many more recommended properties!
          ),
          OverlayImageLayer(
            overlayImages: [
              OverlayImage(
                // Unrotated
                bounds: LatLngBounds(
                  const LatLng(0.703402, 127.961286),
                  const LatLng(0.643271, 127.992412),
                ),
                imageProvider: const AssetImage('assets/img/20240222-1.webp'),
              ),
              OverlayImage(
                // Unrotated
                bounds: LatLngBounds(
                  const LatLng(0.629532, 127.917396),
                  const LatLng(0.601535, 128.015329),
                ),
                imageProvider: const AssetImage('assets/img/20240222-2.webp'),
              ),
              OverlayImage(
                // Unrotated
                bounds: LatLngBounds(
                  const LatLng(0.554159, 127.883903),
                  const LatLng(0.462128, 128.047638),
                ),
                imageProvider: const AssetImage(
                  'assets/img/202407qcgx-south-all.webp',
                ),
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: truck,
                width: 50,
                height: 50,
                child: Transform.rotate(
                  angle: max(0, truckAngle ?? 0) * pi / 180,
                  child: Image.asset(
                    'assets/img/truck_3.png', // 使用 AssetImage 加载本地图标
                    width: 50, // 调整图标大小
                    height: 50,
                  ),
                ),
              ),
            ],
          ),
          PolylineLayer(
            polylines: [Polyline(points: _trajectoryPoints, strokeWidth: 3)],
          ),
        ],
      ),
    );
  }
}
