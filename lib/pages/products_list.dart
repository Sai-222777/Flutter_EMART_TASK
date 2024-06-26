import 'package:emart/pages/product_detail.dart';
import 'package:flutter/material.dart';


class ProductsList extends StatelessWidget {
  final String category;

  ProductsList({super.key, required this.category});

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

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> filteredProducts = products.where(
      (product) => product['category'] == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: ListView.builder(
        itemCount: filteredProducts.length,
        itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage('smartphone.jpeg'),
              ),
              title: Text(filteredProducts[index]['name']),
              subtitle: Text('${filteredProducts[index]['price'].toString()}/-'),
              onTap: (){
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ProductDetail(product: filteredProducts[index])),
                  );
              },
            ),
          );
        }
        ),
    );
    
  }
}