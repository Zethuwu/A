import 'package:abarrotes/AuthScreen.dart';
import 'package:abarrotes/CheckInScreen.dart';
import 'package:abarrotes/HomeScreen.dart';
import 'package:abarrotes/ProductEntryScreen.dart';
import 'package:abarrotes/ProductGridScreen.dart';
import 'package:abarrotes/PromotionScreen.dart';
import 'package:abarrotes/ReportsScreen.dart';
import 'package:abarrotes/ScanScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Abarrotes App',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Menú'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('Productos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductGridScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.qr_code_scanner),
            title: Text('Código de Barras'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.local_offer),
            title: Text('Promociones'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PromotionScreen()),
              );
            },
          ),
          if (isLoggedIn) ...[
            ListTile(
              leading: Icon(Icons.insert_chart),
              title: Text('Informes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('Checking'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckInScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_to_queue),
              title: const Text('Agregar Productos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductEntryScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
          ] else ...[
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Iniciar sesión'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthScreen()),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
