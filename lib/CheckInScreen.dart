import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckInScreen extends StatefulWidget {
  @override
  _CheckInScreenState createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userId;
  DateTime? checkInTime;
  DateTime? checkOutTime;
  String workedTimeText = '';

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

  Future<void> _handleCheckIn() async {
    if (userId == null) return;

    final now = DateTime.now();
    await _firestore.collection('attendance').add({
      'userId': userId,
      'checkIn': now,
      'checkOut': null,
      'date': DateTime(now.year, now.month, now.day),
    });

    setState(() {
      checkInTime = now;
      workedTimeText = '';
    });
  }

  Future<void> _handleCheckOut() async {
    if (userId == null || checkInTime == null) return;

    final now = DateTime.now();
    final checkInDate =
        DateTime(checkInTime!.year, checkInTime!.month, checkInTime!.day);
    final attendanceRef = _firestore
        .collection('attendance')
        .where('userId', isEqualTo: userId)
        .where('date', isEqualTo: checkInDate)
        .where('checkOut', isEqualTo: null);

    final attendanceSnap = await attendanceRef.get();

    if (attendanceSnap.docs.isNotEmpty) {
      final attendanceDoc = attendanceSnap.docs.first.reference;
      await attendanceDoc.update({'checkOut': now});

      final duration = now.difference(checkInTime!);
      final workedHours = duration.inHours;
      final workedMinutes = duration.inMinutes.remainder(60);
      final workedSeconds = duration.inSeconds.remainder(60);

      setState(() {
        checkOutTime = now;
        workedTimeText =
            "Tiempo trabajado: $workedHours horas, $workedMinutes minutos, $workedSeconds segundos";
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Horas trabajadas"),
          content: Text(
              "Has trabajado $workedHours horas, $workedMinutes minutos, y $workedSeconds segundos hoy."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Error"),
          content: Text("No se encontró un registro de entrada sin salida."),
        ),
      );
    }
  }

  void _viewAllCheckIns() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CheckInHistoryScreen(userId: userId!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro de Entrada y Salida"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              checkInTime == null
                  ? "No has hecho check-in todavía"
                  : "Check-in registrado a las ${checkInTime!.hour}:${checkInTime!.minute} del ${checkInTime!.day}/${checkInTime!.month}/${checkInTime!.year}",
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              workedTimeText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkInTime == null ? _handleCheckIn : null,
              child: const Text("Hacer Check-in"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkInTime != null && checkOutTime == null
                  ? _handleCheckOut
                  : null,
              child: const Text("Hacer Check-out"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _viewAllCheckIns,
              child: const Text("Ver Historial de Check-ins y Check-outs"),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckInHistoryScreen extends StatelessWidget {
  final String userId;

  CheckInHistoryScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Asistencia"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('attendance')
            .where('userId', isEqualTo: userId)
            .orderBy('checkIn', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No hay registros disponibles."));
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];
              final checkIn = (doc['checkIn'] as Timestamp).toDate();
              final checkOut = doc['checkOut'] != null
                  ? (doc['checkOut'] as Timestamp).toDate()
                  : null;

              // Calcula las horas trabajadas
              Duration? duration;
              if (checkOut != null) {
                duration = checkOut.difference(checkIn);
              }

              String hoursWorked = "";
              if (duration != null) {
                final hours = duration.inHours;
                final minutes = duration.inMinutes.remainder(60);
                final seconds = duration.inSeconds.remainder(60);
                hoursWorked =
                    "$hours horas, $minutes minutos, $seconds segundos";
              } else {
                hoursWorked = "Actualmente trabajando";
              }

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Check-in: ${checkIn.toLocal()}",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        checkOut != null
                            ? "Check-out: ${checkOut.toLocal()}"
                            : "Check-out: No registrado",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Horas trabajadas: $hoursWorked",
                        style: const TextStyle(
                            fontSize: 16, color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
