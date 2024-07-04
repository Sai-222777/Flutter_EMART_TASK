import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart/pages/product_detail.dart';
import 'package:emart/product_service.dart';
import 'package:emart/products.dart';
import 'package:flutter/material.dart';


class ProductsList extends StatefulWidget {
  final String category;

  const ProductsList({super.key, required this.category});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {

  final productService = ProductService();

  final List<Map<String,dynamic>> products = [
    {'id':'p1','name':'Smartphone', 'price':12000, 'category' : 'Electronics'},
    {'id':'p2','name':'Headphone', 'price':3000, 'category' : 'Electronics'},
    {'id':'p3','name':'Smartwatch', 'price':8000, 'category' : 'Electronics'},
    {'id':'p4','name':'Sweatshirt', 'price':2000, 'category' : 'Fashion'},
    {'id':'p5','name':'Cargo Pants', 'price':800, 'category' : 'Fashion'},
    {'id':'p6','name':'Handbag', 'price':2000, 'category' : 'Fashion'},
    {'id':'p7','name':'Chair', 'price':1000, 'category' : 'Furniture'},
    {'id':'p8','name':'Table', 'price':4000, 'category' : 'Furniture'},
    {'id':'p9','name':'King Bed', 'price':35000, 'category' : 'Furniture'},
    {'id':'p10','name':'Half-Blood Prince', 'price':400, 'category' : 'Books'},
    {'id':'p11','name':'Lightninig Thief', 'price':300, 'category' : 'Books'},
    {'id':'p12','name':'The Fellowship Of The Ring', 'price':450, 'category' : 'Books'},
    {'id':'p13','name':'Football', 'price':500, 'category' : 'Sports'},
    {'id':'p14','name':'Tennis Bat', 'price':6000, 'category' : 'Sports'},
    {'id':'p15','name':'Sports Shoe', 'price':3000, 'category' : 'Sports'},
  ];

  List<Product>? filteredProducts;

  Future<void> updateProductByName(String name, String newName) async {
  var querySnapshot = await FirebaseFirestore.instance
      .collection('Products')
      .where('name', isEqualTo: name)
      .get();

  // If the document exists, update it
  if (querySnapshot.docs.isNotEmpty) {
    var docId = querySnapshot.docs.first.id;
    await FirebaseFirestore.instance
        .collection('Products')
        .doc(docId)
        .update({'name': newName});
  } else {
    print('Document with name $name not found');
  }
}

  @override
  Widget build(BuildContext context) {

    // final List<Map<String, dynamic>> filteredProducts = products.where(
    //   (product) => product['category'] == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Products').where('category', isEqualTo: widget.category).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator());
          }
          final filteredProducts = snapshot.data!.docs.map((doc) => Product.fromFirestore(doc)).toList();
          return ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('smartphone.jpeg'),
                  ),
                  title: Text(filteredProducts[index].name),
                  subtitle: Text('${filteredProducts[index].price.toString()}/-'),
                  onTap: (){
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context) => ProductDetail(product: filteredProducts[index])),
                      );
                  },
                ),
              );
            }
          );
        }
      ),
    );
    
  }
}