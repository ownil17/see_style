import 'package:hive/hive.dart';

part 'appointment_model.g.dart';

@HiveType(typeId: 2)
class Appointment {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String patientName;

  @HiveField(2)
  final String patientEmail;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String time;

  @HiveField(5)
  String status; // "Pending", "Approved", "Rejected", "Completed"

  Appointment({
    required this.id,
    required this.patientName,
    required this.patientEmail,
    required this.date,
    required this.time,
    this.status = "Pending",
  });
}
