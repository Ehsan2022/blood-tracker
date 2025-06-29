class Donation {
  final int? id;
  final int donorId;
  final String? date;
  final String? hospital;
  final int? units;
  final String? notes;

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
    id: json['id'] as int?,
    date: json['date']?.toString(),
    hospital: json['hospital']?.toString(),
    units: json['units'] as int?,
    notes: json['notes']?.toString(),
    donorId: json['donor'] != null ? (json['donor'] is Map ? json['donor']['id'] : json['donor']) as int : 0, // Default to 0 if not present
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



