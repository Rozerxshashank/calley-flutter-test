class CallRecordModel {
  final String firstName;
  final String lastName;
  final String title;
  final String phone;
  final String? otherPhone1;
  final String? otherPhone2;
  final String? otherPhone3;
  final String? otherPhone4;
  final String email;
  final String address;
  final String company;
  final int age;
  final String zip;
  final String maritalStatus;
  final String notes;
  final String? calledAt;
  final String? rescheduledAt;
  final String? createdAt;
  final String status; // 'pending', 'called', 'rescheduled'
  final String agentName;
  final String agentId;
  final int? duration;
  final String? feedback;

  CallRecordModel({
    required this.firstName,
    required this.lastName,
    required this.title,
    required this.phone,
    this.otherPhone1,
    this.otherPhone2,
    this.otherPhone3,
    this.otherPhone4,
    required this.email,
    required this.address,
    required this.company,
    required this.age,
    required this.zip,
    required this.maritalStatus,
    required this.notes,
    this.calledAt,
    this.rescheduledAt,
    this.createdAt,
    required this.status,
    required this.agentName,
    required this.agentId,
    this.duration,
    this.feedback,
  });

  String get fullName => '$title $firstName $lastName'.trim();

  factory CallRecordModel.fromJson(Map<String, dynamic> json) {
    return CallRecordModel(
      firstName: json['FirstName']?.toString() ?? '',
      lastName: json['LastName']?.toString() ?? '',
      title: json['Title']?.toString() ?? '',
      phone: json['Phone']?.toString() ?? '',
      otherPhone1: json['Other Phone 1']?.toString(),
      otherPhone2: json['Other Phone 2']?.toString(),
      otherPhone3: json['Other Phone 3']?.toString(),
      otherPhone4: json['Other Phone 4']?.toString(),
      email: json['Email']?.toString() ?? '',
      address: json['Address']?.toString() ?? '',
      company: json['Company']?.toString() ?? '',
      age: json['Age'] is int
          ? json['Age']
          : int.tryParse(json['Age']?.toString() ?? '0') ?? 0,
      zip: json['Zip']?.toString() ?? '',
      maritalStatus: json['MaritalStatus']?.toString() ?? '',
      notes: json['Notes']?.toString() ?? '',
      calledAt: json['calledAt']?.toString(),
      rescheduledAt: json['rescheduledAt']?.toString(),
      createdAt: json['createdAt']?.toString(),
      status: json['status']?.toString().toLowerCase() ?? 'pending',
      agentName: json['agentName']?.toString() ?? '',
      agentId: json['agentId']?.toString() ?? '',
      duration: json['duration'] is int
          ? json['duration']
          : int.tryParse(json['duration']?.toString() ?? ''),
      feedback: json['feedback']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FirstName': firstName,
      'LastName': lastName,
      'Title': title,
      'Phone': phone,
      'Other Phone 1': otherPhone1,
      'Other Phone 2': otherPhone2,
      'Other Phone 3': otherPhone3,
      'Other Phone 4': otherPhone4,
      'Email': email,
      'Address': address,
      'Company': company,
      'Age': age,
      'Zip': zip,
      'MaritalStatus': maritalStatus,
      'Notes': notes,
      'calledAt': calledAt,
      'rescheduledAt': rescheduledAt,
      'createdAt': createdAt,
      'status': status,
      'agentName': agentName,
      'agentId': agentId,
      'duration': duration,
      'feedback': feedback,
    };
  }
}

