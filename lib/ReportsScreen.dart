import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final _noteController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Método para añadir una nota a Firestore
  Future<void> _addNote() async {
    final user = _auth.currentUser;
    if (user != null && _noteController.text.isNotEmpty) {
      await _firestore.collection('work_notes').add({
        'user': user.email,
        'content': _noteController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _noteController.clear();
    }
  }

  // Método para eliminar una nota por ID
  Future<void> _deleteNote(String noteId) async {
    await _firestore.collection('work_notes').doc(noteId).delete();
  }

  // Mostrar dialogo de detalles de la nota
  void _showNoteDialog(Map<String, dynamic> noteData) {
    final user = noteData['user'] ?? 'Usuario desconocido';
    final content = noteData['content'] ?? '';
    final timestamp = noteData['timestamp'] as Timestamp?;

    String formattedTime = '';
    if (timestamp != null) {
      final date = timestamp.toDate();
      formattedTime =
          '${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute}';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalles de la Nota'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Usuario: $user'),
            const SizedBox(height: 8),
            Text('Contenido: $content'),
            const SizedBox(height: 8),
            Text('Fecha: $formattedTime'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas de Trabajo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Escribe una nota de trabajo',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addNote,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('work_notes')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No hay notas de trabajo'));
                }

                final notes = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    final noteData = note.data() as Map<String, dynamic>;
                    final content = noteData['content'] ?? '';
                    final user = noteData['user'] ?? 'Usuario desconocido';
                    final timestamp = noteData['timestamp'] as Timestamp?;

                    String formattedTime = '';
                    if (timestamp != null) {
                      final date = timestamp.toDate();
                      formattedTime =
                          '${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute}';
                    }

                    return GestureDetector(
                      onTap: () => _showNoteDialog(noteData),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(content,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(137, 31, 30, 30),
                                      )),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Por: $user',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Fecha: $formattedTime',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await _deleteNote(note.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
