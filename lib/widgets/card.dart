import 'package:flutter/material.dart';
import '../resources/models/model.dart';
import 'text.dart';

class PostifyArticleCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onDetail;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PostifyArticleCard({
    super.key,
    required this.post,
    required this.onDetail,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.indigo.shade50,
                  child: AppText(
                    text: '${post.id}',
                    weight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppHeading(
                    text: post.title,
                    size: 16,
                    weight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            AppText(
              text: post.body,
              size: 14,
              color: Colors.grey.shade700,
            ),

            const Divider(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: onDetail,
                  icon: const Icon(Icons.visibility_outlined),
                  color: Colors.blue,
                  tooltip: 'Detail',
                ),
                IconButton(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                  color: Colors.orange,
                  tooltip: 'Edit',
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red,
                  tooltip: 'Hapus',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
