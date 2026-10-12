import 'package:flutter/material.dart';

import '../models/note.dart';
import '../theme/app_theme.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onActions,
  });

  final Note note;
  final VoidCallback? onTap;
  final VoidCallback? onActions;

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    String twoDigits(int number) => number.toString().padLeft(2, '0');
    return '${twoDigits(local.day)}/${twoDigits(local.month)}/${local.year} '
        '${twoDigits(local.hour)}:${twoDigits(local.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final color = NotePalette.of(note.colorIndex);
    return Material(
      color: color.background,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onActions,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 12, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.notes_rounded, size: 22, color: color.accent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Tùy chọn ghi chú',
                    onPressed: onActions,
                    color: color.accent,
                    icon: const Icon(Icons.more_horiz_rounded),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  note.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(height: 1.6, color: AppColors.ink),
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                children: [
                  Icon(Icons.schedule_rounded, size: 15, color: color.accent),
                  Text(
                    'Tạo lúc: ${_formatDate(note.createdAt)}',
                    style: TextStyle(fontSize: 12, color: color.accent),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _deleteColor = Color(0xFFB34B67);
const _deleteSoft = Color(0xFFFBEFF3);

class NoteActionsSheet extends StatelessWidget {
  const NoteActionsSheet({
    super.key,
    required this.note,
    required this.onDeleteRequested,
    required this.onCancel,
  });

  final Note note;
  final VoidCallback onDeleteRequested;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Thao tác ghi chú',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Ghi chú bạn đang chọn',
              style: TextStyle(color: AppColors.muted, height: 1.5),
            ),
            const SizedBox(height: 20),
            _SelectedNotePreview(note: note),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onDeleteRequested,
              style: _deleteStyle(20),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_outline_rounded, size: 22),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text('Xóa ghi chú', textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onCancel,
              style: _cancelStyle(),
              child: const Text('Hủy'),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteNoteDialog extends StatelessWidget {
  const DeleteNoteDialog({
    super.key,
    required this.note,
    required this.onCancel,
    required this.onConfirm,
  });

  final Note note;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      constraints: const BoxConstraints(maxWidth: 420),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      iconPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      titlePadding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      scrollable: true,
      icon: Center(
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: _deleteSoft,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.delete_outline_rounded,
            size: 28,
            color: _deleteColor,
          ),
        ),
      ),
      title: const Text(
        'Xóa ghi chú?',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SelectedNotePreview(note: note),
            const SizedBox(height: 18),
            const Text(
              'Ghi chú này sẽ bị xóa và không thể khôi phục. Bạn chắc chắn chứ?',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, height: 1.55),
            ),
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: _cancelStyle(),
                  child: const Text('Hủy', textAlign: TextAlign.center),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: onConfirm,
                  style: _deleteStyle(12),
                  child: const Text('Xóa', textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

ButtonStyle _deleteStyle(double horizontalPadding) {
  return FilledButton.styleFrom(
    backgroundColor: _deleteColor,
    foregroundColor: Colors.white,
    minimumSize: const Size.fromHeight(52),
    padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}

ButtonStyle _cancelStyle() {
  return OutlinedButton.styleFrom(
    foregroundColor: AppColors.ink,
    side: const BorderSide(color: AppColors.outline),
    minimumSize: const Size.fromHeight(52),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );
}

class _SelectedNotePreview extends StatelessWidget {
  const _SelectedNotePreview({required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    final color = NotePalette.of(note.colorIndex);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.accent.withAlpha(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.notes_rounded, size: 21, color: color.accent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  note.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            note.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.muted, height: 1.5),
          ),
        ],
      ),
    );
  }
}
