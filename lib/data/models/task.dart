import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// Dart Data Class Generator
class TaskModel {
  String? uid;
  String title;
  String description;
  num progress;
  List<ToDoItem> toDoList;
  String? type;
  String? referenceId;
  String? assignedMember;
  bool? isManagerApproved;

  TaskModel({
    this.uid,
    required this.title,
    required this.description,
    required this.progress,
    required this.toDoList,
    this.type,
    this.referenceId,
    this.assignedMember,
    this.isManagerApproved,
  });

  TaskModel copyWith({
    String? uid,
    String? title,
    String? description,
    double? progress,
    List<ToDoItem>? toDoList,
    String? type,
    String? referenceId,
    String? assignedMember,
    bool? isManagerApproved,
  }) {
    return TaskModel(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      progress: progress ?? this.progress,
      toDoList: toDoList ?? this.toDoList,
      type: type ?? this.type,
      referenceId: referenceId ?? this.referenceId,
      assignedMember: assignedMember ?? this.assignedMember,
      isManagerApproved: isManagerApproved ?? this.isManagerApproved,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'uid': uid,
      'title': title,
      'description': description,
      'progress': progress,
      'toDoList': toDoList.map((x) => x.toMap()).toList(),
      'type': type,
      'referenceId': referenceId,
      'assignedMember': assignedMember,
      'isManagerApproved': isManagerApproved,
    };
  }

  factory TaskModel.fromMap(String id, Map<String, dynamic> map) {
    return TaskModel(
      uid: id,
      title: map['title'] as String,
      description: map['description'] as String,
      progress: map['progress'] as num,
      toDoList: List<ToDoItem>.from(
          map['toDoList']?.map((x) => ToDoItem.fromMap('', x)) as Iterable),
      type: map['type'] as String?,
      referenceId: map['referenceId'] as String?,
      assignedMember: map['assignedMember'] as String?,
      isManagerApproved: map['isManagerApproved'] as bool?,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap('', json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskModel(uid: $uid, title: $title, description: $description, progress: $progress, toDoList: $toDoList, type: $type , referenceId: $referenceId , assignedMember: $assignedMember , isManagerApproved: $isManagerApproved)';
  }
}

class ToDoItem {
  List<String>? owner;
  String? description;
  String? referenceId;
  String? type;
  String title;
  bool isChecked;
  String? proof;
  Timestamp? date;

  ToDoItem({
    this.owner,
    this.description,
    this.referenceId,
    this.type,
    required this.title,
    required this.isChecked,
    this.proof,
    this.date,
  });

  ToDoItem copyWith({
    List<String>? owner,
    String? referenceId,
    String? type,
    String? title,
    bool? isChecked,
    String? proof,
    Timestamp? date,
  }) {
    return ToDoItem(
      owner: owner ?? this.owner,
      referenceId: referenceId ?? this.referenceId,
      type: type ?? this.type,
      title: title ?? this.title,
      isChecked: isChecked ?? this.isChecked,
      proof: proof ?? this.proof,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'owner': owner,
      'referenceId': referenceId,
      'type': type,
      'title': title,
      'isChecked': isChecked,
      'proof': proof,
      'date': date,
    };
  }

  factory ToDoItem.fromMap(String id, Map<String, dynamic> map) {
    return ToDoItem(
      owner: map['owner'] as List<String>?,
      referenceId: map['referenceId'] as String?,
      type: map['type'] as String?,
      title: map['title'] as String,
      isChecked: map['isChecked'] as bool,
      proof: map['proof'] as String?,
      date: map['date'] as Timestamp?,
    );
  }

  String toJson() => json.encode(toMap());

  factory ToDoItem.fromJson(String source) =>
      ToDoItem.fromMap('', json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ToDoItem(owner: $owner, referenceId: $referenceId, type: $type, title: $title, isChecked: $isChecked , proof: $proof , date: $date)';
}
