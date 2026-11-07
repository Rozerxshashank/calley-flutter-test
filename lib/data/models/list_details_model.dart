import 'call_record_model.dart';

class ListDetailsModel {
  final int pending;
  final int called;
  final int rescheduled;
  final List<CallRecordModel> calls;

  ListDetailsModel({
    required this.pending,
    required this.called,
    required this.rescheduled,
    required this.calls,
  });

  int get totalCalls => calls.length;

  factory ListDetailsModel.fromJson(Map<String, dynamic> json) {
    final callsList = (json['calls'] as List? ?? [])
        .map((item) => CallRecordModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return ListDetailsModel(
      pending: json['pending'] is int
          ? json['pending']
          : int.tryParse(json['pending']?.toString() ?? '28') ?? 28,
      called: json['called'] is int
          ? json['called']
          : int.tryParse(json['called']?.toString() ?? '22') ?? 22,
      rescheduled: json['rescheduled'] is int
          ? json['rescheduled']
          : int.tryParse(json['rescheduled']?.toString() ?? '9') ?? 9,
      calls: callsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pending': pending,
      'called': called,
      'rescheduled': rescheduled,
      'calls': calls.map((c) => c.toJson()).toList(),
    };
  }
}

