// product_detail_screen.dart
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final String name;
  final double price;
  final String expirationDate;
  final String productId;

  const ProductDetailScreen({
    required this.name,
    required this.price,
    required this.expirationDate,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Producto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nombre del Producto:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontSize: 16)),
            const Divider(),
            const Text(
              "Precio:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('\$${price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
            const Divider(),
            const Text(
              "Fecha de Caducidad:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(expirationDate, style: const TextStyle(fontSize: 16)),
            const Divider(),
            const Text(
              "ID del Producto:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(productId, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
