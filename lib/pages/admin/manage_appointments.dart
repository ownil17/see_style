import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/appointment_provider.dart';

class ManageAppointments extends StatelessWidget {
  const ManageAppointments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final appointments = appointmentProvider.appointments;

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Appointments")),
      body: appointments.isEmpty
          ? const Center(child: Text("No Appointments Available"))
          : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(appointment.patientName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email: ${appointment.patientEmail}"),
                        Text("Date: ${appointment.date.toLocal()}"),
                        Text("Time: ${appointment.time}"),
                        Text("Status: ${appointment.status}", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == "Approve") {
                          appointmentProvider.approveAppointment(appointment.id);
                        } else if (value == "Reject") {
                          appointmentProvider.rejectAppointment(appointment.id);
                        } else if (value == "Complete") {
                          appointmentProvider.completeAppointment(appointment.id);
                        } else if (value == "Delete") {
                          appointmentProvider.deleteAppointment(appointment.id);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: "Approve", child: Text("Approve")),
                        const PopupMenuItem(value: "Reject", child: Text("Reject")),
                        const PopupMenuItem(value: "Complete", child: Text("Mark as Completed")),
                        const PopupMenuItem(value: "Delete", child: Text("Delete")),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
