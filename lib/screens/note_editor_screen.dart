import 'package:flutter/material.dart';

import '../models/note.dart';
import '../theme/app_theme.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key, this.note, required this.onSave});

  // null: thêm mới; có ghi chú: chỉnh sửa.
  final Note? note;
  final Future<void> Function(Note note) onSave;

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late int _colorIndex;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
    _colorIndex = widget.note?.colorIndex ?? 0;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);

    final now = DateTime.now();
    final note = Note(
      id: widget.note?.id ?? now.microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      createdAt: widget.note?.createdAt ?? now,
      colorIndex: _colorIndex,
    );

    try {
      await widget.onSave(note);
      if (!mounted) return;
      // Chỉ quay về màn hình chính sau khi lưu thành công.
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể lưu ghi chú. Hãy thử lại.')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteColor = NotePalette.of(_colorIndex);

    return PopScope(
      canPop: !_isSaving,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            widget.note == null ? 'Thêm ghi chú' : 'Chỉnh sửa ghi chú',
          ),
          leading: BackButton(
            onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(Icons.edit_note_rounded, color: noteColor.accent),
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                  children: [
                    Text(
                      widget.note == null
                          ? 'Thêm ghi chú mới'
                          : 'Chỉnh sửa ghi chú',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Nhập nội dung ghi chú của bạn',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Icon(
                          Icons.palette_outlined,
                          size: 18,
                          color: AppColors.muted,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Màu ghi chú',
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            noteColor.label,
                            textAlign: TextAlign.right,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: noteColor.accent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      children: [
                        for (
                          var index = 0;
                          index < NotePalette.colors.length;
                          index++
                        )
                          _ColorChoice(
                            key: ValueKey('note-color-$index'),
                            color: NotePalette.colors[index],
                            selected: index == _colorIndex,
                            onPressed: _isSaving
                                ? null
                                : () => setState(() => _colorIndex = index),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: noteColor.background,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: noteColor.accent.withAlpha(36),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildField(isTitle: true, accent: noteColor.accent),
                          const SizedBox(height: 20),
                          _buildField(isTitle: false, accent: noteColor.accent),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _isSaving ? null : _save,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check_rounded),
                      label: Text(_isSaving ? 'Đang lưu...' : 'Lưu ghi chú'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildField({required bool isTitle, required Color accent}) {
    final textTheme = Theme.of(context).textTheme;
    return TextFormField(
      controller: isTitle ? _titleController : _contentController,
      enabled: !_isSaving,
      textInputAction: isTitle ? TextInputAction.next : null,
      minLines: isTitle ? null : 7,
      maxLines: isTitle ? 1 : null,
      keyboardType: isTitle ? TextInputType.text : TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      style: isTitle
          ? textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.4,
            )
          : textTheme.bodyLarge?.copyWith(height: 1.65),
      decoration: _fieldDecoration(
        label: isTitle ? 'Tiêu đề' : 'Nội dung',
        hint: isTitle
            ? 'Ví dụ: Việc cần làm hôm nay'
            : 'Viết ghi chú của bạn ở đây...',
        accent: accent,
      ),
      validator: (value) => value == null || value.trim().isEmpty
          ? (isTitle ? 'Vui lòng nhập tiêu đề.' : 'Vui lòng nhập nội dung.')
          : null,
    );
  }

  InputDecoration _fieldDecoration({
    required String label,
    required String hint,
    required Color accent,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    );

    return InputDecoration(
      labelText: label,
      hintText: hint,
      alignLabelWithHint: true,
      filled: true,
      fillColor: Colors.white.withAlpha(190),
      contentPadding: const EdgeInsets.all(18),
      border: border,
      enabledBorder: border,
      disabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(color: accent, width: 1.5),
      ),
    );
  }
}

class _ColorChoice extends StatelessWidget {
  const _ColorChoice({
    super.key,
    required this.color,
    required this.selected,
    required this.onPressed,
  });

  final NoteColor color;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Màu ${color.label}',
      button: true,
      selected: selected,
      enabled: onPressed != null,
      child: Tooltip(
        message: 'Màu ${color.label}',
        excludeFromSemantics: true,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.background,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? color.accent : color.accent.withAlpha(70),
                  width: selected ? 2.5 : 1,
                ),
              ),
              child: selected
                  ? Icon(Icons.check_rounded, color: color.accent, size: 22)
                  : Center(
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: color.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
