// drawer_menu.dart
import 'package:abarrotes/PromotionScreen.dart';
import 'package:flutter/material.dart';
import 'ScanScreen.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categorías'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.qr_code_scanner),
            title: const Text('Escanear Producto'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.price_check_outlined),
            title: const Text('Promociones'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PromotionScreen()),
              );
            },
          ),
          // Agrega más elementos de menú aquí
        ],
      ),
    );
  }
}
