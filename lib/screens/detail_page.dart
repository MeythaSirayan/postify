import 'package:flutter/material.dart';

import '../resources/models/model.dart';
import '../widgets/text.dart';
import 'edit_page.dart';

class DetailPage extends StatelessWidget {
  final PostModel post;

  const DetailPage({super.key, required this.post});

  static const purple = Color(0xFF987BB5);
  static const darkPurple = Color(0xFF694C83);
  static const background = Color(0xFFF8F5FA);

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
        centerTitle: true,
        title: const AppText(
          text: 'ARTICLE',
          size: 11,
          weight: FontWeight.bold,
          color: darkPurple,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push<PostModel>(
                context,
                MaterialPageRoute(builder: (context) => EditPage(post: post)),
              );

              if (result != null && context.mounted) {
                Navigator.pop(context, result);
              }
            },
            icon: const Icon(Icons.edit_outlined, color: darkPurple),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ARTICLE NUMBER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE4F3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: AppText(
                text: 'POST #${post.id}',
                size: 11,
                weight: FontWeight.bold,
                color: darkPurple,
              ),
            ),

            const SizedBox(height: 24),

            // TITLE
            AppText(
              text: post.title,
              size: 30,
              weight: FontWeight.bold,
              color: Colors.black,
            ),

            const SizedBox(height: 14),

            // AUTHOR
            const AppText(
              text: 'Oleh Postify Studio  ·  koleksi editorial',
              size: 12,
              color: Colors.black54,
            ),

            const SizedBox(height: 28),

            const Divider(color: Color(0xFFE4DCE9)),

            const SizedBox(height: 20),

            // BODY
            AppText(text: post.body, size: 16),

            const SizedBox(height: 35),

            const Divider(color: Color(0xFFE4DCE9)),

            const SizedBox(height: 20),

            const AppText(
              text: 'KELOLA POST INI',
              size: 11,
              weight: FontWeight.bold,
              color: Colors.black54,
            ),

            const SizedBox(height: 16),

            // EDIT BUTTON
            OutlinedButton.icon(
              onPressed: () async {
                final result = await Navigator.push<PostModel>(
                  context,
                  MaterialPageRoute(builder: (context) => EditPage(post: post)),
                );

                if (result != null && context.mounted) {
                  Navigator.pop(context, result);
                }
              },
              icon: const Icon(Icons.edit_outlined),
              label: const AppText(
                text: 'Edit Post',
                size: 14,
                weight: FontWeight.w600,
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: darkPurple,
                side: const BorderSide(color: purple),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
