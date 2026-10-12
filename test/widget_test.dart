import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:th5_2324801030035/main.dart';
import 'package:th5_2324801030035/models/note.dart';
import 'package:th5_2324801030035/services/note_storage.dart';

void main() {
  testWidgets('Màn hình chính hiển thị đúng', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(storage: TestNoteStorage()));
    await tester.pumpAndSettle();

    expect(find.text('Ghi chú của tôi'), findsOneWidget);
    expect(find.text('Chưa có ghi chú'), findsOneWidget);
    expect(
      find.widgetWithText(FloatingActionButton, 'Thêm ghi chú'),
      findsOneWidget,
    );
  });
}

// Dữ liệu rỗng để kiểm tra giao diện, không đọc ghi chú trên thiết bị.
class TestNoteStorage extends NoteStorage {
  @override
  Future<List<Note>> loadNotes() async => [];
}
