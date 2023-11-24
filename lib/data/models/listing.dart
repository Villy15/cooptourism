// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListingModel {
  String? id;
  String? owner;
  String? title;
  String? description;
  String? cooperativeOwned;
  String? city;
  String? province;
  String? category;
  num? rating;
  Map<String, dynamic>? roles;
  List<dynamic>? tasks;
  num? price;
  String? type;
  Timestamp? postDate;
  List<dynamic>? images;
  num? pax;
  String? ownerMember;
  bool? isPublished;

  List<AvailableDateModel>? availableDates;

  ListingModel({
    this.id,
    this.owner,
    this.title,
    this.description,
    this.cooperativeOwned,
    this.city,
    this.province,
    this.category,
    this.rating,
    this.roles,
    this.tasks,
    this.price,
    this.type,
    this.postDate,
    this.images,
    this.pax,
    this.ownerMember,
    this.isPublished,
    this.availableDates,
  });

  ListingModel copyWith({
    String? id,
    String? owner,
    String? title,
    String? description,
    String? cooperativeOwned,
    String? city,
    String? province,
    String? category,
    num? rating,
    Map<String, dynamic>? roles,
    List<dynamic>? tasks,
    num? price,
    String? type,
    Timestamp? postDate,
    List<dynamic>? images,
    num? pax,
    bool? isPublished,
    List<AvailableDateModel>? availableDates,
    List<AvailableTimeModel>? availableTimes,
  }) {
    return ListingModel(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      title: title ?? this.title,
      description: description ?? this.description,
      cooperativeOwned: cooperativeOwned ?? this.cooperativeOwned,
      city: city ?? this.city,
      province: province ?? this.province,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      roles: roles ?? this.roles,
      tasks: tasks ?? this.tasks,
      price: price ?? this.price,
      type: type ?? this.type,
      postDate: postDate ?? this.postDate,
      images: images ?? this.images,
      pax: pax ?? this.pax,
      isPublished: isPublished ?? this.isPublished,
      availableDates: availableDates ?? this.availableDates,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'owner': owner,
      'title': title,
      'description': description,
      'cooperativeOwned': cooperativeOwned,
      'city': city,
      'province': province,
      'category': category,
      'rating': rating,
      'roles': roles,
      'tasks': tasks?.map((x) => x.toMap()).toList(),
      'price': price,
      'type': type,
      'postDate': postDate?.toDate(),
      'images': images,
      'pax': pax,
      'isPublished': isPublished,
      'availableDates': availableDates,
    };
  }

  factory ListingModel.fromMap(String id, Map<String, dynamic> map) {
    return ListingModel(
      id: id,
      owner: map['owner'] as String?,
      title: map['title'] as String?,
      description: map['description'] as String?,
      cooperativeOwned: map['cooperativeOwned'] as String?,
      city: map['city'] as String?,
      province: map['province'] as String?,
      category: map['category'] as String?,
      rating: map['rating'] as num?,
      roles: map['roles'] as Map<String, dynamic>?,
      tasks: List<dynamic>.from(map['tasks'] ?? const []),
      price: map['price'] as num?,
      type: map['type'] as String?,
      postDate: map['postDate'] as Timestamp?,
      images: List<dynamic>.from(map['images'] ?? const []),
      pax: map['pax'] as num?,
      isPublished: map['isPublished'] as bool?,
      availableDates: map['availableDates'] != null
          ? List<AvailableDateModel>.from(
              (map['availableDates'] as List).map(
                (item) =>
                    AvailableDateModel.fromMap(item as Map<String, dynamic>),
              ),
            )
          : null,
      // availableDates: map['availableDates'] != null
      //     ? List<AvailableDateModel>.from(map['availableDates'])
      //         as List<AvailableDateModel>?
      //     : [],
    );
  }

  @override
  String toString() {
    return 'ListingModel(id: $id, owner: $owner, title: $title, description: $description, cooperativeOwned: $cooperativeOwned, city: $city, province: $province, category: $category, rating: $rating, roles: $roles, tasks: $tasks, price: $price, type: $type, postDate: $postDate, images: $images, pax: $pax, isPublished: $isPublished, availableDates: $availableDates)';
  }
}

class AvailableDateModel {
  Timestamp? date;
  bool? available;
  List<AvailableTimeModel>? availableTimes;

  AvailableDateModel({this.date, this.available, this.availableTimes});

  Map<String, dynamic> toMap() {
    return {
      'date': date?.toDate(),
      'available': available,
      'availableTimes': availableTimes?.map((x) => x.toMap()).toList(),
    };
  }

  factory AvailableDateModel.fromMap(Map<String, dynamic> map) {
    return AvailableDateModel(
      date: map['date'] as Timestamp?,
      available: map['available'] as bool?,
      availableTimes: map['availableTimes'] != null
          ? List<AvailableTimeModel>.from(
              (map['availableTimes'] as List).map(
                (x) => AvailableTimeModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AvailableDateModel.fromJson(String source) =>
      AvailableDateModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AvailableTimeModel {
  String? time;
  num? maxPax;
  num? currentPax;
  bool? available;

  AvailableTimeModel({
    this.time,
    this.maxPax,
    this.currentPax,
    this.available,
  });

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'maxPax': maxPax,
      'currentPax': currentPax,
      'available': available,
    };
  }

  factory AvailableTimeModel.fromMap(Map<String, dynamic> map) {
    return AvailableTimeModel(
      time: map['time'] as String?,
      maxPax: map['maxPax'] as num?,
      currentPax: map['currentPax'] as num?,
      available: map['available'] as bool?,
    );
  }

  String toJson() => json.encode(toMap());

  factory AvailableTimeModel.fromJson(String source) =>
      AvailableTimeModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
