import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class BuyersList extends StatefulWidget {
  @override
  _BuyersListState createState() => _BuyersListState();
}

class _BuyersListState extends State<BuyersList> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('buyers').snapshots();

  Widget vendorData(Widget widget, int? flex) {
    return Expanded(
      flex: flex!,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: LinearProgressIndicator());
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          // Only change the itemBuilder part in BuyersList.dart
          itemBuilder: ((context, index) {
            final buyerData = snapshot.data!.docs[index];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                vendorData(
                    Container(
                      height: 50,
                      width: 50,
                      child: buyerData['profileImage'] != null
                          ? Image.network(
                        buyerData['profileImage'],
                        width: 50,
                        height: 50,
                      )
                          : Icon(Icons.person), // Fallback if no image
                    ),
                    1),
                vendorData(
                    Text(
                      buyerData['fullName'] ?? 'No Name', // Changed from firstName to fullName
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    3),
                vendorData(
                    Text(
                      buyerData['email'] ?? 'No Email',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    2),
                vendorData(
                    Text(
                      buyerData['address'] ?? 'No Address', // Changed from placeName to address
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    2),
                vendorData(
                    ElevatedButton(
                        onPressed: () async {},
                        child: Text(
                          'Reject',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold
                          ),
                        )),
                    1),
                vendorData(
                    ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'View More',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                    1),
              ],
            );
          }),
        );
      },
    );
  }
}
