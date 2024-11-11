import 'package:flutter/material.dart';
import 'product.dart';

class ProductDetailScreen2 extends StatelessWidget {
  final Product product;

  ProductDetailScreen2({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Imagen principal del producto
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage('assets/${product.imagePath}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Nombre del producto
              Text(
                product.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Precio del producto
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Fecha de vencimiento
              Text(
                'Fecha de Vencimiento: ${product.F_Vencimiento}',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              SizedBox(height: 20),
              // Imagen adicional en la parte inferior
              Container(
                height: 150,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  image: DecorationImage(
                    image: AssetImage('assets/${product.name}Code.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Botón de regreso
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
