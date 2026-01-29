class ApiConfig {
  // Using your computer's IP address for network access
  // This allows access from other devices on the same network
  static const String baseUrl = 'http://192.168.61.96:3000/api';
  static const String authEndpoint = '$baseUrl/auth';
  static const String userEndpoint = '$baseUrl/user';
}
