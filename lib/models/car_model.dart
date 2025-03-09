class Car {
  String? carNumber;
  String? model;
  String? manufacturer;
  int? yearOfManufacture;
  String? color;
  int? capacity;

  Car({
    this.carNumber,
    this.model,
    this.manufacturer = '',
    this.yearOfManufacture,
    this.color = '',
    this.capacity = 4,
  });

  Map<String, dynamic> toJson() {
    return {
      'car_number': carNumber,
      'model': model,
      'manufacturer': manufacturer,
      'year_of_manufacture': yearOfManufacture,
      'color': color,
      'capacity': capacity,
    };
  }

  factory Car.fromJson(json) {
    return Car(
      carNumber: json['car_number'] ?? "",
      model: json['model'] ?? "",
      manufacturer: json['manufacturer'] ?? '',
      yearOfManufacture: json['year_of_manufacture'] ?? 0,
      color: json['color'] ?? '',
      capacity: json['capacity'] ?? 4,
    );
  }
}
