class ApiEndpoints {
  static const String baseUrl = 'https://mock-api.calleyacd.com';

  // Auth
  static const String register = '$baseUrl/api/auth/register';
  static const String login = '$baseUrl/api/auth/login';
  static const String sendOtp = '$baseUrl/api/auth/send-otp';
  static const String verifyOtp = '$baseUrl/api/auth/verify-otp';

  // Lists
  static String getLists(String userId) => '$baseUrl/api/list?userId=$userId';
  static String getListDetails(String listId) => '$baseUrl/api/list/$listId';
}

