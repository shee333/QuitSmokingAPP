class SmokingEntry {
  final DateTime dateTime;
  final String? note;

  SmokingEntry({required this.dateTime, this.note});

  Map<String, dynamic> toJson() => {
        'dateTime': dateTime.toIso8601String(),
        'note': note,
      };

  static SmokingEntry fromJson(Map<String, dynamic> json) {
    return SmokingEntry(
      dateTime: DateTime.parse(json['dateTime'] as String),
      note: json['note'] as String?,
    );
  }
}


