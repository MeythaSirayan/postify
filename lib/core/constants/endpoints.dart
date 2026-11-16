class ApiConstants {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  static const String posts = '$baseUrl/posts';

  static String postDetail(int id) => '$posts/$id';
}
