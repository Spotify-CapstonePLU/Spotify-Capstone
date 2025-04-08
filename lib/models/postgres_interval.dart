class PostgresInterval {
  final int days;

  PostgresInterval({required this.days});

  factory PostgresInterval.fromJson(Map<String, dynamic> json) {
    return PostgresInterval(days: json['days']);
  }
}
