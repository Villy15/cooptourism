import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// Dart Data Class Generator
class TaskModel {
  String? uid;
  String title;
  String description;
  num progress;
  List<ToDoItem> toDoList;
  TaskModel({
    this.uid,
    required this.title,
    required this.description,
    required this.progress,
    required this.toDoList,
  });

  TaskModel copyWith({
    String? uid,
    String? title,
    String? description,
    double? progress,
    List<ToDoItem>? toDoList,
  }) {
    return TaskModel(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      progress: progress ?? this.progress,
      toDoList: toDoList ?? this.toDoList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'uid': uid,
      'title': title,
      'description': description,
      'progress': progress,
      'toDoList': toDoList.map((x) => x.toMap()).toList(),
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
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) => TaskModel.fromMap('', json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskModel(uid: $uid, title: $title, description: $description, progress: $progress, toDoList: $toDoList)';
  }

  @override
  bool operator ==(covariant TaskModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.title == title &&
      other.description == description &&
      other.progress == progress &&
      listEquals(other.toDoList, toDoList);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
      title.hashCode ^
      description.hashCode ^
      progress.hashCode ^
      toDoList.hashCode;
  }
}

class ToDoItem {
  String? uid;
  String title;
  bool isChecked;
  ToDoItem({
    this.uid,
    required this.title,
    required this.isChecked,
  });

  

  ToDoItem copyWith({
    String? uid,
    String? title,
    bool? isChecked,
  }) {
    return ToDoItem(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'uid': uid,
      'title': title,
      'isChecked': isChecked,
    };
  }

  factory ToDoItem.fromMap(String id, Map<String, dynamic> map) {
    return ToDoItem(
      uid: id,
      title: map['title'] as String,
      isChecked: map['isChecked'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ToDoItem.fromJson(String source) => ToDoItem.fromMap('', json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ToDoItem(uid: $uid, title: $title, isChecked: $isChecked)';

  @override
  bool operator ==(covariant ToDoItem other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid &&
      other.title == title &&
      other.isChecked == isChecked;
  }

  @override
  int get hashCode => uid.hashCode ^ title.hashCode ^ isChecked.hashCode;
}
