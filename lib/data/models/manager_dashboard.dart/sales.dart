// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SalesData {
  String? uid;
  final DateTime date;
  DateTime? startDate;
  DateTime? endDate;
  num? numberOfGuests;
  final num sales;
  final String category;
  String? customerid;
  String? cooperativeId;
  String? ownerId;
  String? listingId;
  String? listingName;
  SalesData({
    this.uid,
    required this.date,
    this.startDate,
    this.endDate,
    this.numberOfGuests,
    required this.sales,
    required this.category,
    this.customerid,
    this.cooperativeId,
    this.ownerId,
    this.listingId,
    this.listingName,
  });


  SalesData copyWith({
    String? uid,
    DateTime? date,
    DateTime? startDate,
    DateTime? endDate,
    num? numberOfGuests,
    num? sales,
    String? category,
    String? customerid,
    String? cooperativeId,
    String? ownerId,
    String? listingId,
    String? listingName,
  }) {
    return SalesData(
      uid: uid ?? this.uid,
      date: date ?? this.date,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      sales: sales ?? this.sales,
      category: category ?? this.category,
      customerid: customerid ?? this.customerid,
      cooperativeId: cooperativeId ?? this.cooperativeId,
      ownerId: ownerId ?? this.ownerId,
      listingId: listingId ?? this.listingId,
      listingName: listingName ?? this.listingName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'date': date.millisecondsSinceEpoch,
      'sales': sales,
      'numberOfGuests': numberOfGuests,
      'category': category,
      'customerid': customerid,
      'cooperativeId': cooperativeId,
      'ownerId': ownerId,
      'listingId': listingId,
      'listingName': listingName,
    };
  }

  factory SalesData.fromMap(String uid, Map<String, dynamic> map) {
    return SalesData(
      uid: uid,
      date: (map['date'] as Timestamp).toDate(),
      startDate: (map['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (map['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      numberOfGuests: map['numberOfGuests'] != null ? map['numberOfGuests']as num : null,
      sales: map['sales'] as num,
      category: map['category'] as String,
      customerid: map['customerid'] != null ? map['customerid'] as String : null,
      cooperativeId: map['cooperativeId'] != null ? map['cooperativeId'] as String : null,
      ownerId: map['ownerId'] != null ? map['ownerId'] as String : null,
      listingId: map['listingId'] != null ? map['listingId'] as String : null,
      listingName: map['listingName'] != null ? map['listingName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SalesData.fromJson(String source) => SalesData.fromMap('', json.decode(source) as Map<String, dynamic>);



  @override
  String toString() {
    return 'SalesData(uid: $uid, date: $date, startDate: $startDate, endDate: $endDate, numberOfGuests : $numberOfGuests, sales: $sales, category: $category, customerid: $customerid, cooperativeId: $cooperativeId, ownerId: $ownerId, listingId: $listingId, listingName: $listingName)';
  }
}
