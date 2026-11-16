import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../resources/models/model.dart';
import '../resources/services/api_service.dart';
import 'detail_page.dart';
import 'edit_page.dart';

class PostifyListPage extends StatefulWidget {
  const PostifyListPage({super.key});

  @override
  State<PostifyListPage> createState() => _PostifyListPageState();
}

class _PostifyListPageState extends State<PostifyListPage> {
  final PostApiService apiService = PostApiService();
  final TextEditingController searchController = TextEditingController();

  List<PostModel> articles = [];

  bool isLoading = true;
  String? errorMessage;
  String selectedFilter = 'Semua';

  static const Color purple = Color(0xFF987BB5);
  static const Color darkPurple = Color(0xFF694C83);
  static const Color background = Color(0xFFF8F5FA);
  static const Color gold = Color(0xFFE8D8B0);

  @override
  void initState() {
    super.initState();
    loadArticles();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // GET DATA
  Future<void> loadArticles() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await apiService.getPosts();

      if (!mounted) return;

      setState(() {
        articles = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  // FILTER AND SEARCH
  List<PostModel> get filteredArticles {
    return articles.where((post) {
      final keyword = searchController.text.toLowerCase();

      final matchesSearch = post.title.toLowerCase().contains(keyword);

      final matchesFilter =
          selectedFilter == 'Semua' ||
          (selectedFilter == 'Ringkas' && post.body.length < 150) ||
          (selectedFilter == 'Mendalam' && post.body.length >= 150);

      return matchesSearch && matchesFilter;
    }).toList();
  }

  // ADD POST
  Future<void> addArticle() async {
    final result = await Navigator.push<PostModel>(
      context,
      MaterialPageRoute(builder: (_) => const EditPage()),
    );

    if (result != null && mounted) {
      setState(() {
        articles.insert(0, result);
      });
    }
  }

  // EDIT POST
  Future<void> editArticle(PostModel post) async {
    final result = await Navigator.push<PostModel>(
      context,
      MaterialPageRoute(builder: (_) => EditPage(post: post)),
    );

    if (result != null && mounted) {
      setState(() {
        final index = articles.indexWhere((item) => item.id == post.id);

        if (index != -1) {
          articles[index] = result;
        }
      });
    }
  }

  // DETAIL POST

  Future<void> showDetail(PostModel post) async {
    final result = await Navigator.push<PostModel>(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(post: post)),
    );

    if (result != null && mounted) {
      setState(() {
        final index = articles.indexWhere((item) => item.id == post.id);

        if (index != -1) {
          articles[index] = result;
        }
      });
    }
  }

  // DELETE POST
  Future<void> deleteArticle(PostModel post) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus artikel?'),
        content: const Text('Artikel ini akan dihapus dari daftar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: darkPurple),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await apiService.deletePost(post.id);

      if (!mounted) return;

      setState(() {
        articles.removeWhere((item) => item.id == post.id);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Artikel berhasil dihapus')));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal menghapus: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = filteredArticles;

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Postify.',
          style: GoogleFonts.playfairDisplay(
            color: darkPurple,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: loadArticles,
            icon: const Icon(Icons.refresh_rounded, color: darkPurple),
          ),
        ],
      ),

      // ADD BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: addArticle,
        backgroundColor: darkPurple,
        foregroundColor: Colors.white,
        elevation: 5,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 30),
      ),

      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            padding: const EdgeInsets.all(23),
            decoration: BoxDecoration(
              color: purple,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YOUR CREATIVE SPACE',
                  style: TextStyle(
                    color: gold,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 16),
                Text(
                  'Ideas deserve\nto be written.',
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 29,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  '${articles.length} artikel dalam koleksi',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          // SEARCH
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Cari artikel...',
                prefixIcon: const Icon(Icons.search, color: darkPurple),
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.close),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // FILTER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['Semua', 'Ringkas', 'Mendalam'].map((filter) {
                final active = selectedFilter == filter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: active,
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    selectedColor: purple.withOpacity(0.18),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: active ? darkPurple : Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide(color: active ? purple : Colors.black12),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // ARTICLE COUNT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${data.length} hasil',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ARTICLE LIST
          Expanded(child: buildArticleList(data)),
        ],
      ),
    );
  }

  // ARTICLE CARD
  Widget buildArticleList(List<PostModel> data) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: purple));
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Gagal memuat artikel'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: loadArticles,
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      );
    }

    if (data.isEmpty) {
      return const Center(child: Text('Artikel tidak ditemukan'));
    }

    return RefreshIndicator(
      onRefresh: loadArticles,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final post = data[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: purple.withOpacity(0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: purple.withOpacity(0.15),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: darkPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Text(
                      'POST #${post.id}',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: darkPurple,
                  ),
                ),

                const SizedBox(height: 9),

                Text(
                  post.body,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black54,
                    height: 1.5,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 18),
                const Divider(),

                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => showDetail(post),
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const Text('Baca selengkapnya'),
                      style: TextButton.styleFrom(foregroundColor: darkPurple),
                    ),

                    const Spacer(),

                    IconButton(
                      onPressed: () => editArticle(post),
                      icon: const Icon(Icons.edit_outlined),
                      color: purple,
                    ),

                    IconButton(
                      onPressed: () => deleteArticle(post),
                      icon: const Icon(Icons.delete_outline),
                      color: darkPurple,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
