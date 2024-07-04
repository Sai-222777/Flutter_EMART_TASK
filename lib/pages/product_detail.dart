import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart/cart.dart';
import 'package:emart/products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatelessWidget {
  
  // final Map<String, dynamic> product;
  
  final Product product;

  const ProductDetail({required this.product});

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<Cart>(context, listen: false);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
    final CollectionReference cartCollection = FirebaseFirestore.instance.collection('carts');


    Future<void> addToFavorites(String productId) async {
      User? user = _auth.currentUser;
      if (user != null) {
        await userCollection.doc(user.uid).set({
          'favorites': FieldValue.arrayUnion([productId])
        }, SetOptions(merge: true));
      }
    }

    Future<void> addToCart(String productName, String productId, int price) async {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot cartSnapshot = await  cartCollection.doc('${user.uid}cart').get();
        if(cartSnapshot.exists)
        {
          List<dynamic> cartItems = cartSnapshot['cartItems'];
          int totalPrice = cartSnapshot['totalPrice'];
          int existingIndex = cartItems.indexWhere((item) => item['productId'] == productId);
          if(existingIndex != -1)
          {
            cartItems[existingIndex]['quantity'] += 1;
          }
          else 
          {
            Map<String, dynamic> newCartItem = {
                'productId': productId,
                'productName': productName,
                'price': price,
                'quantity': 1,
              };
            cartItems.add(newCartItem);
          }
          await cartCollection.doc('${user.uid}cart').set({
            'cartItems': cartItems,
            'totalPrice': totalPrice + price,
          });
        }
        else
        {
          Map<String, dynamic> newCartItem = {
            'productId': productId,
            'productName': productName,
            'price': price,
            'quantity': 1,
          };
          await cartCollection.doc('${user.uid}cart').set({
            'cartItems': [newCartItem],
            'totalPrice': price,
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$productName added to cart'), duration:Duration(seconds: 2),),
        );
      }
    }


    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 15.0,),
            // Image.asset(
            //   '${product['image']}',
            //   height: 300,
            //   fit: BoxFit.cover,
            // ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        product.name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10.0,),
                      TextButton(
                        onPressed: () async {
                          await addToFavorites(product.name);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Item added to Favorites'),
                              duration: Duration(seconds: 2),
                            )
                          );
                        }, 
                        child: Text('ADD TO FAVOURITES')
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Text(
                  //   product.description?? '',
                  //   style: const TextStyle(fontSize: 18),
                  // ),
                  const SizedBox(height: 10),
                  Text(
                    'Price: ${product.price}/-',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Add to Cart'),
                    onPressed: () {
                        cart.addItem(
                          product.id,
                          product.name,
                          product.price
                          );
                          addToCart(product.name,product.id,product.price);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Item added to cart'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
