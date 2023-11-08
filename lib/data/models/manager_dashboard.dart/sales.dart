// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SalesData {
  String? uid;
  final DateTime date;
  final num sales;
  final String category;
  String? customerid;
  String? cooperativeId;
  String? ownerId;
  String? listingId;
  SalesData({
    this.uid,
    required this.date,
    required this.sales,
    required this.category,
    this.customerid,
    this.cooperativeId,
    this.ownerId,
    this.listingId,
  });


  SalesData copyWith({
    String? uid,
    DateTime? date,
    num? sales,
    String? category,
    String? customerid,
    String? cooperativeId,
    String? ownerId,
    String? listingId,
  }) {
    return SalesData(
      uid: uid ?? this.uid,
      date: date ?? this.date,
      sales: sales ?? this.sales,
      category: category ?? this.category,
      customerid: customerid ?? this.customerid,
      cooperativeId: cooperativeId ?? this.cooperativeId,
      ownerId: ownerId ?? this.ownerId,
      listingId: listingId ?? this.listingId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'date': date.millisecondsSinceEpoch,
      'sales': sales,
      'category': category,
      'customerid': customerid,
      'cooperativeId': cooperativeId,
      'ownerId': ownerId,
      'listingId': listingId,
    };
  }

  factory SalesData.fromMap(String uid, Map<String, dynamic> map) {
    return SalesData(
      uid: uid,
      date: (map['date'] as Timestamp).toDate(),
      sales: map['sales'] as num,
      category: map['category'] as String,
      customerid: map['customerid'] != null ? map['customerid'] as String : null,
      cooperativeId: map['cooperativeId'] != null ? map['cooperativeId'] as String : null,
      ownerId: map['ownerId'] != null ? map['ownerId'] as String : null,
      listingId: map['listingId'] != null ? map['listingId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SalesData.fromJson(String source) => SalesData.fromMap('', json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SalesData(uid: $uid, date: $date, sales: $sales, category: $category, customerid: $customerid, cooperativeId: $cooperativeId, ownerId: $ownerId, listingId: $listingId)';
  }

  @override
  bool operator ==(covariant SalesData other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.date == date &&
      other.sales == sales &&
      other.category == category &&
      other.customerid == customerid &&
      other.cooperativeId == cooperativeId &&
      other.ownerId == ownerId &&
      other.listingId == listingId;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      date.hashCode ^
      sales.hashCode ^
      category.hashCode ^
      customerid.hashCode ^
      cooperativeId.hashCode ^
      ownerId.hashCode ^
      listingId.hashCode;
  }
}
