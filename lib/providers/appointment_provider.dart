import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/appointment_model.dart';
import 'package:uuid/uuid.dart';

class AppointmentProvider extends ChangeNotifier {
  final Box<Appointment> _appointmentBox = Hive.box<Appointment>('appointments');

  List<Appointment> get appointments => _appointmentBox.values.toList();

  // Add a new appointment
  void addAppointment(String patientName, String patientEmail, DateTime date, String time) {
    final newAppointment = Appointment(
      id: const Uuid().v4(),
      patientName: patientName,
      patientEmail: patientEmail,
      date: date,
      time: time,
    );
    _appointmentBox.put(newAppointment.id, newAppointment);
    notifyListeners();
  }

  // Approve an appointment
  void approveAppointment(String id) {
    final appointment = _appointmentBox.get(id);
    if (appointment != null) {
      appointment.status = "Approved";
      _appointmentBox.put(id, appointment);
      notifyListeners();
    }
  }

  // Reject an appointment
  void rejectAppointment(String id) {
    final appointment = _appointmentBox.get(id);
    if (appointment != null) {
      appointment.status = "Rejected";
      _appointmentBox.put(id, appointment);
      notifyListeners();
    }
  }

  // Mark an appointment as completed
  void completeAppointment(String id) {
    final appointment = _appointmentBox.get(id);
    if (appointment != null) {
      appointment.status = "Completed";
      _appointmentBox.put(id, appointment);
      notifyListeners();
    }
  }

  // Delete an appointment
  void deleteAppointment(String id) {
    _appointmentBox.delete(id);
    notifyListeners();
  }
}
