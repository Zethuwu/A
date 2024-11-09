import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Map<String, dynamic>> _productData;

  @override
  void initState() {
    super.initState();
    _productData = _fetchProductDetails(widget.productId);
  }

  Future<Map<String, dynamic>> _fetchProductDetails(String productId) async {
    try {
      DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      if (productDoc.exists) {
        return productDoc.data() as Map<String, dynamic>;
      } else {
        throw Exception("Producto no encontrado");
      }
    } catch (e) {
      print("Error al obtener detalles del producto: $e");
      throw Exception("Error al obtener detalles del producto");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalles del Producto"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _productData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Producto no encontrado"));
          }

          final productData = snapshot.data!;
          final String name = productData['name'] ?? "Nombre no disponible";
          final double price = productData['price']?.toDouble() ?? 0.0;
          final String expirationDate =
              productData['F_Vencimiento'] ?? "Sin fecha";
          final String imagePath =
              productData['imagePath'] ?? "default_image.png";

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen del producto
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage('assets/$imagePath'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Nombre del producto
                const Text(
                  "Nombre del Producto:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(name, style: const TextStyle(fontSize: 16)),
                const Divider(),
                // Precio del producto
                const Text(
                  "Precio:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('\$${price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16)),
                const Divider(),
                // Fecha de caducidad
                const Text(
                  "Fecha de Caducidad:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(expirationDate, style: const TextStyle(fontSize: 16)),
                const Divider(),
                // ID del producto
                const Text(
                  "ID del Producto:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(widget.productId, style: const TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );
  }
}
