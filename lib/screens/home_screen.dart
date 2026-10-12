import 'package:flutter/material.dart';

import '../models/note.dart';
import '../services/note_storage.dart';
import '../theme/app_theme.dart';
import '../widgets/note_components.dart';
import '../widgets/note_banner.dart';
import 'note_editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.storage});

  final NoteStorage storage;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  List<Note> _notes = [];
  bool _isLoading = true;
  bool _loadFailed = false;
  bool _isBusy = false;

  List<Note> get _filteredNotes {
    final query = _searchController.text.trim().toLowerCase();
    return _notes.where((note) {
      return note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
      _loadFailed = false;
    });
    try {
      final notes = await widget.storage.loadNotes();
      notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      if (!mounted) return;
      setState(() => _notes = notes);
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadFailed = true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _persistNotes(List<Note> notes) async {
    await widget.storage.saveNotes(notes);
    if (!mounted) return;
    setState(() => _notes = notes);
  }

  Future<void> _saveNote(Note note) async {
    final updatedNotes = [..._notes];
    final index = updatedNotes.indexWhere((item) => item.id == note.id);
    if (index == -1) {
      updatedNotes.insert(0, note);
    } else {
      updatedNotes[index] = note;
    }
    await _persistNotes(updatedNotes);
  }

  Future<void> _openEditor([Note? note]) async {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => NoteEditorScreen(note: note, onSave: _saveNote),
      ),
    );
    if (!mounted) return;
    setState(() {
      _isBusy = false;
      if (saved == true && note == null) _searchController.clear();
    });
    if (saved == true) {
      _showMessage(note == null ? 'Đã thêm ghi chú.' : 'Đã cập nhật ghi chú.');
    }
  }

  Future<void> _showNoteActions(Note note) async {
    if (_isBusy) return;
    setState(() => _isBusy = true);
    try {
      final wantsDelete = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        clipBehavior: Clip.antiAlias,
        constraints: BoxConstraints(
          maxWidth: 520,
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        showDragHandle: true,
        builder: (sheetContext) => NoteActionsSheet(
          note: note,
          onDeleteRequested: () => Navigator.of(sheetContext).pop(true),
          onCancel: () => Navigator.of(sheetContext).pop(false),
        ),
      );
      if (wantsDelete != true || !mounted) return;

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => DeleteNoteDialog(
          note: note,
          onCancel: () => Navigator.of(dialogContext).pop(false),
          onConfirm: () => Navigator.of(dialogContext).pop(true),
        ),
      );
      if (confirmed != true || !mounted) return;

      final remainingNotes = _notes
          .where((item) => item.id != note.id)
          .toList();
      await _persistNotes(remainingNotes);
      if (mounted) _showMessage('Đã xóa ghi chú.');
    } catch (_) {
      if (mounted) _showMessage('Không thể xóa ghi chú. Hãy thử lại.');
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildStatus() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_loadFailed) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: AppColors.muted,
            ),
            const SizedBox(height: 16),
            const Text('Không thể tải ghi chú.'),
            const SizedBox(height: 12),
            FilledButton(onPressed: _loadNotes, child: const Text('Thử lại')),
          ],
        ),
      );
    }
    if (_notes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.note_add_outlined, size: 64, color: AppColors.primary),
              SizedBox(height: 16),
              Text(
                'Chưa có ghi chú',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 8),
              Text(
                'Nhấn “Thêm ghi chú” ở góc dưới bên phải để bắt đầu ghi chú đầu tiên của bạn.',
                style: TextStyle(color: AppColors.muted),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final visibleNotes = _filteredNotes;
    if (visibleNotes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded, size: 56, color: AppColors.muted),
              SizedBox(height: 16),
              Text(
                'Không tìm thấy ghi chú',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'Chưa có ghi chú nào khớp với từ khóa này.',
                style: TextStyle(color: AppColors.muted),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildBody() {
    final visibleNotes = _filteredNotes;
    if (_isLoading || _loadFailed || visibleNotes.isEmpty) {
      return SliverFillRemaining(hasScrollBody: false, child: _buildStatus());
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList.separated(
        itemCount: visibleNotes.length,
        separatorBuilder: (_, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final note = visibleNotes[index];
          return NoteCard(
            key: ValueKey(note.id),
            note: note,
            onTap: _isBusy ? null : () => _openEditor(note),
            onActions: _isBusy ? null : () => _showNoteActions(note),
          );
        },
      ),
    );
  }

  void _clearSearch() {
    setState(() => _searchController.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        toolbarHeight: 68,
        leadingWidth: 68,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 4, 16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.edit_note_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        title: const Text('My Notes'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                        child: const NoteBanner(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: _searchController,
                          enabled: !_isLoading && !_loadFailed && !_isBusy,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Tìm ghi chú của bạn...',
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: AppColors.muted,
                            ),
                            suffixIcon: _searchController.text.isEmpty
                                ? null
                                : IconButton(
                                    tooltip: 'Xóa tìm kiếm',
                                    onPressed: _clearSearch,
                                    icon: const Icon(Icons.close_rounded),
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            const Text(
                              'Tất cả ghi chú',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primarySoft,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${_notes.length}',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildBody(),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading || _loadFailed || _isBusy ? null : _openEditor,
        icon: const Icon(Icons.add),
        label: const Text('Thêm ghi chú'),
      ),
    );
  }
}
