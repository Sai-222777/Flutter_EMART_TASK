import 'package:cloud_firestore/cloud_firestore.dart';

class Product{
  final String id;  
  final String name;
  final String category;
  final int price;


Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
  });

  factory Product.fromFirestore(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'],
      category: data['category'],
      price: data['price'],
    );
  }

  Map<String, dynamic> toFirestore(){
    return {
      'name': name,
      'category': category,
      'price': price,
    };
  }

}