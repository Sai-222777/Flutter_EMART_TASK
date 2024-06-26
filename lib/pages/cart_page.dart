import 'package:emart/cart.dart';
import 'package:emart/pages/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.items.values.toList();
    final productIds = cart.items.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, i) => CartItemWidget(
                productId: productIds[i],
                name: cartItems[i].name,
                price: cartItems[i].price,
                quantity: cartItems[i].quantity,
              ),
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
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toString()}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.green,
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
      ),
    );
  }
}

class CartItemWidget extends StatefulWidget {
  final String productId;
  final String name;
  final int price;
  final int quantity;

  CartItemWidget({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
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
      onDismissed: (direction) {
        cart.removeItem(widget.productId);
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
                product: {
                  'id': widget.productId,
                  'name': widget.name,
                  'price': widget.price
                },
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
                    onPressed: _decreaseQuantity,
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
                    onPressed: _increaseQuantity,
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
