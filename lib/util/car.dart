class Car {
  final String id;
  final String name, imageUrl, carFuel, carLong, carLat,carDescription;

  Car({
    this.id,
    this.name,
    this.imageUrl,
    this.carFuel,
    this.carLat,
    this.carLong,
    this.carDescription
  });

  factory Car.fromJson(Map<String, dynamic> jsonData) {
    print("aasd ${jsonData['car_img_path']}");
    print("xd ${jsonData['uid']}");
    return Car(
      id: jsonData['uid'],
      name: jsonData['car_name'],
      carFuel: jsonData['car_fuel'],
      carLong: jsonData['car_long'],
      carLat: jsonData['car_lat'],
      carDescription:  jsonData['car_description'],
      imageUrl: "http://192.168.64.2/signaling/images/"+jsonData['car_img_path'],
    );
  }
}
