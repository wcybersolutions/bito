// lib/features/journal/create_journal_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:bito/shared/shared.dart';
import 'package:bito/data/journal/journal_entry.dart';
import 'package:bito/data/journal/journal_provider.dart';
import 'package:bito/features/journal/widgets/mood_selector.dart';
import 'package:bito/features/journal/widgets/energy_selector.dart';
import 'package:bito/features/journal/widgets/journal_text_controller.dart';

class CreateJournalScreen extends ConsumerStatefulWidget {
  final String? entryId;

  const CreateJournalScreen({
    super.key,
    this.entryId,
  });

  @override
  ConsumerState<CreateJournalScreen> createState() => _CreateJournalScreenState();
}

class _CreateJournalScreenState extends ConsumerState<CreateJournalScreen> {
  late JournalTextEditingController _editorController;
  final Debouncer _autoSaveDebouncer = Debouncer(delay: const Duration(milliseconds: 800));

  String _entryId = '';
  DateTime _entryDate = DateTime.now();
  int? _selectedMood;
  int? _selectedEnergy;
  List<QuickLog> _quickLogs = [];
  String _saveStatus = 'READY'; // READY, SAVING..., SAVED
  Timer? _savedStatusTimer;
  bool _showBlockMenu = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _entryId = widget.entryId ?? DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _editorController = JournalTextEditingController(context: context);
      _editorController.addListener(_onTextChanged);
      _loadInitialEntry();
      _isInitialized = true;
    }
  }

  Future<void> _loadInitialEntry() async {
    try {
      final repository = ref.read(journalRepositoryProvider);
      final entries = await repository.getEntries();

      JournalEntry? existing;
      if (widget.entryId != null && widget.entryId!.isNotEmpty) {
        existing = entries.where((e) => e.id == widget.entryId).firstOrNull;
      } else {
        // Look for today's entry
        final now = DateTime.now();
        existing = entries.where((e) =>
            e.date.year == now.year &&
            e.date.month == now.month &&
            e.date.day == now.day).firstOrNull;
      }

      if (existing != null && mounted) {
        setState(() {
          _entryId = existing!.id;
          _entryDate = existing.date;
          _selectedMood = existing.mood != null ? JournalMood.values.indexOf(existing.mood!) : null;
          _selectedEnergy = existing.energy;
          _quickLogs = List.from(existing.quickLogs);
          _editorController.text = existing.longFormContent;
        });
      }
    } catch (_) {
      // If error or no entry, start fresh draft
    }
  }

  void _onTextChanged() {
    // Check for slash command "/"
    final text = _editorController.text;
    final sel = _editorController.selection;
    if (sel.isValid && sel.isCollapsed && sel.start > 0) {
      final charBefore = text.substring(sel.start - 1, sel.start);
      if (charBefore == '/') {
        final isLineStartOrSpaced = sel.start == 1 || text[sel.start - 2] == '\n' || text[sel.start - 2] == ' ';
        if (isLineStartOrSpaced && !_showBlockMenu) {
          setState(() {
            _showBlockMenu = true;
          });
        }
      }
    }

    _triggerAutoSave();
  }

  void _triggerAutoSave() {
    if (_saveStatus != 'SAVING...') {
      setState(() {
        _saveStatus = 'SAVING...';
      });
    }

    _autoSaveDebouncer.run(() {
      _performSave();
    });
  }

  Future<void> _performSave() async {
    if (!mounted) return;

    try {
      final repository = ref.read(journalRepositoryProvider);
      final content = _editorController.text;

      JournalMood? mood;
      if (_selectedMood != null && _selectedMood! >= 0 && _selectedMood! < JournalMood.values.length) {
        mood = JournalMood.values[_selectedMood!];
      }

      final entry = JournalEntry(
        id: _entryId,
        date: _entryDate,
        mood: mood,
        energy: _selectedEnergy,
        quickLogs: _quickLogs,
        longFormContent: content,
      );

      // Check if entry exists
      final entries = await repository.getEntries();
      final exists = entries.any((e) => e.id == _entryId);

      if (exists) {
        await repository.updateEntry(entry);
      } else {
        await repository.addEntry(entry);
      }

      // Refresh providers so ledger and stats stay up to date
      ref.invalidate(journalEntriesProvider);
      ref.invalidate(journalStatsProvider);

      if (mounted) {
        setState(() {
          _saveStatus = 'SAVED';
        });

        _savedStatusTimer?.cancel();
        _savedStatusTimer = Timer(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _saveStatus = 'READY';
            });
          }
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _saveStatus = 'READY';
        });
      }
    }
  }

  @override
  void dispose() {
    _savedStatusTimer?.cancel();
    _autoSaveDebouncer.dispose();
    _editorController.removeListener(_onTextChanged);
    _editorController.dispose();
    super.dispose();
  }

  int get _wordCount {
    final text = _editorController.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).length;
  }

  int get _readTimeMinutes {
    return (_wordCount / 200).ceil().clamp(1, 999);
  }

  void _handleBlockCommand(String type) {
    // Remove the triggering '/' if present right before cursor
    final text = _editorController.text;
    final sel = _editorController.selection;
    if (sel.isValid && sel.isCollapsed && sel.start > 0) {
      final beforeCursor = text.substring(0, sel.start);
      if (beforeCursor.endsWith('/')) {
        _editorController.value = TextEditingValue(
          text: text.substring(0, sel.start - 1) + text.substring(sel.start),
          selection: TextSelection.collapsed(offset: sel.start - 1),
        );
      }
    }

    setState(() {
      _showBlockMenu = false;
    });

    switch (type) {
      case 'Heading 1':
        _editorController.applyLinePrefix('# ');
        break;
      case 'Heading 2':
        _editorController.applyLinePrefix('## ');
        break;
      case 'Heading 3':
        _editorController.applyLinePrefix('### ');
        break;
      case 'Heading 4':
        _editorController.applyLinePrefix('#### ');
        break;
      case 'Quote':
        _editorController.applyLinePrefix('> ');
        break;
      case 'Toggle list':
        _editorController.applyLinePrefix('- [ ] ');
        break;
      case 'Numbered list':
        _editorController.applyLinePrefix('1. ');
        break;
      case 'Bulleted list':
        _editorController.applyLinePrefix('- ');
        break;
      case 'Table':
        _editorController.insertBlock(
          '\n| Category | Goal | Status |\n| --- | --- | --- |\n| Focus | 4 hours | In Progress |\n',
        );
        break;
      case 'Image':
        _showImageInsertDialog();
        break;
      case 'Emojis':
        _showEmojiPicker();
        break;
      case 'Mention':
        _editorController.insertBlock('@');
        break;
      case 'Date':
        final nowFormatted = DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());
        _editorController.insertBlock('[Date: $nowFormatted] ');
        break;
    }
  }

  void _showImageInsertDialog() {
    final textController = TextEditingController();
    final urlController = TextEditingController(text: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb');
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(
          'INSERT MEDIA',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: colors.ink3,
            letterSpacing: 1.0,
            fontFamily: 'SpaceMono',
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'Caption/Alt Text',
                labelStyle: TextStyle(color: colors.ink3, fontSize: 12),
                hintText: 'Morning mountain reflection',
                hintStyle: TextStyle(color: colors.ink3.withOpacity(0.5), fontSize: 12),
              ),
              style: TextStyle(color: colors.ink),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: 'Image URL',
                labelStyle: TextStyle(color: colors.ink3, fontSize: 12),
              ),
              style: TextStyle(color: colors.ink),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL', style: TextStyle(color: colors.ink3, fontFamily: 'SpaceMono')),
          ),
          ElevatedButton(
            onPressed: () {
              final alt = textController.text.trim().isEmpty ? 'Image' : textController.text.trim();
              final url = urlController.text.trim();
              _editorController.insertBlock('\n![$alt]($url)\n');
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: colors.signal),
            child: const Text('INSERT', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'SpaceMono')),
          ),
        ],
      ),
    );
  }

  void _showEmojiPicker() {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final emojis = [
      '✨', '🔥', '💡', '🎯', '🏃‍♂️', '☕', '🧘', '❤️', '📝', '⚡',
      '🌱', '🚀', '🧠', '💪', '🏆', '⭐', '🌟', '🎉', '📚', '🎨',
      '🌿', '🌊', '☀️', '🌙', '🕊️', '🔋', '💎', '🔑', '🌈', '👏'
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'INSERT EMOJI',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: colors.ink3,
                letterSpacing: 1.0,
                fontFamily: 'SpaceMono',
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: emojis.map((emoji) {
                return InkWell(
                  onTap: () {
                    _editorController.insertBlock('$emoji ');
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.surface2,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colors.line),
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 20)),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickThoughtDialog() {
    final thoughtController = TextEditingController();
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ADD QUICK THOUGHT',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: colors.ink3,
                    letterSpacing: 1.0,
                    fontFamily: 'SpaceMono',
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(PhosphorIcons.x(), size: 16, color: colors.ink3),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: thoughtController,
              autofocus: true,
              maxLines: 3,
              style: TextStyle(color: colors.ink, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'What\'s on your mind right now?',
                hintStyle: TextStyle(color: colors.ink3, fontStyle: FontStyle.italic),
                filled: true,
                fillColor: colors.bg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.line),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.line),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: colors.signal),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  final text = thoughtController.text.trim();
                  if (text.isNotEmpty) {
                    final newLog = QuickLog(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      timestamp: DateTime.now(),
                      content: text,
                    );
                    setState(() {
                      _quickLogs.insert(0, newLog);
                    });
                    _triggerAutoSave();
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.signal,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                icon: Icon(PhosphorIcons.paperPlaneRight(), size: 14),
                label: const Text(
                  'LOG THOUGHT',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    fontFamily: 'SpaceMono',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFormatOptions(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TEXT FORMATTING',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: colors.ink3,
                  letterSpacing: 1.0,
                  fontFamily: 'SpaceMono',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFormatButton(Icons.format_bold, 'Bold', colors, () {
                    _editorController.applyInlineFormat(prefix: '**', suffix: '**');
                    Navigator.pop(context);
                  }),
                  _buildFormatButton(Icons.format_italic, 'Italic', colors, () {
                    _editorController.applyInlineFormat(prefix: '*', suffix: '*');
                    Navigator.pop(context);
                  }),
                  _buildFormatButton(Icons.format_underline, 'Underline', colors, () {
                    _editorController.applyInlineFormat(prefix: '<u>', suffix: '</u>');
                    Navigator.pop(context);
                  }),
                  _buildFormatButton(Icons.format_strikethrough, 'Strike', colors, () {
                    _editorController.applyInlineFormat(prefix: '~~', suffix: '~~');
                    Navigator.pop(context);
                  }),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFormatButton(Icons.highlight, 'Highlight', colors, () {
                    _editorController.applyInlineFormat(prefix: '==', suffix: '==');
                    Navigator.pop(context);
                  }),
                  _buildFormatButton(Icons.format_list_bulleted, 'List', colors, () {
                    _editorController.applyLinePrefix('- ');
                    Navigator.pop(context);
                  }),
                  _buildFormatButton(Icons.format_list_numbered, 'Numbered', colors, () {
                    _editorController.applyLinePrefix('1. ');
                    Navigator.pop(context);
                  }),
                  _buildFormatButton(Icons.format_quote, 'Quote', colors, () {
                    _editorController.applyLinePrefix('> ');
                    Navigator.pop(context);
                  }),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'TEXT COLOR',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: colors.ink3,
                  letterSpacing: 0.8,
                  fontFamily: 'SpaceMono',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildColorButton(colors.ink, 'Ink', colors, () {
                    _editorController.applyInlineFormat(prefix: '[color:ink]', suffix: '[/color]');
                    Navigator.pop(context);
                  }),
                  _buildColorButton(Colors.redAccent, 'Red', colors, () {
                    _editorController.applyInlineFormat(prefix: '[color:red]', suffix: '[/color]');
                    Navigator.pop(context);
                  }),
                  _buildColorButton(Colors.lightBlueAccent, 'Blue', colors, () {
                    _editorController.applyInlineFormat(prefix: '[color:blue]', suffix: '[/color]');
                    Navigator.pop(context);
                  }),
                  _buildColorButton(Colors.greenAccent, 'Green', colors, () {
                    _editorController.applyInlineFormat(prefix: '[color:green]', suffix: '[/color]');
                    Navigator.pop(context);
                  }),
                  _buildColorButton(colors.signal, 'Signal', colors, () {
                    _editorController.applyInlineFormat(prefix: '[color:signal]', suffix: '[/color]');
                    Navigator.pop(context);
                  }),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'HIGHLIGHT COLOR',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: colors.ink3,
                  letterSpacing: 0.8,
                  fontFamily: 'SpaceMono',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildColorButton(Colors.yellow.withOpacity(0.5), 'Yellow', colors, () {
                    _editorController.applyInlineFormat(prefix: '[bg:yellow]', suffix: '[/bg]');
                    Navigator.pop(context);
                  }),
                  _buildColorButton(Colors.grey.withOpacity(0.5), 'Gray', colors, () {
                    _editorController.applyInlineFormat(prefix: '[bg:gray]', suffix: '[/bg]');
                    Navigator.pop(context);
                  }),
                  _buildColorButton(Colors.red.withOpacity(0.4), 'Red', colors, () {
                    _editorController.applyInlineFormat(prefix: '[bg:red]', suffix: '[/bg]');
                    Navigator.pop(context);
                  }),
                  _buildColorButton(Colors.green.withOpacity(0.4), 'Green', colors, () {
                    _editorController.applyInlineFormat(prefix: '[bg:green]', suffix: '[/bg]');
                    Navigator.pop(context);
                  }),
                  _buildFormatButton(Icons.format_clear, 'Clear', colors, () {
                    _clearFormatting();
                    Navigator.pop(context);
                  }),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _clearFormatting() {
    final text = _editorController.text;
    final sel = _editorController.selection;
    if (sel.isValid && !sel.isCollapsed) {
      var selected = text.substring(sel.start, sel.end);
      selected = selected.replaceAll(RegExp(r'\*\*|\*|<u>|<\/u>|~~|==|\[color:[^\]]+\]|\[\/color\]|\[bg:[^\]]+\]|\[\/bg\]'), '');
      _editorController.value = TextEditingValue(
        text: text.substring(0, sel.start) + selected + text.substring(sel.end),
        selection: TextSelection(baseOffset: sel.start, extentOffset: sel.start + selected.length),
      );
    }
  }

  Widget _buildFormatButton(IconData icon, String label, BitoColorScheme colors, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(icon, color: colors.ink, size: 20),
          style: IconButton.styleFrom(
            backgroundColor: colors.surface2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: colors.line),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            color: colors.ink3,
            fontFamily: 'SpaceMono',
          ),
        ),
      ],
    );
  }

  Widget _buildColorButton(Color color, String label, BitoColorScheme colors, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: colors.line, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            color: colors.ink3,
            fontFamily: 'SpaceMono',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;
    final now = _entryDate;
    final dayName = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][now.weekday % 7];
    final dayNumber = now.day;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation & Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _performSave();
                          context.go('/journal');
                        },
                        icon: Icon(
                          PhosphorIcons.arrowLeft(),
                          size: 20,
                          color: colors.ink,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Journal',
                        style: textTheme.headlineSmall?.copyWith(
                          color: colors.ink,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      _performSave();
                      context.go('/journal/intelligence');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: colors.signal,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          PhosphorIcons.lock(),
                          size: 12,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'INTELLIGENCE',
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            letterSpacing: 0.5,
                            fontFamily: 'SpaceMono',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Stats row (Word count & logs)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '$_wordCount WORDS • ${_quickLogs.length} QUICK NOTES • $_readTimeMinutes MIN READ',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: colors.ink3,
                  letterSpacing: 0.5,
                  fontFamily: 'SpaceMono',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Date & Mood / Energy Selectors
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${dayName.toUpperCase()}, $dayNumber',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: colors.ink3,
                            letterSpacing: 0.5,
                            fontFamily: 'SpaceMono',
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Today',
                          style: textTheme.headlineSmall?.copyWith(
                            color: colors.ink,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            'MOOD',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: colors.ink3,
                              letterSpacing: 0.8,
                              fontFamily: 'SpaceMono',
                            ),
                          ),
                          const SizedBox(width: 8),
                          MoodSelector(
                            selectedMood: _selectedMood,
                            onSelect: (index) {
                              setState(() {
                                _selectedMood = index;
                              });
                              _triggerAutoSave();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'ENERGY',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: colors.ink3,
                              letterSpacing: 0.8,
                              fontFamily: 'SpaceMono',
                            ),
                          ),
                          const SizedBox(width: 8),
                          EnergySelector(
                            selectedEnergy: _selectedEnergy,
                            onSelect: (index) {
                              setState(() {
                                _selectedEnergy = index;
                              });
                              _triggerAutoSave();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick thought bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: _showQuickThoughtDialog,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.line),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        PhosphorIcons.pencil(),
                        size: 16,
                        color: colors.signal,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Quick thought...',
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.ink3,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _quickLogs.isNotEmpty ? '${_quickLogs.length} notes' : '',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.ink3,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        PhosphorIcons.plus(),
                        size: 16,
                        color: colors.signal,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Quick Logs List (if any)
            if (_quickLogs.isNotEmpty) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _quickLogs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final log = _quickLogs[index];
                      final timeStr = DateFormat('h:mm a').format(log.timestamp);
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.surface2,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: colors.line),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'LOG ${index + 1} ($timeStr): ',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: colors.signal2,
                                fontFamily: 'SpaceMono',
                              ),
                            ),
                            Text(
                              log.content.length > 20 ? '${log.content.substring(0, 18)}...' : log.content,
                              style: TextStyle(
                                fontSize: 11,
                                color: colors.ink,
                              ),
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _quickLogs.removeAt(index);
                                });
                                _triggerAutoSave();
                              },
                              child: Icon(PhosphorIcons.x(), size: 10, color: colors.ink3),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),

            // Editor with block menu & formatting buttons
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.line),
                    ),
                    child: TextField(
                      controller: _editorController,
                      style: TextStyle(
                        fontSize: 15,
                        color: colors.ink,
                        height: 1.6,
                        fontFamily: 'SpaceMono',
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter text or type "/" for block commands\nUse formatting button for bold, italic, color...',
                        hintStyle: TextStyle(
                          color: colors.ink3.withOpacity(0.6),
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),

                  // Floating '+' Block menu button
                  Positioned(
                    bottom: 16,
                    right: 32,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showBlockMenu = !_showBlockMenu;
                        });
                      },
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: colors.signal,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          _showBlockMenu ? PhosphorIcons.x() : PhosphorIcons.plus(),
                          size: 22,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  // Six dots grid icon (Formatting options bottom sheet)
                  Positioned(
                    bottom: 16,
                    right: 84,
                    child: GestureDetector(
                      onTap: () => _showFormatOptions(context),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: colors.surface2,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.line),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          PhosphorIcons.dotsSix(),
                          size: 22,
                          color: colors.ink,
                        ),
                      ),
                    ),
                  ),

                  // Block menu overlay
                  if (_showBlockMenu)
                    Positioned(
                      bottom: 68,
                      right: 32,
                      child: Container(
                        width: 260,
                        constraints: const BoxConstraints(maxHeight: 340),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colors.line),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildMenuSection('Headings', [
                                'Heading 1',
                                'Heading 2',
                                'Heading 3',
                                'Heading 4',
                              ], colors),
                              _buildMenuSection('Basic blocks', [
                                'Quote',
                                'Toggle list',
                                'Numbered list',
                                'Bulleted list',
                              ], colors),
                              _buildMenuSection('Advanced', [
                                'Table',
                              ], colors),
                              _buildMenuSection('Media', [
                                'Image',
                              ], colors),
                              _buildMenuSection('Extras', [
                                'Emojis',
                                'Mention',
                                'Date',
                              ], colors),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Bottom Autosave Status Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: colors.line)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$_wordCount WORDS  •  ${_quickLogs.length} QUICK NOTES  •  $_readTimeMinutes MIN READ',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: colors.ink2,
                      fontFamily: 'SpaceMono',
                      letterSpacing: 0.8,
                    ),
                  ),
                  Row(
                    children: [
                      if (_saveStatus == 'SAVING...')
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: SizedBox(
                            width: 8,
                            height: 8,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: colors.signal,
                            ),
                          ),
                        )
                      else if (_saveStatus == 'SAVED')
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Icon(
                            PhosphorIcons.checkCircle(),
                            size: 10,
                            color: colors.signal2,
                          ),
                        ),
                      Text(
                        _saveStatus,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _saveStatus == 'SAVING...'
                              ? colors.signal
                              : (_saveStatus == 'SAVED' ? colors.signal2 : colors.ink3),
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(String title, List<String> items, BitoColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: colors.ink3,
              letterSpacing: 0.5,
              fontFamily: 'SpaceMono',
            ),
          ),
        ),
        ...items.map((item) => InkWell(
          onTap: () => _handleBlockCommand(item),
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: Text(
              item,
              style: TextStyle(
                fontSize: 13,
                color: colors.ink,
              ),
            ),
          ),
        )),
        const SizedBox(height: 6),
      ],
    );
  }
}
