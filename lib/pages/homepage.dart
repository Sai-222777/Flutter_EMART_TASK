import 'package:emart/pages/cart_page.dart';
import 'package:emart/pages/favourites_page.dart';
import 'package:emart/pages/loginpage.dart';
import 'package:emart/pages/products_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Electronics', 'icon': Icons.electrical_services},
      {'name': 'Fashion','icon':Icons.checkroom},
      {'name': 'Furniture', 'icon': Icons.chair},
      {'name': 'Books', 'icon': Icons.book},
      {'name': 'Sports', 'icon': Icons.sports_tennis},
      ];

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Center(child: Text('E-mart Home', style: TextStyle(fontWeight: FontWeight.bold),)),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.star),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => FavouritesPage()));
          },
        ),
      ),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 25),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: categories.length,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductsList(category: categories[index]['name'] as String)),);
                    },
                    child: Card(
                      elevation: 5,
                      color: Colors.amber.shade700,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(categories[index]['icon'] as IconData, size: 40),
                          const SizedBox(height: 10),
                          Text(
                            categories[index]['name'] as String,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ), 
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
           Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CartPage(),
            ),
          );
        }, 
        child: const Icon(Icons.shopping_cart),),
    );
  }
}