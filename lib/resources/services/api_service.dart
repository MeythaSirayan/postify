import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/endpoints.dart';
import '../models/model.dart';

class PostApiService {
  // GET ALL POSTS
  Future<List<PostModel>> getPosts() async {
    final response = await http.get(Uri.parse(ApiConstants.posts));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((item) => PostModel.fromJson(item)).toList();
    }

    throw Exception('Gagal mengambil data posts');
  }

  // GET DETAIL POST
  Future<PostModel> getPostById(int id) async {
    final response = await http.get(Uri.parse(ApiConstants.postDetail(id)));

    if (response.statusCode == 200) {
      return PostModel.fromJson(jsonDecode(response.body));
    }

    throw Exception('Gagal mengambil detail post');
  }

  // CREATE POST
  Future<PostModel> createPost(PostModel post) async {
    final response = await http.post(
      Uri.parse(ApiConstants.posts),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 201) {
      return PostModel.fromJson(jsonDecode(response.body));
    }

    throw Exception('Gagal menambahkan post');
  }

  // UPDATE POST
  Future<PostModel> updatePost(PostModel post) async {
    final response = await http.put(
      Uri.parse(ApiConstants.postDetail(post.id)),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode == 200) {
      return PostModel.fromJson(jsonDecode(response.body));
    }

    throw Exception('Gagal mengubah post');
  }

  // DELETE POST
  Future<bool> deletePost(int id) async {
    final response = await http.delete(Uri.parse(ApiConstants.postDetail(id)));

    if (response.statusCode == 200) {
      return true;
    }

    throw Exception('Gagal menghapus post');
  }
}
