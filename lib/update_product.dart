import 'dart:developer';

import 'package:auction_app_for_ostad/Gallary.dart';
import 'package:auction_app_for_ostad/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UpdateProduct extends StatelessWidget {
  final Product product;
  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final FocusNode focusNode = FocusNode();

  late GoogleSignInAccount userObj;

  UpdateProduct({super.key, required this.product, required this.userObj});

  @override
  Widget build(BuildContext context) {
    descriptionController.text = '${product.description}';
    nameController.text = product.name;
    priceController.text = '${product.price}';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Price'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            getMyField(hintText: 'Description', textInputType: TextInputType.text, controller: descriptionController),
            getMyField(hintText: 'Name', textInputType: TextInputType.text, controller: nameController),
            getMyField(hintText: 'Price', textInputType: TextInputType.number, controller: priceController),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      //
                      // ToDO: Update a product
                      Product updatedProduct = Product(
                        id: product.id,
                        description: descriptionController.text,
                        name: nameController.text,
                        price: double.parse(priceController.text),
                      );
                      //
                      final collectionReference =
                          FirebaseFirestore.instance.collection('products');
                      collectionReference
                          .doc(updatedProduct.id)
                          .update(updatedProduct.toJson())
                          .whenComplete(() {
                        log('Product Updated');
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Gallary(userObj: userObj,),
                            ));
                      });
                      //
                    },
                    child: const Text('Update')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                    onPressed: () {
                      //
                      descriptionController.text = '';
                      nameController.text = '';
                      priceController.text = '';
                      focusNode.requestFocus();
                      //
                    },
                    child: const Text('Reset')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getMyField(
      {required String hintText,
      TextInputType textInputType = TextInputType.name,
      required TextEditingController controller,
      FocusNode? focusNode}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        keyboardType: textInputType,
        decoration: InputDecoration(
            hintText: 'Enter $hintText',
            labelText: hintText,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)))),
      ),
    );
  }
}
