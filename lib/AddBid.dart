import 'dart:developer';

import 'package:auction_app_for_ostad/Product_Details.dart';
import 'package:auction_app_for_ostad/bid_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBid extends StatefulWidget {
  String productName;
  double productPrice;
  AddBid(this.productName, this.productPrice);
  @override
  State<AddBid> createState() => _AddBidState();
}

class _AddBidState extends State<AddBid> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bid'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            getMyField(hintText: 'User Name', textInputType: TextInputType.text, controller: nameController),
            getMyField(hintText: 'Bid Price', textInputType: TextInputType.number, controller: priceController),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      //
                      bidItem bid_item = bidItem(
                        userName: nameController.text,
                        bidPrice: double.parse(priceController.text),
                      );
                      // ToDO: Adding a Bid
                      addBidAndNavigateToHome(bid_item, context);
                      //
                    },
                    child: const Text('Add')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                    onPressed: () {
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

  void addBidAndNavigateToHome(bidItem bid_item, BuildContext context ) {
    //
    // Reference to firebase
    final bidRef = FirebaseFirestore.instance.collection('Bids').doc();
    bid_item.id = bidRef.id;
    final data = bid_item.toJson();
    bidRef.set(data).whenComplete(() {
      //
      log('Bid inserted.');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Product_Details(widget.productName, widget.productPrice),
        ),
            (route) => false,
      );
      //
    });

    //
  }
}
