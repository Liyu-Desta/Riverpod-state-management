class UserOpportunity {
  String id;
  String userId;
  OpportunityId opportunityId;
  int selectedDateIndex;
  DateTime selectedDate;
  List<DateTime> dates;
  bool showDetails;

  UserOpportunity({
    required this.id,
    required this.userId,
    required this.opportunityId,
    required this.selectedDateIndex,
    required this.selectedDate,
    required this.dates,
    this.showDetails = false,
  });

  factory UserOpportunity.fromJson(Map<String, dynamic> json) {
    return UserOpportunity(
      id: json['_id'],
      userId: json['userId'],
      opportunityId: OpportunityId.fromJson(json['opportunityId']),
      selectedDateIndex: 0,
      selectedDate: DateTime.parse(json['selectedDate']),
      dates: [
        DateTime.parse(json['opportunityId']['date']),
        json['opportunityId']['date2'] != null
            ? DateTime.parse(json['opportunityId']['date2'])
            : DateTime.now(),
      ],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'opportunityId': opportunityId.toJson(),
      'selectedDateIndex': selectedDateIndex,
      'selectedDate': selectedDate.toIso8601String(),
      'dates': dates.map((date) => date.toIso8601String()).toList(),
    };
  }
}

class OpportunityId {
  String id;
  String title;
  String description;
  String photo;
  String location;
  String date;
  String? date2;

  OpportunityId({
    required this.id,
    required this.title,
    required this.description,
    required this.photo,
    required this.location,
    required this.date,
    this.date2,
  });

  factory OpportunityId.fromJson(Map<String, dynamic> json) {
    return OpportunityId(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      photo: json['photo'],
      location: json['location'],
      date: json['date'],
      date2: json['date2'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'photo': photo,
      'location': location,
      'date': date,
      'date2': date2,
    };
  }
}

class BookModel {
  String userId;
  String opportunityId;
  DateTime selectedDate;

  BookModel({
    required this.userId,
    required this.opportunityId,
    required this.selectedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'opportunityId': opportunityId,
      'selectedDate': selectedDate.toIso8601String(),
    };
  }
}
