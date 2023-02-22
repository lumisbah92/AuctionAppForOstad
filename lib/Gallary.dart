import 'package:auction_app_for_ostad/Product_Details.dart';
import 'package:auction_app_for_ostad/Profile.dart';
import 'package:auction_app_for_ostad/add_product.dart';
import 'package:auction_app_for_ostad/product.dart';
import 'package:auction_app_for_ostad/update_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Gallary extends StatefulWidget {
  late GoogleSignInAccount userObj;
  Gallary({required this.userObj});

  @override
  State<Gallary> createState() => _GallaryState();
}

class _GallaryState extends State<Gallary> {
  final CollectionReference _reference =
  FirebaseFirestore.instance.collection('products');
  int myIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product Gallary'),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              setState(() {
                myIndex=index;
              });
              if(index==0) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Gallary(userObj: widget.userObj,),
                  ),
                );
              }
              else if(index==1) {

              }
              else if(index==2) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Profile(userObj: widget.userObj),
                  ),
                );
              }
            },
            currentIndex: myIndex,
            backgroundColor: Color(0xADAFABA9),
            items: const[
              BottomNavigationBarItem(
                icon: Icon(Icons.image),
                label: 'Gallary',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.perm_identity),
                label: 'My Posted Item',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'profile',
              ),
            ]
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
                  builder: (context) => AddProduct(userObj: widget.userObj,),
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
        : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 11,
        mainAxisSpacing: 11,
    ), itemBuilder: (context, index){
          return Container(
            child: InkWell(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Product_Details(products[index].name, products[index].price,),
                  ),
                );
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0, top: 2, bottom: 0),
                    child: CircleAvatar(
                        radius: 27,
                        backgroundColor: Color(0xADAD907E),
                        child: Container(

                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 0, top: 0, bottom: 0),
                    child: ListTile(
                      title: Text(products[index].name),
                      subtitle: Text("\$ ${products[index].price}"),
                      /*trailing: SizedBox(
                  width: 250,
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
                ),*/
                    ),
                  )
                ],
              ),
            )
          );
    }, itemCount: products.length);
  }
}
