import 'package:flutter/scheduler.dart';

class Product {
  final String name;
  final double price;
  final String imagePath;
  final String F_Vencimiento;

  Product({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.F_Vencimiento,
  });

  // Método para crear una instancia de Product desde un documento de Firestore
  factory Product.fromFirestore(Map<String, dynamic> data) {
    return Product(
      name: data['name'],
      price: data['price'].toDouble(),
      imagePath: data['imagePath'],
      F_Vencimiento: data['F_Vencimiento'],
    );
  }
}
