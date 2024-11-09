import 'package:abarrotes/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obtener todos los productos de la colección
  Future<List<Product>> getProducts() async {
    QuerySnapshot querySnapshot = await _firestore.collection('products').get();

    // Mapea los documentos a una lista de productos
    return querySnapshot.docs.map((doc) {
      return Product.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}
