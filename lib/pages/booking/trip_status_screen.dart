import 'package:sim/controller/driver_controller.dart';
import 'package:sim/pages/chat/chat_screen.dart';
import 'package:sim/resources/color_resources.dart';
import 'package:sim/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sim/models/ride_model.dart';
import 'package:sim/widget/build_icon_button.dart';
import 'package:http/http.dart' as http;

class TripStatusScreen extends StatefulWidget {
  final Ride ride;
  const TripStatusScreen({super.key, required this.ride});

  @override
  State<TripStatusScreen> createState() => _FindARideScreenState();
}

class _FindARideScreenState extends State<TripStatusScreen> {
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  RxString basePrice = "\$5000".obs;
  RxString estimatedTime = "".obs;
  final RxBool _isTripStart = true.obs;
  final _driverController = Get.find<DriverController>();

  @override
  void initState() {
    super.initState();
    _setMarkers();
    _getPolyline();
  }

  void _setMarkers() {
    _markers.add(Marker(
      markerId: const MarkerId("start"),
      position: LatLng(
        widget.ride.pickupLocation!.lat,
        widget.ride.pickupLocation!.lng,
      ),
      infoWindow: const InfoWindow(title: "Start Location"),
    ));
    _markers.add(Marker(
      markerId: const MarkerId("end"),
      position: LatLng(
        widget.ride.dropoffLocation!.lat,
        widget.ride.dropoffLocation!.lng,
      ),
      infoWindow: const InfoWindow(title: "End Location"),
    ));
    setState(() {});
  }

  Future<void> _getPolyline() async {
    final String url =
        "https://us1.locationiq.com/v1/directions/driving/${widget.ride.pickupLocation!.lng},${widget.ride.pickupLocation!.lat};${widget.ride.dropoffLocation!.lng},${widget.ride.dropoffLocation!.lat}?key=pk.d074964679caaa4f8b75ed81cd6b038a&overview=full&geometries=geojson";

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

      var distanceInMeters = data["routes"][0]["distance"];
      var durationInSeconds = data["routes"][0]["duration"];

      double distanceInKm = distanceInMeters / 1000;
      double durationInMinutes = durationInSeconds / 60;

      estimatedTime.value =
          "${durationInMinutes.toStringAsFixed(2)} min / ${distanceInKm.toStringAsFixed(2)}Km";
      print(estimatedTime.value);

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
      body: Stack(
        children: [
          SizedBox(
            height: Get.height * 0.7,
            width: Get.width,
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.ride.pickupLocation!.lat,
                  widget.ride.pickupLocation!.lng,
                ),
                zoom: 15,
              ),
              markers: _markers,
              polylines: _polylines,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 50,
            ),
            child: buildIconButton(
              icon: Icons.arrow_back,
              onTap: () => Get.back(),
            ),
          ),
          _buildBottomSheet(),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Obx(
                  () => CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      _driverController.userModel.value?.profilePicture ?? "",
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      String fullName =
                          "${_driverController.userModel.value?.firstName} ${_driverController.userModel.value?.lastName}";
                      return Text(
                        fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.yellowAccent,
                          size: 12,
                        ),
                        const SizedBox(width: 5),
                        Obx(
                          () => Text(
                            "${_driverController.driverModel.value?.reviews?.averageRating} ${(_driverController.driverModel.value?.reviews?.totalRatings)}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.to(() => ChatScreen(rideId: widget.ride.id ?? ""));
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.primaryColor,
                    ),
                    child: const Icon(
                      Icons.message,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pickup Location",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.ride.pickupLocation?.address ?? "",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Divider(color: AppColors.primaryColor),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Drop Off Location",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.ride.dropoffLocation?.address ?? "",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => Expanded(
                    child: CommonButton(
                      text: _isTripStart.value ? "Pause" : "Resume",
                      bgColor: _isTripStart.value
                          ? Colors.white
                          : AppColors.primaryColor,
                      textColor: Colors.black,
                      ontap: () {
                        _isTripStart.value = !_isTripStart.value;
                        if (!_isTripStart.value) {
                          _driverController.pauseTrip(widget.ride.id ?? "");
                        } else {
                          _driverController.resumeTrip(widget.ride.id ?? "");
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Obx(
                    () => CommonButton(
                      bgColor: Colors.red,
                      textColor: Colors.black,
                      ontap: () async {
                        _driverController.completeTrip(widget.ride.id ?? "");
                      },
                      child: _driverController.isloading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Complete trip",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
