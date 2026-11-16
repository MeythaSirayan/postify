import 'package:flutter/material.dart';

import '../resources/models/model.dart';
import '../resources/services/api_service.dart';

class EditPage extends StatefulWidget {
  final PostModel? post;

  const EditPage({super.key, this.post});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final apiService = PostApiService();

  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  bool isLoading = false;

  static const purple = Color(0xFF987BB5);
  static const darkPurple = Color(0xFF694C83);
  static const background = Color(0xFFF8F5FA);

  bool get isEditing => widget.post != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      titleController.text = widget.post!.title;
      bodyController.text = widget.post!.body;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  // SAVE POST
  Future<void> savePost() async {
    if (titleController.text.trim().isEmpty ||
        bodyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan isi post harus diisi')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final PostModel post = PostModel(
        id: widget.post?.id ?? 0,
        userId: widget.post?.userId ?? 1,
        title: titleController.text.trim(),
        body: bodyController.text.trim(),
      );

      final result = isEditing
          ? await apiService.updatePost(post)
          : await apiService.createPost(post);

      if (!mounted) return;

      Navigator.pop(context, result);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan post: $e'),
          backgroundColor: darkPurple,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: darkPurple),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? 'EDITING STORY' : 'NEW STORY',
              style: const TextStyle(
                color: darkPurple,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              isEditing
                  ? 'Poles kembali ide ini.'
                  : 'Apa yang ingin kamu tulis?',
              style: const TextStyle(
                fontFamily: 'Georgia',
                fontSize: 27,
                color: darkPurple,
              ),
            ),

            const SizedBox(height: 32),

            // JUDUL
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'JUDUL',
                  style: TextStyle(
                    color: darkPurple,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: titleController,
                  builder: (context, value, child) {
                    return Text(
                      '${value.text.length}/120',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            TextField(
              controller: titleController,
              maxLength: 120,
              maxLines: 2,
              decoration: inputDecoration('Tulis judul post...'),
              style: const TextStyle(color: darkPurple),
            ),

            const SizedBox(height: 24),

            // ISI POST
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ISI CERITA',
                  style: TextStyle(
                    color: darkPurple,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: bodyController,
                  builder: (context, value, child) {
                    return Text(
                      '${value.text.length}/2000',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            TextField(
              controller: bodyController,
              maxLength: 2000,
              maxLines: 8,
              decoration: inputDecoration('Ceritakan idemu di sini...'),
              style: const TextStyle(color: darkPurple, height: 1.5),
            ),

            const SizedBox(height: 25),

            // BUTTON SIMPAN
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: isLoading ? null : savePost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.arrow_upward),
                          const SizedBox(width: 10),
                          Text(
                            isEditing
                                ? 'Simpan perubahan'
                                : 'Publikasikan post',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                'Post dikirim ke JSONPlaceholder\nuntuk simulasi pengelolaan artikel.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // INPUT STYLE
  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      counterText: '',
      filled: true,
      fillColor: const Color(0xFFF1EBF4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFDCD0E5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFFDCD0E5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: purple, width: 1.5),
      ),
    );
  }
}
