import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../resources/models/model.dart';
import '../widgets/text.dart';
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
        const SnackBar(
          content: AppText(
            text: 'Judul dan isi post harus diisi',
            size: 14,
            color: Colors.white,
          ),
        ),
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
          content: AppText(
            text: 'Gagal menyimpan post: $e',
            size: 14,
            color: Colors.white,
          ),
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
            AppText(
              text: isEditing ? 'EDITING STORY' : 'NEW STORY',
              size: 11,
              weight: FontWeight.bold,
              color: darkPurple,
            ),

            const SizedBox(height: 8),

            AppHeading(
              text: isEditing
                  ? 'Poles kembali ide ini.'
                  : 'Apa yang ingin kamu tulis?',
              size: 27,
              weight: FontWeight.w500,
              color: Colors.black,
            ),

            const SizedBox(height: 32),

            // JUDUL
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText(
                  text: 'JUDUL',
                  size: 11,
                  weight: FontWeight.bold,
                  color: Colors.black,
                ),
                ValueListenableBuilder(
                  valueListenable: titleController,
                  builder: (context, value, child) {
                    return AppText(
                      text: '${value.text.length}/120',
                      size: 11,
                      color: Colors.black54,
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
              style: GoogleFonts.lato(color: Colors.black),
            ),

            const SizedBox(height: 24),

            // ISI POST
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText(
                  text: 'ISI CERITA',
                  size: 11,
                  weight: FontWeight.bold,
                  color: Colors.black,
                ),
                ValueListenableBuilder(
                  valueListenable: bodyController,
                  builder: (context, value, child) {
                    return AppText(
                      text: '${value.text.length}/2000',
                      size: 11,
                      color: Colors.black54,
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
              style: GoogleFonts.lato(color: Colors.black, height: 1.5),
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
                          AppText(
                            text: isEditing
                                ? 'Simpan perubahan'
                                : 'Publikasikan post',
                            size: 14,
                            weight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: AppText(
                text: 'Post dikirim ke JSONPlaceholder\nuntuk simulasi pengelolaan artikel.',
                size: 11,
                color: Colors.black45,
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
      hintStyle: GoogleFonts.lato(color: Colors.black54),
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
