import 'dart:developer';

import 'package:auction_app_for_ostad/Gallary.dart';
import 'package:auction_app_for_ostad/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
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
                      Product product = Product(
                        description: descriptionController.text,
                        name: nameController.text,
                        price: double.parse(priceController.text),
                      );
                      // ToDO: Adding a Product
                      addProductAndNavigateToHome(product, context);
                      //
                    },
                    child: const Text('Add')),
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

  void addProductAndNavigateToHome(Product product, BuildContext context) {
    //
    // Reference to firebase
    final productRef = FirebaseFirestore.instance.collection('products').doc();
    product.id = productRef.id;
    final data = product.toJson();
    productRef.set(data).whenComplete(() {
      //
      log('User inserted.');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Gallary(),
        ),
        (route) => false,
      );
      //
    });

    //
  }
}
