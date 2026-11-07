import 'package:flutter/foundation.dart';
import '../../core/constants/api_endpoints.dart';
import '../../core/network/api_client.dart';
import '../mock/mock_data.dart';
import '../models/calling_list_model.dart';
import '../models/list_details_model.dart';

class CallRepository {
  Future<List<CallingListModel>> getCallingLists(String userId) async {
    if (kIsWeb) {
      // Clean mock response on Web avoiding Chrome's server SSL certificate warning
      await Future.delayed(const Duration(milliseconds: 200));
      return [MockData.defaultCallingList];
    }

    try {
      final res = await ApiClient.get(ApiEndpoints.getLists(userId));
      if (res is List) {
        return res
            .map((item) =>
                CallingListModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (res is Map<String, dynamic>) {
        return [CallingListModel.fromJson(res)];
      }
      return [MockData.defaultCallingList];
    } catch (_) {
      return [MockData.defaultCallingList];
    }
  }

  Future<ListDetailsModel> getListDetails(String listId) async {
    if (kIsWeb) {
      await Future.delayed(const Duration(milliseconds: 200));
      return MockData.defaultListDetails;
    }

    try {
      final res = await ApiClient.get(ApiEndpoints.getListDetails(listId));
      if (res is Map<String, dynamic>) {
        return ListDetailsModel.fromJson(res);
      }
      return MockData.defaultListDetails;
    } catch (_) {
      return MockData.defaultListDetails;
    }
  }
}
