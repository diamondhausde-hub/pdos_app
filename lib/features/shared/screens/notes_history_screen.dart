import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/models/note_model.dart';

class NotesHistoryScreen extends ConsumerWidget {
  const NotesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final myId = user?.id ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final notesAsync = myId.isEmpty
        ? const AsyncValue<List<NoteModel>>.loading()
        : ref.watch(notesProvider(myId));

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text(AppStrings.lbl_52),
        backgroundColor: isDark ? const Color(0xFF161B22) : AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline_rounded, size: 64, color: AppColors.onSurfaceVariant.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text(
                    'No conversations yet',
                    style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            );
          }

          // Group notes by other user
          final Map<String, NoteModel> latestNotes = {};
          final Map<String, String> userNames = {};

          for (final note in notes) {
            final isMe = note.senderId == myId;
            final otherUserId = isMe ? note.recipientId : note.senderId;
            final otherUserName = isMe ? note.recipientName : note.senderName;
            
            if (otherUserName != null && otherUserName.isNotEmpty) {
              userNames[otherUserId] = otherUserName;
            }

            if (!latestNotes.containsKey(otherUserId)) {
              latestNotes[otherUserId] = note;
            } else {
              if (note.createdAt.isAfter(latestNotes[otherUserId]!.createdAt)) {
                latestNotes[otherUserId] = note;
              }
            }
          }

          final chatList = latestNotes.entries.toList()
            ..sort((a, b) => b.value.createdAt.compareTo(a.value.createdAt));

          return ListView.separated(
            itemCount: chatList.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: isDark ? Colors.white10 : Colors.black12),
            itemBuilder: (context, index) {
              final chat = chatList[index];
              final otherUserId = chat.key;
              final latestNote = chat.value;
              final otherUserName = userNames[otherUserId] ?? 'User';
              final isMeSender = latestNote.senderId == myId;

              return InkWell(
                onTap: () {
                  context.push('/chat/$otherUserId?name=${Uri.encodeComponent(otherUserName)}');
                },
                child: Container(
                  color: isDark ? const Color(0xFF161B22) : Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: Text(
                          otherUserName.isNotEmpty ? otherUserName[0].toUpperCase() : '?',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    otherUserName,
                                    style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  _formatTime(latestNote.createdAt),
                                  style: AppTextStyles.labelSm.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                if (isMeSender) ...[
                                  Icon(
                                    Icons.check_rounded,
                                    size: 16,
                                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                                  ),
                                  const SizedBox(width: 4),
                                ],
                                Expanded(
                                  child: Text(
                                    latestNote.visitId != null ? '📄 Visit Note' : latestNote.content,
                                    style: AppTextStyles.bodyMd.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading conversations: $err')),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final aDate = DateTime(date.year, date.month, date.day);
    
    if (aDate == today) {
      return DateFormat('HH:mm').format(date);
    } else if (aDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}
