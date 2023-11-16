import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cooptourism/data/models/manager_dashboard.dart/sales.dart';
import 'package:flutter/material.dart';

class SalesRepository {
  final CollectionReference salesCollection =
      FirebaseFirestore.instance.collection('sales');

  // get all sales from Firestore
  Stream<List<SalesData>> getAllSales() {
    return salesCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return SalesData.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Get all sales by ownerId
  Stream<List<SalesData>> getAllSalesByOwnerId(String ownerId) {
    return salesCollection
        .where('ownerId', isEqualTo: ownerId)
        // .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return SalesData.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Get all sales by customerId
  Stream<List<SalesData>> getAllSalesByCustomerId(String customerId) {
    return salesCollection
        .where('customerid', isEqualTo: customerId)
        // .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return SalesData.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Delete all
  Future<void> deleteAllSales() async {
    final batch = FirebaseFirestore.instance.batch();
    final querySnapshot = await salesCollection.get();
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    return batch.commit();
  }



  // Add manually a sale to Firestore
  Future<void> addSaleManually() async {
    List<Map<String, dynamic>> sales = [
      {
        'date': DateTime(2023, 11, 6, 17, 30),
        'sales': 4200,
        'category': 'Accomodation',
        'customerid': 'Q5XDgYklDNU02Wc4cGp4n3Kv8cH3',
        'cooperativeId': 'sslvO5tgDoCHGBO82kxq',
        'ownerId': 'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
        'listingId': 'fQv3jlai7aETmy8Q0E3S',
        'listingName': 'ツ The Darwin Delight ツ'
      },
      {
        'date': DateTime(2023, 11, 5, 17, 30),
        'sales': 4200,
        'category': 'Accomodation',
        'customerid': 'Q5XDgYklDNU02Wc4cGp4n3Kv8cH3',
        'cooperativeId': 'sslvO5tgDoCHGBO82kxq',
        'ownerId': 'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
        'listingId': 'jBg8MlxWLllJPSu8r00o',
        'listingName': 'Hotel Iwahori'
      },
      {
        'date': DateTime(2023, 11, 6, 10, 30),
        'sales': 4200,
        'category': 'Accomodation',
        'customerid': 'Q5XDgYklDNU02Wc4cGp4n3Kv8cH3',
        'cooperativeId': 'sslvO5tgDoCHGBO82kxq',
        'ownerId': 'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
        'listingId': 'tt3CBIByj5TJIShyZ8id',
        'listingName': 'Hotel Magenta'
      },
      {
        'date': DateTime(2023, 11, 4, 18, 40),
        'sales': 1200,
        'category': 'Transportation',
        'customerid': 'customerid',
        'cooperativeId': 'cooperativeId',
        'ownerId': 'ownerId',
        'listingId': 'listingId', 

      },
      {
        'date': DateTime(2023, 11, 5, 12, 30),
        'sales': 2200,
        'category': 'Food Service',
        'customerid': 'customerid',
        'cooperativeId': 'cooperativeId',
        'ownerId': 'ownerId',
        'listingId': 'listingId',
      },
      {
        'date': DateTime(2023, 11, 5, 12, 30),
        'sales': 7200,
        'category': 'Entertainment',
        'customerid': 'customerid',
        'cooperativeId': 'cooperativeId',
        'ownerId': 'ownerId',
        'listingId': 'listingId',
      },
      {
        'date': DateTime(2023, 11, 5, 18, 30),
        'sales': 4000,
        'category': 'Touring',
        'customerid': 'customerid',
        'cooperativeId': 'cooperativeId',
        'ownerId': 'ownerId',
        'listingId': 'listingId',
      },
      {
        'date': DateTime(2023, 11, 6, 21, 30),
        'sales': 5200,
        'category': 'Touring',
        'customerid': 'customerid',
        'cooperativeId': 'cooperativeId',
        'ownerId': 'ownerId',
        'listingId': 'listingId',
      },
      {
        'date': DateTime(2023, 11, 7, 17, 30),
        'sales': 4200,
        'category': 'Accomodation',
        'customerid': 'Q5XDgYklDNU02Wc4cGp4n3Kv8cH3',
        'cooperativeId': 'sslvO5tgDoCHGBO82kxq',
        'ownerId': 'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
        'listingId': 'fQv3jlai7aETmy8Q0E3S',
        'listingName': 'ツ The Darwin Delight ツ'
      },
      {
        'date': DateTime(2023, 11, 7, 12, 30),
        'sales': 8200,
        'category': 'Accomodation',
        'customerid': 'Q5XDgYklDNU02Wc4cGp4n3Kv8cH3',
        'cooperativeId': 'sslvO5tgDoCHGBO82kxq',
        'ownerId': 'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
        'listingId': 'jBg8MlxWLllJPSu8r00o',
        'listingName': 'Hotel Iwahori'
      },
      {
        'date': DateTime(2023, 11, 8, 10, 30),
        'sales': 8200,
        'category': 'Accomodation',
        'customerid': 'Q5XDgYklDNU02Wc4cGp4n3Kv8cH3',
        'cooperativeId': 'sslvO5tgDoCHGBO82kxq',
        'ownerId': 'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
        'listingId': 'tt3CBIByj5TJIShyZ8id',
        'listingName': 'Hotel Magenta'
      },
      {
        'date': DateTime(2023, 11, 4, 18, 40),
        'sales': 1200,
        'category': 'Transportation',
      },
      {
        'date': DateTime(2023, 11, 5, 12, 30),
        'sales': 2200,
        'category': 'Food Service',
      },
      {
        'date': DateTime(2023, 11, 5, 12, 30),
        'sales': 7200,
        'category': 'Entertainment',
      },
      {
        'date': DateTime(2023, 11, 5, 18, 30),
        'sales': 4000,
        'category': 'Touring',
      },
      {
        'date': DateTime(2023, 11, 6, 21, 30),
        'sales': 5200,
        'category': 'Touring',
      },
      {
        'date': DateTime(2023, 11, 7, 18, 30),
        'sales': 1400,
        'category': 'Accomodation',
        'customerid': 'Q5XDgYklDNU02Wc4cGp4n3Kv8cH3',
        'cooperativeId': 'sslvO5tgDoCHGBO82kxq',
        'ownerId': 'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
        'listingId': 'fQv3jlai7aETmy8Q0E3S',
        'listingName': 'ツ The Darwin Delight ツ'
      },
      {
        'date': DateTime(2023, 11, 9, 17, 30),
        'sales': 4200,
        'category': 'Accomodation',
        'customerid': 'Q5XDgYklDNU02Wc4cGp4n3Kv8cH3',
        'cooperativeId': 'sslvO5tgDoCHGBO82kxq',
        'ownerId': 'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
        'listingId': 'jBg8MlxWLllJPSu8r00o',
        'listingName': 'Hotel Iwahori'
      },
      {
        'date': DateTime(2023, 11, 10, 10, 30),
        'sales': 4200,
        'category': 'Accomodation',
        'customerid': 'Q5XDgYklDNU02Wc4cGp4n3Kv8cH3',
        'cooperativeId': 'sslvO5tgDoCHGBO82kxq',
        'ownerId': 'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
        'listingId': 'tt3CBIByj5TJIShyZ8id',
        'listingName': 'Hotel Magenta'
      },
      {
        'date': DateTime(2023, 11, 5, 19, 40),
        'sales': 2400,
        'category': 'Transportation',
      },
      {
        'date': DateTime(2023, 11, 6, 13, 30),
        'sales': 7400,
        'category': 'Food Service',
      },
      {
        'date': DateTime(2023, 11, 7, 13, 30),
        'sales': 4400,
        'category': 'Entertainment',
      },
      {
        'date': DateTime(2023, 11, 7, 19, 30),
        'sales': 5000,
        'category': 'Touring',
      },
      {
        'date': DateTime(2023, 11, 8, 22, 30),
        'sales': 2320,
        'category': 'Touring',
      },
      {
        'date': DateTime(2023, 11, 8, 19, 30),
        'sales': 5600,
        'category': 'Accomodation',
        'customerid': 'Q5XDgYklDNU02Wc4cGp4n3Kv8cH3',
        'cooperativeId': 'sslvO5tgDoCHGBO82kxq',
        'ownerId': 'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
        'listingId': 'fQv3jlai7aETmy8Q0E3S',
        'listingName': 'ツ The Darwin Delight ツ'
      },
      {
        'date': DateTime(2023, 11, 11, 17, 30),
        'sales': 4200,
        'category': 'Accomodation',
        'customerid': 'Q5XDgYklDNU02Wc4cGp4n3Kv8cH3',
        'cooperativeId': 'sslvO5tgDoCHGBO82kxq',
        'ownerId': 'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
        'listingId': 'jBg8MlxWLllJPSu8r00o',
        'listingName': 'Hotel Iwahori'
      },
      {
        'date': DateTime(2023, 11, 12, 10, 30),
        'sales': 4200,
        'category': 'Accomodation',
        'customerid': 'Q5XDgYklDNU02Wc4cGp4n3Kv8cH3',
        'cooperativeId': 'sslvO5tgDoCHGBO82kxq',
        'ownerId': 'ewBh7JJqkpe0XwYRMiAsRwuw0in1',
        'listingId': 'tt3CBIByj5TJIShyZ8id',
        'listingName': 'Hotel Magenta'
      },
      {
        'date': DateTime(2023, 11, 6, 20, 40),
        'sales': 2600,
        'category': 'Transportation',
      },
      {
        'date': DateTime(2023, 11, 4, 14, 30),
        'sales': 7600,
        'category': 'Food Service',
      },
      {
        'date': DateTime(2023, 11, 8, 14, 30),
        'sales': 2600,
        'category': 'Entertainment',
      },
      {
        'date': DateTime(2023, 11, 8, 20, 30),
        'sales': 10000,
        'category': 'Touring',
      },
      {
        'date': DateTime(2023, 11, 8, 23, 30),
        'sales': 2900,
        'category': 'Touring',
      },
    ];

    for (var sale in sales) {
      try {
        await salesCollection.add(sale);
      } catch (e) {
        debugPrint('Error adding sale to Firestore: $e');
        // You might want to handle errors more gracefully here
      }
    }
  }
}