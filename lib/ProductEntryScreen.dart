import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product.dart';

class ProductEntryScreen extends StatefulWidget {
  @override
  _ProductEntryScreenState createState() => _ProductEntryScreenState();
}

class _ProductEntryScreenState extends State<ProductEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();
  final TextEditingController _expirationDateController =
      TextEditingController();

  Future<void> _saveProductToDatabase() async {
    if (_formKey.currentState!.validate()) {
      // Crear una instancia de Product con los datos ingresados
      Product product = Product(
        name: _nameController.text,
        price: double.parse(_priceController.text),
        imagePath: _imagePathController.text,
        F_Vencimiento: _expirationDateController.text,
      );

      // Agregar el producto a Firestore
      await FirebaseFirestore.instance.collection('products').add({
        'name': product.name,
        'price': product.price,
        'imagePath': product.imagePath,
        'F_Vencimiento': product.F_Vencimiento,
      });

      // Limpiar los campos después de guardar
      _nameController.clear();
      _priceController.clear();
      _imagePathController.clear();
      _expirationDateController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto agregado correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration:
                    const InputDecoration(labelText: 'Nombre del Producto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el nombre del producto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el precio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ingresa un precio válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imagePathController,
                decoration: const InputDecoration(labelText: 'Ruta de Imagen'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la ruta de la imagen';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _expirationDateController,
                decoration:
                    const InputDecoration(labelText: 'Fecha de Vencimiento'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la fecha de vencimiento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveProductToDatabase,
                  child: const Text('Guardar Producto'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
