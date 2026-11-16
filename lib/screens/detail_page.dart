import 'package:flutter/material.dart';

import '../resources/models/model.dart';
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
        title: const Text(
          'ARTICLE',
          style: TextStyle(
            color: darkPurple,
            fontSize: 11,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
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
              child: Text(
                'POST #${post.id}',
                style: const TextStyle(
                  color: darkPurple,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // TITLE
            Text(
              post.title,
              style: const TextStyle(
                fontFamily: 'Georgia',
                fontSize: 30,
                height: 1.3,
                color: darkPurple,
              ),
            ),

            const SizedBox(height: 14),

            // AUTHOR
            const Text(
              'Oleh Postify Studio  ·  koleksi editorial',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),

            const SizedBox(height: 28),

            const Divider(color: Color(0xFFE4DCE9)),

            const SizedBox(height: 20),

            // BODY
            Text(
              post.body,
              style: const TextStyle(
                color: Color(0xFF51485A),
                fontSize: 16,
                height: 1.8,
              ),
            ),

            const SizedBox(height: 35),

            const Divider(color: Color(0xFFE4DCE9)),

            const SizedBox(height: 20),

            const Text(
              'KELOLA POST INI',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
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
              label: const Text('Edit Post'),
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
