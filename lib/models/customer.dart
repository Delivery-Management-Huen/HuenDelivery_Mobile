class Customer {
  num idx;
  String name;
  String address;
  String phone;

  Customer({this.idx, this.name, this.address, this.phone});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      idx: json['idx'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
    );
  }
}
