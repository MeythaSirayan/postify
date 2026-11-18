import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/text.dart';
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
        title: const AppHeading(
          text: 'Hapus artikel?',
          size: 20,
          weight: FontWeight.bold,
          color: darkPurple,
        ),
        content: const AppText(
          text: 'Artikel ini akan dihapus dari daftar.',
          size: 14,
          color: Colors.black,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const AppText(text: 'Batal', size: 14, color: darkPurple),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: darkPurple),
            onPressed: () => Navigator.pop(context, true),
            child: const AppText(
              text: 'Hapus',
              size: 14,
              weight: FontWeight.bold,
              color: Colors.white,
            ),
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: AppText(
            text: 'Artikel berhasil dihapus',
            size: 14,
            color: Colors.white,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppText(
            text: 'Gagal menghapus: $e',
            size: 14,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = filteredArticles;

    return Scaffold(
      backgroundColor: background,

      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const AppHeading(
          text: 'postify.',
          size: 26,
          weight: FontWeight.bold,
          color: darkPurple,
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
                const AppText(
                  text: 'YOUR CREATIVE SPACE',
                  size: 11,
                  weight: FontWeight.bold,
                  color: Colors.white,
                ),

                const SizedBox(height: 16),

                const AppHeading(
                  text: 'Ideas deserve\nto be written.',
                  size: 29,
                  weight: FontWeight.w500,
                  color: Colors.white,
                ),

                const SizedBox(height: 12),

                AppText(
                  text: '${articles.length} artikel dalam koleksi',
                  size: 13,
                  color: Colors.white70,
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
              style: GoogleFonts.lato(fontSize: 14, color: darkPurple),
              decoration: InputDecoration(
                hintText: 'Cari artikel...',
                hintStyle: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.black54,
                ),
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
                    label: AppText(
                      text: filter,
                      size: 13,
                      weight: FontWeight.w600,
                      color: active ? darkPurple : Colors.black54,
                    ),
                    selected: active,
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    selectedColor: purple.withOpacity(0.18),
                    backgroundColor: Colors.white,
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
                AppText(
                  text: '${data.length} hasil',
                  size: 12,
                  color: Colors.black54,
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
            const AppText(
              text: 'Gagal memuat artikel',
              size: 16,
              color: darkPurple,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: loadArticles,
              child: const AppText(
                text: 'Coba lagi',
                size: 14,
                color: darkPurple,
              ),
            ),
          ],
        ),
      );
    }

    if (data.isEmpty) {
      return const Center(
        child: AppText(
          text: 'Artikel tidak ditemukan',
          size: 15,
          color: darkPurple,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadArticles,
      color: darkPurple,
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
                // POST NUMBER
                Row(
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundColor: purple.withOpacity(0.15),
                      child: AppText(
                        text: '${index + 1}',
                        weight: FontWeight.bold,
                        color: darkPurple,
                      ),
                    ),

                    const SizedBox(width: 12),

                    AppText(
                      text: 'POST #${post.id}',
                      size: 11,
                      weight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // TITLE
                AppHeading(
                  text: post.title,
                  size: 17,
                  weight: FontWeight.bold,
                  color: Colors.black,
                ),

                const SizedBox(height: 9),

                // BODY
                AppText(text: post.body, size: 13, color: Colors.black54),

                const SizedBox(height: 18),

                const Divider(),

                // ACTIONS
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => showDetail(post),
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: const AppText(
                        text: 'Baca selengkapnya',
                        size: 14,
                        weight: FontWeight.bold,
                        color: darkPurple,
                      ),
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
