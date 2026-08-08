class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String city;
  final String street;
  final String zipcode;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.city,
    required this.street,
    required this.zipcode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final name = json['name'] ?? {};
    final address = json['address'] ?? {};

    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: name['firstname'] ?? '',
      lastName: name['lastname'] ?? '',
      phone: json['phone'] ?? '',
      city: address['city'] ?? '',
      street: address['street'] ?? '',
      zipcode: address['zipcode'] ?? '',
    );
  }
}
