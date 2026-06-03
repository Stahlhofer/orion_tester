import 'package:intl/intl.dart';

class TestItem {
  final int? id;
  final int routineId;
  final String name;
  final String address;
  final String comment;
  final bool tested;
  final bool status;
  final String? dateTime;

  TestItem({
    this.id,
    required this.routineId,
    required this.name,
    required this.address,
    required this.comment,
    required this.tested,
    required this.status,
    required this.dateTime,
  });

  TestItem copyWith({
    int? id,
    int? routineId,
    String? name,
    String? address,
    String? comment,
    bool? tested,
    bool? status,
    String? dateTime,
  }) {
    return TestItem(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      name: name ?? this.name,
      address: address ?? this.address,
      comment: comment ?? this.comment,
      tested: tested ?? this.tested,
      status: status ?? this.status,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'routine_id': routineId,
      'name': name,
      'address': address,
      'comment': comment,
      'tested': tested ? 1 : 0,
      'status': status ? 1 : 0,
      'dateTime': dateTime ?? '',
    }..removeWhere((key, value) => value == null);
  }

  String get formattedDateTime {
    if (dateTime == null || dateTime!.isEmpty) {
      return 'N/A';
    }

    final dataHora = DateTime.tryParse(dateTime!);

    if (dataHora == null) {
      return 'N/A';
    }

    return DateFormat('HH:mm dd/MM/yyyy').format(dataHora);
  }

  factory TestItem.fromMap(Map<String, dynamic> map) {
    return TestItem(
      id: map['id'] as int?,
      routineId: map['routine_id'] as int,
      name: map['name'] as String,
      address: map['address'] as String,
      comment: map['comment'] as String? ?? '',
      tested: (map['tested'] as int? ?? 0) == 1,
      status: (map['status'] as int? ?? 0) == 1,
      dateTime: map['dateTime'] as String? ?? '',
    );
  }
}
