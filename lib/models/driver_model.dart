import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sim/models/car_model.dart';
import 'package:sim/models/personal_documents_models.dart';
import 'package:sim/models/review_model.dart';
import 'package:sim/models/vehicle_documents_model.dart';

class DriverModel {
  String? id;
  String? userId;
  String? stripeAccountId;
  Car? car;
  String? status;
  LatLng? location;
  bool? isVerified;
  bool? isVehicleApproved;
  PersonalDocuments? personalDocuments;
  VehicleDocuments? vehicleDocuments;
  double? balance;
  Reviews? reviews;
  String? oneSignalId;
  String? verificationStatus;

  DriverModel({
    this.id,
    this.userId,
    this.stripeAccountId,
    this.car,
    this.status,
    this.location,
    this.isVerified,
    this.isVehicleApproved,
    this.personalDocuments,
    this.vehicleDocuments,
    this.balance,
    this.reviews,
    this.oneSignalId,
    this.verificationStatus,
  });

  factory DriverModel.fromJson(json) {
    return DriverModel(
      id: json['_id'] ?? "",
      userId: json['user'] ?? "",
      stripeAccountId: json['stripe_account_id'] ?? "",
      car: json["car"] != null ? Car.fromJson(json['car']) : Car(),
      status: json['status'] ?? "",
      location: LatLng(
        (json['location']['coordinates'][1] as num).toDouble(), // Lat
        (json['location']['coordinates'][0] as num).toDouble(), // Lng
      ),
      isVerified: json['is_verified'] ?? false,
      isVehicleApproved: json['is_vehicle_approved'] ?? false,
      personalDocuments: json["personal_documents"] != null
          ? PersonalDocuments.fromJson(json["personal_documents"])
          : null,
      vehicleDocuments: json["vehicle_documents"] != null
          ? VehicleDocuments.fromJson(json["vehicle_documents"])
          : null,
      balance: (json['balance'] as num).toDouble(),
      reviews: json["reviews"] != null
          ? Reviews.fromJson(json['reviews'])
          : Reviews(),
      oneSignalId: json['one_signal_id'] ?? "",
      verificationStatus: json['verification_status'] ?? "",
    );
  }
}
