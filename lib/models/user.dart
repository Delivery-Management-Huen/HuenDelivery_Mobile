class User {
  num idx;
  String id;
  String name;
  String address;
  num role;

  User({this.idx, this.id, this.name, this.address, this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        idx: json['idx'],
        id: json['id'],
        name: json['name'],
        address: json['address'],
        role: json['role']);
  }
}
