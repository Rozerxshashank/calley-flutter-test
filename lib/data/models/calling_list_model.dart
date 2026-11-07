class CallingListModel {
  final String id;
  final String name;
  final String clientId;
  final List<dynamic> agents;

  CallingListModel({
    required this.id,
    required this.name,
    required this.clientId,
    this.agents = const [],
  });

  factory CallingListModel.fromJson(Map<String, dynamic> json) {
    return CallingListModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? 'Test List',
      clientId: json['clientId'] ?? '',
      agents: json['agents'] is List ? json['agents'] : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'clientId': clientId,
      'agents': agents,
    };
  }
}

