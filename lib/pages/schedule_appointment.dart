import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import '../providers/appointment_provider.dart';
import 'favorite_page.dart';
import '../pages/home_page.dart';


class ScheduleAppointment extends StatefulWidget {
  const ScheduleAppointment({Key? key}) : super(key: key);

  @override
  _ScheduleAppointmentState createState() => _ScheduleAppointmentState();
}

class _ScheduleAppointmentState extends State<ScheduleAppointment> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedTime;
  int _selectedIndex = 1; // Ensure the bottom bar highlights "Calendar"

  final List<String> availableTimes = [
    "09:00 AM", "10:00 AM", "11:00 AM",
    "01:00 PM", "02:00 PM", "03:00 PM", "04:00 PM",
  ];

  // Pick a date
  Future<void> _pickDate() async {
    Future.microtask(() async {
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Close any SnackBars

      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1),
      );

      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  }

  // Submit appointment
  void _submitAppointment() {
    final provider = Provider.of<AppointmentProvider>(context, listen: false);
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || email.isEmpty || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields!")),
      );
      return;
    }

    provider.addAppointment(name, email, _selectedDate!, _selectedTime!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Appointment Scheduled Successfully!")),
    );

    setState(() {
      _nameController.clear();
      _emailController.clear();
      _selectedDate = null;
      _selectedTime = null;
    });
  }

  // Handle bottom navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) return; // Stay on the current page

    if (index == 0) {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return child; // No transition effect
            },
          ),
    );
    // Replace with your actual home route
    }
  }


  @override
  Widget build(BuildContext context) {
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final appointments = appointmentProvider.appointments;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 40, 44, 52),

      // Drawer for Hamburger Menu
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color.fromARGB(255, 40, 44, 52)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Menu",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text("Log Out"),
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),

      // App Bar
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 40, 44, 52),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text(
          "Appointment",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),

      // Main Body
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Form Section
            TextField(
              controller: _nameController,
              style: TextStyle(color: Colors.white), // Set text color to white
              decoration: const InputDecoration(
                labelText: "Full Name",
                labelStyle: TextStyle(color: Colors.white), // Set label text color to white
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Set underline color to white
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Set underline color to white when focused
                ),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _emailController,
              style: TextStyle(color: Colors.white), // Set text color to white
              decoration: const InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.white), // Set label text color to white
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Set underline color to white
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Set underline color to white when focused
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),


            // Date Picker
            ListTile(
              title: Text(
                _selectedDate == null
                    ? "Select Appointment Date"
                    : "Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}",
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
              trailing: const Icon(
                Icons.calendar_today,
                color: Colors.white, // Set icon color to white
              ),
              onTap: _pickDate,
            ),
            const SizedBox(height: 20),


            // Time Dropdown
            DropdownButtonFormField<String>(
              value: _selectedTime,
              hint: const Text(
                "Select Time Slot",
                style: TextStyle(color: Colors.white), // Make hint text white
              ),
              dropdownColor: Colors.black, // Optional: Set dropdown background color
              style: const TextStyle(color: Colors.white), // Make selected item white
              iconEnabledColor: Colors.white, // Make dropdown arrow white
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Make underline white
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Make underline white when focused
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedTime = value;
                });
              },
              items: availableTimes.map((time) {
                return DropdownMenuItem(
                  value: time,
                  child: Text(
                    time,
                    style: const TextStyle(color: Colors.white), // Make dropdown items white
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),


            // Submit Button
            ElevatedButton(
              onPressed: _submitAppointment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Set background to white
                foregroundColor: Colors.black, // Set text color to black
              ),
              child: const Text("Book Appointment"),
            ),


            const SizedBox(height: 30),

            // Appointment Status Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Your Appointments",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),

            // Appointment List
            Expanded(
              child: appointments.isEmpty
                  ? const Center(child: Text(
                    "No Appointments Scheduled",
                    style: TextStyle(color: Colors.white),
                    ),
                  )
                  : ListView.builder(
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = appointments[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          color: Colors.white,
                          child: ListTile(
                            title: Text("Date: ${DateFormat('yyyy-MM-dd').format(appointment.date)}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Time: ${appointment.time}"),
                                Text("Status: ${appointment.status}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: appointment.status == "Approved"
                                          ? Colors.green
                                          : appointment.status == "Rejected"
                                              ? Colors.red
                                              : Colors.orange,
                                    )),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today, size: 30), label: "Appointment"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment, size: 30), label: "Order Status"),
          BottomNavigationBarItem(icon: Icon(Icons.person, size: 30), label: "Profile"),
        ],
      ),
    );
  }
}
