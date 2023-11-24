import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SalesData {
  String? uid;
  final Timestamp date;
  Timestamp? startDate;
  Timestamp? endDate;
  Timestamp? dateSelected;
  String? timeSelected;
  num? numberOfGuests;
  final num sales;
  final String category;
  String? type;
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
    this.dateSelected,
    this.timeSelected,
    this.numberOfGuests,
    required this.sales,
    required this.category,
    this.type,
    this.customerid,
    this.cooperativeId,
    this.ownerId,
    this.listingId,
    this.listingName,
  });

  SalesData copyWith({
    String? uid,
    Timestamp? date,
    Timestamp? startDate,
    Timestamp? endDate,
    Timestamp? dateSelected,
    String? timeSelected,
    num? numberOfGuests,
    num? sales,
    String? category,
    String? type,
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
      dateSelected: dateSelected ?? this.dateSelected,
      timeSelected: timeSelected ?? this.timeSelected,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      sales: sales ?? this.sales,
      category: category ?? this.category,
      type: type ?? this.type,
      customerid: customerid ?? this.customerid,
      cooperativeId: cooperativeId ?? this.cooperativeId,
      ownerId: ownerId ?? this.ownerId,
      listingId: listingId ?? this.listingId,
      listingName: listingName ?? this.listingName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'date': date,
      'startDate': startDate,
      'endDate': endDate,
      'dateSelected': dateSelected,
      'timeSelected': timeSelected,
      'pax': numberOfGuests,
      'sales': sales,
      'category': category,
      'type': type,
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
      date: map['date'] as Timestamp,
      startDate: map['startDate'] as Timestamp?,
      endDate: map['endDate'] as Timestamp?,
      dateSelected: map['dateSelected'] as Timestamp?,
      timeSelected: map['timeSelected'] as String?,
      numberOfGuests: map['numberOfGuests'] as num?,
      sales: map['sales'] as num,
      category: map['category'] as String,
      type: map['type'] as String?,
      customerid: map['customerid'] as String?,
      cooperativeId: map['cooperativeId'] as String?,
      ownerId: map['ownerId'] as String?,
      listingId: map['listingId'] as String?,
      listingName: map['listingName'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory SalesData.fromJson(String source) =>
      SalesData.fromMap('', json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SalesData(uid: $uid, date: $date, startDate: $startDate, endDate: $endDate, dateSelected: $dateSelected, timeSelected: $timeSelected, numberOfGuests: $numberOfGuests, sales: $sales, category: $category, type: $type, customerid: $customerid, cooperativeId: $cooperativeId, ownerId: $ownerId, listingId: $listingId, listingName: $listingName)';
  }
}
