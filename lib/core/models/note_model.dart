class NoteModel {
  final String id;
  final String senderId;
  final String? senderName;
  final String recipientId;
  final String? recipientName;
  final String? visitId;
  final String content;
  final DateTime createdAt;

  const NoteModel({
    required this.id,
    required this.senderId,
    this.senderName,
    required this.recipientId,
    this.recipientName,
    this.visitId,
    required this.content,
    required this.createdAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      senderName: json['sender_name'] as String?,
      recipientId: json['recipient_id'] as String,
      recipientName: json['recipient_name'] as String?,
      visitId: json['visit_id'] as String?,
      content: json['content'] as String,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
