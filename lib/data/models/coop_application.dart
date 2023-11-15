class CooperativeAppFormModel {
  String? uid;
  String? userUID;
  String? firstName;
  String? lastName;
  String? coopName;
  String? coopId;
  String? reasonForJoining;
  String? status;
  List<String>? coopDocuments;
  DateTime? timestamp;

  CooperativeAppFormModel({
    this.uid,
    this.userUID,
    this.firstName,
    this.lastName,
    this.coopName,
    this.coopId,
    this.reasonForJoining,
    this.status,
    this.coopDocuments,
    this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'userUID': userUID,
      'firstName': firstName,
      'lastName': lastName,
      'coopName': coopName,
      'coopId': coopId,
      'reasonForJoining': reasonForJoining,
      'status': status,
      'coopDocuments': coopDocuments,
      'submitDate': timestamp,
    };
  }

  factory CooperativeAppFormModel.fromJson(
      String uid, Map<String, dynamic> json) {
    return CooperativeAppFormModel(
      uid: uid,
      userUID: json['userUID'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      coopName: json['coopName'],
      coopId: json['coopId'],
      reasonForJoining: json['reasonForJoining'],
      status: json['status'],
      coopDocuments: json['coopDocuments']?.cast<String>(),
      timestamp: json['submitDate']?.toDate(),
    );
  }

  CooperativeAppFormModel copyWith({
    String? uid,
    String? userUID,
    String? firstName,
    String? lastName,
    String? coopName,
    String? coopId,
    String? reasonForJoining,
    String? status,
    List<String>? coopDocuments,
    DateTime? timestamp,
  }) {
    return CooperativeAppFormModel(
      uid: uid ?? this.uid,
      userUID: userUID ?? this.userUID,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      coopName: coopName ?? this.coopName,
      coopId: coopId ?? this.coopId,
      reasonForJoining: reasonForJoining ?? this.reasonForJoining,
      status: status ?? this.status,
      coopDocuments: coopDocuments ?? this.coopDocuments,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  
}