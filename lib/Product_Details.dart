import 'package:auction_app_for_ostad/bid_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'AddBid.dart';

class Product_Details extends StatefulWidget {
  String productName;
  double productPrice;
  Product_Details(this.productName, this.productPrice);

  @override
  State<Product_Details> createState() => _Product_DetailsState();
}

class _Product_DetailsState extends State<Product_Details> {
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('Bids');

  bool sort = true;
  List<bidItem>? filterData;

  onsortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        filterData!.sort((a, b) => a.bidPrice!.compareTo(b.bidPrice!));
      } else {
        filterData!.sort((a, b) => b.bidPrice!.compareTo(a.bidPrice!));
      }
    }
  }

  @override
  void initState() {
    //filterData = myData;
    super.initState();
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            List<bidItem> myData = documents
                .map((e) => bidItem(
                    id: e['id'],
                    userName: e['name'],
                    bidPrice: e['price']))
                .toList();
            return _getBody(myData);
          } else {
            // Show Loading
            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 0, right: 0, top: 50, bottom: 0),
                    child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xADAD907E),
                        child: Container()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 170.0, right: 0, top: 0, bottom: 0),
                    child: ListTile(
                      title: Text(widget.productName),
                      subtitle: Text("\$ ${widget.productPrice}"),
                    ),
                  ),
                ],
              ),
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
                  builder: (context) => AddBid(widget.productName, widget.productPrice),
                ));
            //
          }),
          child: const Icon(Icons.add),
        )
    );
  }

  Widget _getBody(myData) {
    return myData.isEmpty
        ?  Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0, right: 0, top: 50, bottom: 0),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xADAD907E),
                      child: Container()),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 170.0, right: 0, top: 0, bottom: 0),
                  child: ListTile(
                    title: Text(widget.productName),
                    subtitle: Text("\$ ${widget.productPrice}"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(100.0),
                  child: Center(
                    child: Text(
                      'No bid Yet\nClick + to start adding',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          )
        : Center(
      child: Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.only(left: 0, right: 0, top: 50, bottom: 0),
            child: CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xADAD907E),
                child: Container()),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 170.0, right: 0, top: 0, bottom: 0),
            child: ListTile(
              title: Text(widget.productName),
              subtitle: Text("\$ ${widget.productPrice}"),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Theme(
                  data: ThemeData.light()
                      .copyWith(cardColor: Theme.of(context).canvasColor),
                  child: PaginatedDataTable(
                    sortColumnIndex: 0,
                    sortAscending: sort,
                    source: RowSource(
                      myData: myData,
                      count: myData.length,
                    ),
                    rowsPerPage: 7,
                    columnSpacing: 200,
                    columns: [
                      DataColumn(
                        label: const Text(
                          "User Name",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                      DataColumn(
                        label: const Text(
                          "Bid Price",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            sort = !sort;
                          });

                          onsortColum(columnIndex, ascending);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RowSource extends DataTableSource {
  var myData;
  final count;
  RowSource({
    required this.myData,
    required this.count,
  });

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(myData![index]);
    } else
      return null;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}

DataRow recentFileDataRow(var data) {
  return DataRow(
    cells: [
      DataCell(Text(data.userName ?? "userName")),
      DataCell(Text(data.bidPrice.toString())),
    ],
  );
}
