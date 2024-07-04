import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  late Future<List<String>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = fetchFavorites();
  }

  Future<List<String>> fetchFavorites() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await userCollection.doc(user.uid).get();
        List<String> favorites = List<String>.from(doc['favorites']);
        return favorites;
      } catch (e) {
        print('Error fetching favorites: $e');
        return [];
      }
    }
    return [];
  }

  Future<void> removeFromFavorites(String productId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await userCollection.doc(user.uid).update({
          'favorites': FieldValue.arrayRemove([productId])
        });
        setState(() {
          _favoritesFuture = fetchFavorites();
        });
      } catch (e) {
        print('Error removing from favorites: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAVOURITES'),
      ),
      body: FutureBuilder<List<String>>(
        future: _favoritesFuture,
        builder: (context, AsyncSnapshot<List<String>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          } else if(snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if(!snapshot.hasData || snapshot.data!.isEmpty){
            return Center(child: Text('No favourites found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          removeFromFavorites(snapshot.data![index]);
                        }, 
                        icon: Icon(Icons.remove_circle_outline_outlined)
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
