import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/models/note_model.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String otherUserId;
  final String? otherUserName;

  const ChatScreen({
    super.key,
    required this.otherUserId,
    this.otherUserName,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;
  final List<NoteModel> _localNotes = [];

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    final user = ref.read(currentUserProvider);
    final myId = user?.id ?? '';
    
    // Create temporary optimistic note
    final tempNote = NoteModel(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      senderId: myId,
      senderName: user?.fullName ?? 'Me',
      recipientId: widget.otherUserId,
      recipientName: widget.otherUserName,
      content: text,
      createdAt: DateTime.now(),
    );

    setState(() {
      _localNotes.insert(0, tempNote);
      _isSending = true;
    });
    
    HapticFeedback.lightImpact();
    _msgController.clear();

    try {
      await ref.read(repNoteRepositoryProvider).sendNote(widget.otherUserId, text);
      if (user != null) {
        ref.invalidate(notesProvider(user.id));
      }
      if (mounted) {
        setState(() {
          _localNotes.removeWhere((n) => n.id == tempNote.id);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _localNotes.removeWhere((n) => n.id == tempNote.id);
          _msgController.text = text; 
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Expanded(child: Text(AppStrings.lbl_46)),
              ],
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final myId = user?.id ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final notesAsync = myId.isEmpty
        ? const AsyncValue<List<NoteModel>>.loading()
        : ref.watch(notesProvider(myId));

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : const Color(0xFFE5DDD5),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF161B22) : AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              child: Text(
                (widget.otherUserName != null && widget.otherUserName!.isNotEmpty)
                    ? widget.otherUserName![0].toUpperCase()
                    : 'U',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.otherUserName ?? 'User',
                style: AppTextStyles.bodyLg.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: notesAsync.when(
        data: (allNotes) {
          // Filter notes that belong to this specific chat
          final chatNotes = allNotes.where((n) => 
            (n.senderId == myId && n.recipientId == widget.otherUserId) ||
            (n.senderId == widget.otherUserId && n.recipientId == myId)
          ).toList();

          final combinedNotes = [..._localNotes, ...chatNotes];
          final sortedNotes = List<NoteModel>.from(combinedNotes)
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return Column(
            children: [
              Expanded(
                child: sortedNotes.isEmpty
                    ? Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E232D) : const Color(0xFFFFF5C4),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4),
                            ]
                          ),
                          child: Text(
                            'No messages yet',
                            style: AppTextStyles.bodySm.copyWith(
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        itemCount: sortedNotes.length,
                        itemBuilder: (context, index) {
                          final note = sortedNotes[index];
                          final isMe = note.senderId == myId;
                          
                          bool showDateHeader = false;
                          if (index == sortedNotes.length - 1) {
                            showDateHeader = true;
                          } else {
                            final prevNote = sortedNotes[index + 1];
                            if (note.createdAt.day != prevNote.createdAt.day ||
                                note.createdAt.month != prevNote.createdAt.month ||
                                note.createdAt.year != prevNote.createdAt.year) {
                              showDateHeader = true;
                            }
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (showDateHeader) _buildDateHeader(note.createdAt, isDark),
                              ChatBubble(
                                note: note,
                                isMe: isMe,
                                isDark: isDark,
                                onVisitTap: () {
                                  if (note.visitId != null) {
                                    context.push('/rep/visit/${note.visitId}');
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      ),
              ),
              _buildInputArea(isDark),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading chat: $err')),
      ),
    );
  }

  Widget _buildDateHeader(DateTime date, bool isDark) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E232D) : const Color(0xFFFFF5C4),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 1)),
          ],
        ),
        child: Text(
          DateFormat('dd MMMM yyyy').format(date),
          style: AppTextStyles.labelSm.copyWith(
            color: isDark ? Colors.white70 : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF21262D) : const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _msgController,
                  style: AppTextStyles.bodyMd.copyWith(color: isDark ? Colors.white : Colors.black87),
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: AppStrings.lbl_50,
                    hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant.withValues(alpha: 0.6)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    border: InputBorder.none,
                  ),
                  onChanged: (val) {
                    setState(() {});
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: _msgController.text.trim().isNotEmpty
                    ? AppColors.primary 
                    : AppColors.onSurfaceVariant.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: _isSending
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      onPressed: (_msgController.text.trim().isNotEmpty && !_isSending)
                          ? _sendMessage
                          : null,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final NoteModel note;
  final bool isMe;
  final bool isDark;
  final VoidCallback onVisitTap;

  const ChatBubble({
    super.key,
    required this.note,
    required this.isMe,
    required this.isDark,
    required this.onVisitTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isMe
        ? (isDark ? const Color(0xFF005C4B) : const Color(0xFFE7FFDB))
        : (isDark ? const Color(0xFF1E232D) : Colors.white);
        
    final textColor = isMe
        ? (isDark ? Colors.white : Colors.black87)
        : (isDark ? Colors.white : Colors.black87);
        
    final timeColor = isMe
        ? (isDark ? Colors.white70 : Colors.black54)
        : (isDark ? Colors.white70 : Colors.black54);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
                    bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (note.visitId != null)
                        GestureDetector(
                          onTap: onVisitTap,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.04),
                              border: Border(
                                bottom: BorderSide(
                                  color: isDark ? Colors.white12 : Colors.black12,
                                  width: 1,
                                ),
                                right: BorderSide(
                                  color: AppColors.primary,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(Icons.storefront_rounded, size: 18, color: AppColors.primary),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Visit Note',
                                        style: AppTextStyles.labelMd.copyWith(color: textColor, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Tap to view visit',
                                        style: AppTextStyles.labelSm.copyWith(color: timeColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, size: 14, color: timeColor),
                              ],
                            ),
                          ),
                        ),
                        
                      Padding(
                        padding: EdgeInsets.fromLTRB(12, isMe ? 10 : 10, 12, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                note.content,
                                style: AppTextStyles.bodyMd.copyWith(
                                  color: textColor,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    DateFormat('HH:mm').format(note.createdAt),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: timeColor,
                                    ),
                                  ),
                                  if (isMe) ...[
                                    const SizedBox(width: 4),
                                    if (note.id.startsWith('temp_'))
                                      Icon(
                                        Icons.schedule_rounded,
                                        size: 12,
                                        color: timeColor,
                                      )
                                    else
                                      Icon(
                                        Icons.check_rounded, // Sent to server
                                        size: 14,
                                        color: timeColor, 
                                      ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
