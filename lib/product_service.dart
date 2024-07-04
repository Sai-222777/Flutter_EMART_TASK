import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart/products.dart';

class ProductService {
  final CollectionReference productCollection = FirebaseFirestore.instance.collection('Products');

  Future<List<Product>> fetchProducts() async {
    QuerySnapshot querySnapshot = await productCollection.get();
    return querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  Future<List<Product>> fetchProductsByCategory(String category) async {
    QuerySnapshot querySnapshot = await productCollection.where('category', isEqualTo: category).get();
    return querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }
}
