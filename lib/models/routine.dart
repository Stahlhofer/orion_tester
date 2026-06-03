class Routine {
  final int? id;
  final String name;
  final String date;
  final String fullName;
  final String createdAt;
  final String observations;

  Routine({
    this.id,
    required this.name,
    required this.date,
    required this.fullName,
    required this.createdAt,
    required this.observations,
  });

  Routine copyWith({
    int? id,
    String? name,
    String? date,
    String? fullName,
    String? createdAt,
    String? observations,
  }) {
    return Routine(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      fullName: fullName ?? this.fullName,
      createdAt: createdAt ?? this.createdAt,
      observations: observations ?? this.observations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'full_name': fullName,
      'created_at': createdAt,
      'observations': observations,
    }..removeWhere((key, value) => value == null);
  }

  factory Routine.fromMap(Map<String, dynamic> map) {
    return Routine(
      id: map['id'] as int?,
      name: map['name'] as String,
      date: map['date'] as String,
      fullName: map['full_name'] as String,
      createdAt: map['created_at'] as String,
      observations: map['observations'] as String? ?? '',
    );
  }
}
