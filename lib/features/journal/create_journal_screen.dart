// lib/features/journal/create_journal_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:bito/shared/shared.dart';
import 'package:bito/data/journal/journal_entry.dart';
import 'package:bito/data/journal/journal_provider.dart';
import 'package:bito/features/journal/widgets/mood_selector.dart';
import 'package:bito/features/journal/widgets/energy_selector.dart';

class CreateJournalScreen extends ConsumerStatefulWidget {
  const CreateJournalScreen({super.key});

  @override
  ConsumerState<CreateJournalScreen> createState() => _CreateJournalScreenState();
}

class _CreateJournalScreenState extends ConsumerState<CreateJournalScreen> {
  final TextEditingController _editorController = TextEditingController();
  final Debouncer _autoSaveDebouncer = Debouncer(delay: const Duration(milliseconds: 1000));

  int? _selectedMood;
  int? _selectedEnergy;
  bool _isSaving = false;
  List<String> _quickNotes = ["Morning run"];
  String _title = '';
  String _selectedType = 'Long-Form';
  bool _showBlockMenu = false;

  @override
  void initState() {
    super.initState();
    _editorController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _isSaving = true;
    });

    _autoSaveDebouncer.run(() {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _autoSaveDebouncer.dispose();
    _editorController.dispose();
    super.dispose();
  }

  int get _wordCount {
    final text = _editorController.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).length;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    final dayName = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][now.weekday % 7];
    final dayNumber = now.day;

    return Scaffold(
      backgroundColor: colors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.go('/journal'),
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
                          style: TextStyle(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '5 ENTRIES . 53 WORDS . 3 DAYS JOURNALED',
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
            // Quick thought bar - Clickable to navigate
            GestureDetector(
              onTap: () {
                // Navigate back to journal or keep writing
                context.go('/journal');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        color: colors.ink3,
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
                        _quickNotes.isNotEmpty ? '${_quickNotes.length} notes' : '',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.ink3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        PhosphorIcons.arrowRight(),
                        size: 16,
                        color: colors.ink3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Log section - Clickable to navigate
            GestureDetector(
              onTap: () {
                context.go('/journal');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.line2,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'LOG 1',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: colors.ink3,
                          letterSpacing: 0.5,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.line2,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: colors.ink3,
                          letterSpacing: 0.5,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _title.isEmpty ? 'Morning run' : _title,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.ink2,
                        ),
                      ),
                    ),
                    Icon(
                      PhosphorIcons.arrowRight(),
                      size: 16,
                      color: colors.ink3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Editor with block menu
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        left: BorderSide(color: colors.line),
                        bottom: BorderSide(color: colors.line),
                      ),
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
                        hintText: 'Enter text or type "/" for commands',
                        hintStyle: TextStyle(
                          color: colors.ink3,
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
                  // Floating + button
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
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colors.signal,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          PhosphorIcons.plus(),
                          size: 24,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  // Six dots grid icon
                  Positioned(
                    bottom: 16,
                    right: 80,
                    child: GestureDetector(
                      onTap: () {
                        // Show formatting options
                        _showFormatOptions(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colors.surface2,
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.line),
                        ),
                        child: Icon(
                          PhosphorIcons.dotsSix(),
                          size: 20,
                          color: colors.ink2,
                        ),
                      ),
                    ),
                  ),
                  // Block menu
                  if (_showBlockMenu)
                    Positioned(
                      bottom: 70,
                      right: 20,
                      child: Container(
                        width: 280,
                        height: 300,
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colors.line),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
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
                              _buildMenuSection('Sub-Heading', [
                                'Heading 1',
                                'Heading 2',
                                'Heading 3',
                              ], colors),
                              _buildMenuSection('Others', [
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: colors.line)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$_wordCount WORDS  •  ${_quickNotes.length} QUICK NOTE  •  1 MIN READ',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: colors.ink2,
                      fontFamily: 'SpaceMono',
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    _isSaving ? 'SAVING...' : 'READY',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _isSaving ? colors.signal : colors.signal2,
                      fontFamily: 'SpaceMono',
                    ),
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
        ...items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: GestureDetector(
            onTap: () {
              // Handle menu item selection
              setState(() {
                _showBlockMenu = false;
              });
            },
            child: Text(
              item,
              style: TextStyle(
                fontSize: 13,
                color: colors.ink2,
              ),
            ),
          ),
        )),
        const SizedBox(height: 8),
      ],
    );
  }

  void _showFormatOptions(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFormatOption(Icons.format_bold, 'Bold', colors),
                  _buildFormatOption(Icons.format_italic, 'Italic', colors),
                  _buildFormatOption(Icons.format_underline, 'Underline', colors),
                  _buildFormatOption(Icons.format_strikethrough, 'Strike', colors),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFormatOption(Icons.format_align_left, 'Left', colors),
                  _buildFormatOption(Icons.format_align_center, 'Center', colors),
                  _buildFormatOption(Icons.format_align_right, 'Right', colors),
                  _buildFormatOption(Icons.format_list_bulleted, 'List', colors),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildColorOption(Colors.black, 'Text', colors),
                  _buildColorOption(Colors.red, 'Red', colors),
                  _buildColorOption(Colors.blue, 'Blue', colors),
                  _buildColorOption(Colors.green, 'Green', colors),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildColorOption(Colors.yellow, 'Bg', colors),
                  _buildColorOption(Colors.grey, 'Gray', colors),
                  _buildFormatOption(Icons.delete_outline, 'Delete', colors),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormatOption(IconData icon, String label, BitoColorScheme colors) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(icon, color: colors.ink),
        ),
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

  Widget _buildColorOption(Color color, String label, BitoColorScheme colors) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: colors.line),
            ),
          ),
        ),
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

  Widget _buildTypeChip(String label, bool isSelected, BitoColorScheme colors) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colors.signal : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? colors.signal : colors.line,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isSelected ? colors.signalInk : colors.ink2,
            letterSpacing: 0.3,
            fontFamily: 'SpaceMono',
          ),
        ),
      ),
    );
  }
}

