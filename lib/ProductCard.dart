import 'package:flutter/material.dart';
import 'Product.dart';

class ProductCard extends StatelessWidget {
  final int index;

  ProductCard({required this.index});

  final List<Product> products = [
    Product(
      imageUrl:
          'assets/product1.png', // Reemplaza con tus imágenes de productos
      name: 'Producto 1',
      price: 10.0,
    ),
    Product(
      imageUrl: 'assets/product2.png',
      name: 'Producto 2',
      price: 20.0,
    ),
    // Agrega más productos
  ];

  @override
  Widget build(BuildContext context) {
    final product = products[index % products.length];
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                product.imageUrl,
                height: 120, // Incrementa el tamaño de la imagen
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              product.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
