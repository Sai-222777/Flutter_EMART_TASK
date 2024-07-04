import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart/cart.dart';
import 'package:emart/pages/product_detail.dart';
import 'package:emart/products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference cartCollection = FirebaseFirestore.instance.collection('carts');

  late Future<List<Map<String,dynamic>>> _cartItems;
  late Future<int> total;

  @override
  void initState() {
    super.initState();
    _cartItems = fetchCart();
    total = fetchTotal();
  }

  Future<int> fetchTotal() async {
    User? user = _auth.currentUser;
    if (user != null)
    {
      DocumentSnapshot doc = await cartCollection.doc('${user.uid}cart').get();
      return doc['totalPrice'];
    }
    else
    {
       return 0;
    }
  }

    Future<void> updateCartItems() async {
    setState(() {
      _cartItems = fetchCart();
      total = fetchTotal();
    });
  }

    Future<List<Map<String,dynamic>>> fetchCart() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await cartCollection.doc('${user.uid}cart').get();
        List<dynamic> cartItems = List<dynamic>.from(doc['cartItems']);
        return cartItems.map(
          (cartItem) => {
            'name':cartItem['productName'],
            'id':cartItem['productId'],
            'price':cartItem['price'],
            'quantity':cartItem['quantity'],
            }
          ).toList();
      } catch (e) {
        print('Error fetching favorites: $e');
        return [];
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.items.values.toList();
    final productIds = cart.items.keys.toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Cart'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: ListView.builder(
//               itemCount: cartItems.length,
//               itemBuilder: (context, i) => CartItemWidget(
//                 productId: productIds[i],
//                 name: cartItems[i].name,
//                 price: cartItems[i].price,
//                 quantity: cartItems[i].quantity,
//               ),
//             ),
//           ),
//           Card(
//             margin: const EdgeInsets.all(15),
//             child: Padding(
//               padding: const EdgeInsets.all(8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   const Text(
//                     'Total',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   const Spacer(),
//                   Chip(
//                     label: Text(
//                       '${cart.totalAmount.toString()}/-',
//                       style: const TextStyle(
//                         color: Colors.white,
//                       ),
//                     ),
//                     backgroundColor: Colors.green,
//                   ),
//                   TextButton(
//                     child: const Text('ORDER NOW'),
//                     onPressed: () {

//                     },
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String,dynamic>>>(
              future: _cartItems, 
              builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot)
              {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }
                else if(snapshot.hasError){
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                else if(!snapshot.hasData || snapshot.data!.isEmpty){
                  return const Center(child: Text('No Items in Cart'));
                }
                else{
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => CartItemWidget(
                      productId: snapshot.data![index]['id'], 
                      name: snapshot.data![index]['name'], 
                      price: snapshot.data![index]['price'], 
                      quantity: snapshot.data![index]['quantity'],
                      onCartUpdated: updateCartItems,
                      ),
                    );
                }
              }
            ),
          ),
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                   FutureBuilder<int>(
                    future: total,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Chip(
                          label: Text(
                            'Loading...',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.grey,
                        );
                      } else if (snapshot.hasError) {
                        return const Chip(
                          label: Text(
                            'Error',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.red,
                        );
                      } else {
                        return Chip(
                          label: Text(
                            '${snapshot.data}/-',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: Colors.green,
                        );
                      }
                    },
                  ),
                  TextButton(
                    child: const Text('ORDER NOW'),
                    onPressed: () {

                    },
                  )
                ],
              ),
            ),
          ),
        ],
      )
      );
  }
}

class CartItemWidget extends StatefulWidget {
  final String productId;
  final String name;
  final int price;
  final int quantity;
  final VoidCallback onCartUpdated;

  CartItemWidget({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.onCartUpdated,
  });

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference cartCollection = FirebaseFirestore.instance.collection('carts');
  int _currentQuantity = 0;

  @override
  void initState() {
    _currentQuantity = widget.quantity;
    super.initState();
  }

  void _increaseQuantity() {
    setState(() {
      _currentQuantity++;
       _updateCart();
    });
  }

  void _decreaseQuantity() {
    setState(() {
      if (_currentQuantity > 1) {
        _currentQuantity--;
         _updateCart();
      }
    });
  }

  Future<void> removeQuantity(String productId, int price) async {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot cartSnapshot = await  cartCollection.doc('${user.uid}cart').get();
        if(cartSnapshot.exists)
        {
          List<dynamic> cartItems = cartSnapshot['cartItems'];
          int totalPrice = cartSnapshot['totalPrice'];
          int existingIndex = cartItems.indexWhere((item) => item['productId'] == productId);
          cartItems[existingIndex]['quantity'] -= 1;
          await cartCollection.doc('${user.uid}cart').set({
            'cartItems': cartItems,
            'totalPrice': totalPrice - price,
          });
        }
        widget.onCartUpdated();
      }
  }

    Future<void> addQuantity(String productId, int price) async {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot cartSnapshot = await  cartCollection.doc('${user.uid}cart').get();
        if(cartSnapshot.exists)
        {
          List<dynamic> cartItems = cartSnapshot['cartItems'];
          int totalPrice = cartSnapshot['totalPrice'];
          int existingIndex = cartItems.indexWhere((item) => item['productId'] == productId);
          cartItems[existingIndex]['quantity'] += 1;
          await cartCollection.doc('${user.uid}cart').set({
            'cartItems': cartItems,
            'totalPrice': totalPrice + price,
          });
        }
        widget.onCartUpdated();
      }
  }

  Future<void> deleteItem(String productId, int quantity) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot cartSnapshot = await cartCollection.doc('${user.uid}cart').get();
        List<dynamic> cartItems = cartSnapshot['cartItems'];
        int existingIndex = cartItems.indexWhere((item) => item['productId'] == productId);
          int totalPrice = cartSnapshot['totalPrice'] - quantity * cartItems[existingIndex]['price'];
          cartItems.removeAt(existingIndex);
          await cartCollection.doc('${user.uid}cart').update({
            'cartItems': cartItems,
            'totalPrice': totalPrice,
          });
          widget.onCartUpdated(); 
    }
  }
  

  void _updateCart() {
    final cart = Provider.of<Cart>(context, listen: false);
    cart.updateQuantity(widget.productId, _currentQuantity);
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return Dismissible(
      key: ValueKey(widget.productId),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        //cart.removeItem(widget.productId);
       
        deleteItem(widget.productId, widget.quantity);
         //widget.onCartUpdated();
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetail(
                product: Product(id: widget.productId,name: widget.name,price: widget.price, category: "EMPTY")
              ),
            ),
          );
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              leading: const CircleAvatar(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: CircleAvatar(
                    backgroundImage: const AssetImage('smartphone.jpeg'),
                  ),
                ),
              ),
              title: Text(widget.name),
              subtitle: Text('Total: ${(widget.price * _currentQuantity)}/-'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.remove),
                    iconSize: 15.0,
                    onPressed: () async{
                      if(widget.quantity>1){
                        await removeQuantity(widget.productId,widget.price);
                      }
                      else
                      {
                        await deleteItem(widget.productId,widget.quantity);
                      }
                    },
                  ),
                  Text(
                    '$_currentQuantity',
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    iconSize: 15.0,
                    onPressed: () async{
                      await addQuantity(widget.productId,widget.price);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
