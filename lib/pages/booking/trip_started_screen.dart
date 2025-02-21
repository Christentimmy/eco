import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sim/controller/driver_controller.dart';
import 'package:sim/widget/custom_button.dart';

class TripStartedScreen extends StatefulWidget {
  final LatLng fromLocation;
  final LatLng toLocation;
  final String rideId;
  const TripStartedScreen({
    super.key,
    required this.fromLocation,
    required this.toLocation,
    required this.rideId,
  });

  @override
  State<TripStartedScreen> createState() => _TripStartedScreenState();
}

class _TripStartedScreenState extends State<TripStartedScreen> {
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final _driverController = Get.find<DriverController>();
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _setMarkers();
    _getPolyline();
  }

  void _setMarkers() {
    _markers.add(Marker(
      markerId: const MarkerId("start"),
      position: widget.fromLocation,
      infoWindow: const InfoWindow(title: "Start Location"),
    ));
    _markers.add(Marker(
      markerId: const MarkerId("end"),
      position: widget.toLocation,
      infoWindow: const InfoWindow(title: "End Location"),
    ));
    setState(() {});
  }

  Future<void> _getPolyline() async {
    print("From Location: ${widget.fromLocation}");
    print("To Location: ${widget.toLocation}");
    final String url =
        "https://us1.locationiq.com/v1/directions/driving/${widget.fromLocation.longitude},${widget.fromLocation.latitude};${widget.toLocation.longitude},${widget.toLocation.latitude}?key=pk.d074964679caaa4f8b75ed81cd6b038a&overview=full&geometries=geojson";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data.containsKey("routes") && data["routes"].isNotEmpty) {
      List<LatLng> polylineCoordinates = [];

      var route = data["routes"][0]["geometry"]["coordinates"];
      for (var point in route) {
        polylineCoordinates.add(
          LatLng(point[1], point[0]),
        );
      }

      setState(() {
        _polylines.add(Polyline(
          polylineId: const PolylineId("route"),
          color: Colors.blue,
          width: 5,
          points: polylineCoordinates,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CommonButton(
        width: Get.width / 1.5,
        ontap: () async {
          await _driverController.cancelTrip(
            rideId: widget.rideId,
          );
        },
        child: const Text(
          "Cancel Trip",
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(() {
        if (_mapController != null) {
          _mapController?.animateCamera(
            CameraUpdate.newLatLng(_driverController.driverLocation.value),
          );
        }

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _driverController.driverLocation.value,
            zoom: 8,
          ),
          mapType: MapType.hybrid,
          markers: {
            Marker(
              markerId: const MarkerId('driver'),
              position: _driverController.driverLocation.value,
              infoWindow: const InfoWindow(title: 'Driver'),
            ),
          },
          polylines: _polylines,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
        );
      }),
    );
  }
}
