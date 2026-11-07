import 'package:flutter/material.dart';
import '../core/utils/preference_manager.dart';
import '../data/models/calling_list_model.dart';
import '../data/models/call_record_model.dart';
import '../data/models/list_details_model.dart';
import '../data/repositories/call_repository.dart';

class ListProvider extends ChangeNotifier {
  final CallRepository _repository = CallRepository();

  List<CallingListModel> _lists = [];
  CallingListModel? _selectedList;
  ListDetailsModel? _listDetails;
  bool _isLoading = false;
  String? _errorMessage;
  String _filterStatus = 'all'; // 'all', 'pending', 'called', 'rescheduled'
  String _searchQuery = '';

  List<CallingListModel> get lists => _lists;
  CallingListModel? get selectedList => _selectedList;
  ListDetailsModel? get listDetails => _listDetails;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get filterStatus => _filterStatus;
  String get searchQuery => _searchQuery;

  // Filtered calls
  List<CallRecordModel> get filteredCalls {
    if (_listDetails == null) return [];
    var result = _listDetails!.calls;

    if (_filterStatus != 'all') {
      result = result
          .where((call) =>
              call.status.toLowerCase() == _filterStatus.toLowerCase())
          .toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((call) {
        return call.fullName.toLowerCase().contains(q) ||
            call.phone.contains(q) ||
            call.company.toLowerCase().contains(q);
      }).toList();
    }

    return result;
  }

  int get pendingCount => _listDetails?.pending ?? 0;
  int get doneCount => _listDetails?.called ?? 0;
  int get scheduleCount => _listDetails?.rescheduled ?? 0;
  int get totalCalls => _listDetails?.totalCalls ?? 0;

  void clear() {
    _lists = [];
    _selectedList = null;
    _listDetails = null;
    _filterStatus = 'all';
    _searchQuery = '';
    notifyListeners();
  }

  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchLists(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _lists = await _repository.getCallingLists(userId);
      if (_lists.isNotEmpty) {
        final savedListId = await PreferenceManager.getActiveListId();
        final match = _lists.firstWhere(
          (l) => l.id == savedListId,
          orElse: () => _lists.first,
        );
        await selectList(match);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectList(CallingListModel list) async {
    _selectedList = list;
    await PreferenceManager.setActiveListId(list.id);
    notifyListeners();
    await fetchListDetails(list.id);
  }

  Future<void> fetchListDetails(String listId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _listDetails = await _repository.getListDetails(listId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Action to simulate making a call / updating call status
  void markCallCompleted(CallRecordModel record, {String? feedback}) {
    if (_listDetails == null) return;

    final updatedCalls = _listDetails!.calls.map((c) {
      if (c.phone == record.phone) {
        return CallRecordModel(
          firstName: c.firstName,
          lastName: c.lastName,
          title: c.title,
          phone: c.phone,
          otherPhone1: c.otherPhone1,
          otherPhone2: c.otherPhone2,
          otherPhone3: c.otherPhone3,
          otherPhone4: c.otherPhone4,
          email: c.email,
          address: c.address,
          company: c.company,
          age: c.age,
          zip: c.zip,
          maritalStatus: c.maritalStatus,
          notes: c.notes,
          calledAt: DateTime.now().toIso8601String(),
          rescheduledAt: c.rescheduledAt,
          createdAt: c.createdAt,
          status: 'called',
          agentName: c.agentName,
          agentId: c.agentId,
          duration: (c.duration ?? 0) + 12,
          feedback: feedback ?? 'Call completed successfully',
        );
      }
      return c;
    }).toList();

    final pending = updatedCalls.where((c) => c.status == 'pending').length;
    final called = updatedCalls.where((c) => c.status == 'called').length;
    final rescheduled =
        updatedCalls.where((c) => c.status == 'rescheduled').length;

    _listDetails = ListDetailsModel(
      pending: pending,
      called: called,
      rescheduled: rescheduled,
      calls: updatedCalls,
    );
    notifyListeners();
  }
}

