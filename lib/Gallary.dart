import 'package:auction_app_for_ostad/add_product.dart';
import 'package:auction_app_for_ostad/product.dart';
import 'package:auction_app_for_ostad/update_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Gallary extends StatelessWidget {
  final CollectionReference _reference =
  FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product Gallary'),
          centerTitle: true,
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: _reference.get(),
          builder: (context, snapshot) {
            // Check for error
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
            // if data received
            if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data!;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;
              // Convert data to List
              List<Product> products = documents
                  .map((e) => Product(
                  id: e['id'],
                  description: e['description'],
                  name: e['name'],
                  price: e['price']))
                  .toList();
              return _getBody(products);
            } else {
              // Show Loading
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          // child: _getBody()
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (() {
            //
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddProduct(),
                ));
            //
          }),
          child: const Icon(Icons.add),
        ));
  }

  Widget _getBody(products) {
    return products.isEmpty
        ? const Center(
      child: Text(
        'No Product Yet\nClick + to start adding',
        textAlign: TextAlign.center,
      ),
    )
        : ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) => Card(
        color: products[index].price < 33
            ? Colors.red.shade100
            : products[index].price < 65
            ? Colors.yellow.shade100
            : Colors.green.shade100,
        child: ListTile(
          title: Text(products[index].name),
          subtitle: Text('Description: ${products[index].description}'),
          leading: CircleAvatar(
            radius: 25,
            child: Text('${products[index].price}'),
          ),
          trailing: SizedBox(
            width: 60,
            child: Row(
              children: [
                InkWell(
                  child: Icon(
                    Icons.edit,
                    color: Colors.black.withOpacity(0.75),
                  ),
                  onTap: () {
                    //
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UpdateProduct(product: products[index]),
                        ));
                    //
                  },
                ),
                InkWell(
                  child: const Icon(Icons.delete),
                  onTap: () {
                    //
                    _reference.doc(products[index].id).delete();
                    // To refresh
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Gallary(),
                        ));

                    //
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
