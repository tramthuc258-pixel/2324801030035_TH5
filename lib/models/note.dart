/// Một ghi chú. [id] dùng để tìm đúng ghi chú khi sửa hoặc xóa.
class Note {
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.colorIndex = 0,
  });

  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final int colorIndex;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'colorIndex': colorIndex,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      // Ghi chú từ bản cũ chưa có màu vẫn đọc được bình thường.
      colorIndex: json['colorIndex'] as int? ?? 0,
    );
  }
}
