class CoachingFormModel {
  String? uid;
  String? concern;
  String? concernDescription;
  String? goal;
  String? userUID;
  String? firstName;
  String? lastName;
  String? status;
  DateTime? timestamp;

  CoachingFormModel ({
    this.uid,
    this.concern,
    this.concernDescription,
    this.goal,
    this.userUID,
    this.firstName,
    this.lastName,
    this.status,
    this.timestamp
  });

  Map<String, dynamic> toJson() {
    return {
      'coaching_focus': concern,
      'concern_description': concernDescription,
      'goal': goal,
      'userUID': userUID,
      'first_name': firstName,
      'last_name': lastName,
      'status': status,
      'time_submitted': timestamp,
    };
  }

  factory CoachingFormModel.fromJson(String uid, Map<String, dynamic> json) {
    return CoachingFormModel(
      uid: uid,
      concern: json['coaching_focus'],
      concernDescription: json['concern_description'],
      goal: json['goal'],
      userUID: json['userUID'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      status: json['status'],
      timestamp: json['time_submitted']?.toDate(),
    );
  }

  CoachingFormModel copyWith({
    String? uid,
    String? concern,
    String? concernDescription,
    String? goal,
    String? userUID,
    String? firstName,
    String? lastName,
    String? status,
    DateTime? timestamp,
  }) {
    return CoachingFormModel(
      uid: uid ?? this.uid,
      concern: concern ?? this.concern,
      concernDescription: concernDescription ?? this.concernDescription,
      goal: goal ?? this.goal,
      userUID: userUID ?? this.userUID,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  

  
}

