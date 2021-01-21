class Driver {
  String id;
  String name;
  String phone;
  String truckNumber;
  double truckSize;

  Driver({this.id, this.name, this.phone, this.truckNumber, this.truckSize});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      name: json['name'],
      truckNumber: json['truckNumber'],
      truckSize: double.parse(json['truckSize'].toString()),
    );
  }
}
