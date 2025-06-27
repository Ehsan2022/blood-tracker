class Donation {
  final int? id;
  final int donorId;
  final String date;
  final String hospital;
  final int units;
  final String notes;

  Donation({
    this.id,
    required this.donorId,
    required this.date,
    required this.hospital,
    required this.units,
    required this.notes,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id'],
      donorId: json['donor']['id'],
      date: json['date'],
      hospital: json['hospital'],
      units: json['units'],
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'hospital': hospital,
      'units': units,
      'notes': notes,
      'donor': {'id': donorId}
    };
  }
}
