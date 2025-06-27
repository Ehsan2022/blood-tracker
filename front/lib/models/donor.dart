class Donor {
  final int? id;
  final String name;
  final int age;
  final String gender;
  final String bloodGroup;
  final String phone;
  final String city;
  final String lastDonation;

  Donor({this.id, required this.name, required this.age, required this.gender, required this.bloodGroup, required this.phone, required this.city, required this.lastDonation});

  factory Donor.fromJson(Map<String, dynamic> json) => Donor(
    id: json['id'],
    name: json['name'],
    age: json['age'],
    gender: json['gender'],
    bloodGroup: json['bloodGroup'],
    phone: json['phone'],
    city: json['city'],
    lastDonation: json['lastDonation'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'gender': gender,
    'bloodGroup': bloodGroup,
    'phone': phone,
    'city': city,
    'lastDonation': lastDonation,
  };
}
