// lib/features/habits/habits_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../theme/theme_extensions.dart';
import '../../shared/shared.dart';
import '../../domain/entities/habit.dart';
import '../../data/providers/habit_provider.dart';

class HabitsScreen extends ConsumerStatefulWidget {
  const HabitsScreen({super.key});

  @override
  ConsumerState<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends ConsumerState<HabitsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();

  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isSearching = false;

  final List<String> _categories = [
    'All',
    'Health',
    'Fitness',
    'Productivity',
    'Learning',
    'Mindfulness',
    'Social',
    'Creative',
    'Other'
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<BitoColorScheme>()!;
    final habitsAsync = ref.watch(habitsProvider);
    final completionStates = ref.watch(habitCompletionProvider);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        title: _isSearching
            ? Container(
          height: 40,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.line),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase().trim();
              });
            },
            style: TextStyle(
              fontSize: 14,
              color: colors.ink,
            ),
            decoration: InputDecoration(
              hintText: 'Search habits...',
              hintStyle: TextStyle(
                color: colors.ink3,
                fontSize: 14,
              ),
              prefixIcon: Icon(
                PhosphorIcons.magnifyingGlass(),
                size: 18,
                color: colors.ink3,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _searchController.clear();
                  });
                },
                icon: Icon(
                  PhosphorIcons.x(),
                  size: 16,
                  color: colors.ink3,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
        )
            : Text(
          'Habits',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: colors.ink,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: colors.bg,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: Icon(
            PhosphorIcons.arrowLeft(),
            size: 20,
            color: colors.ink,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                  _searchController.clear();
                  _searchFocusNode.unfocus();
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _searchFocusNode.requestFocus();
                  });
                }
              });
            },
            icon: Icon(
              _isSearching ? PhosphorIcons.x() : PhosphorIcons.magnifyingGlass(),
              color: _isSearching ? colors.ink : colors.ink2,
            ),
          ),
        ],
      ),
      body: habitsAsync.when(
        data: (habits) {
          if (completionStates.isEmpty && habits.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(habitCompletionProvider.notifier).setInitialStates(habits);
            });
          }

          final filteredHabits = _filterHabits(habits);
          final groupedHabits = _groupHabitsByCategory(filteredHabits);

          return Column(
            children: [
              if (!_isSearching) ...[
                _buildCategoryChips(colors),
              ],
              Expanded(
                child: groupedHabits.isEmpty
                    ? _buildEmptyState(context, colors)
                    : _buildHabitsList(context, colors, groupedHabits),
              ),
            ],
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error loading habits: $error',
            style: TextStyle(color: colors.error),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/habits/create/step1'),
        backgroundColor: colors.signal2,
        child: Icon(
          PhosphorIcons.plus(),
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildCategoryChips(BitoColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final category = _categories[index];
            final isSelected = category == _selectedCategory;

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (_selectedCategory == category) {
                    _selectedCategory = 'All';
                  } else {
                    _selectedCategory = category;
                    _scrollToCategory(category);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? colors.signal : colors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? colors.signal : colors.line,
                  ),
                ),
                child: Center(
                  child: Text(
                    category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? colors.signalInk : colors.ink2,
                      letterSpacing: 0.5,
                      fontFamily: 'SpaceMono',
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _scrollToCategory(String category) {
    if (category == 'All') {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    final habitsAsync = ref.read(habitsProvider);
    habitsAsync.whenData((habits) {
      final filtered = _filterHabits(habits);
      final index = filtered.indexWhere(
            (habit) => habit.category == category,
      );

      if (index != -1 && mounted) {
        final scrollPosition = (index * 80.0).clamp(0.0, _scrollController.position.maxScrollExtent);
        _scrollController.animateTo(
          scrollPosition,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  List<Habit> _filterHabits(List<Habit> habits) {
    var filtered = habits;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((habit) {
        final nameMatch = habit.name.toLowerCase().contains(_searchQuery);
        final descMatch = habit.description?.toLowerCase().contains(_searchQuery) ?? false;
        return nameMatch || descMatch;
      }).toList();
    }

    return filtered;
  }

  Map<String, List<Habit>> _groupHabitsByCategory(List<Habit> habits) {
    final Map<String, List<Habit>> grouped = {};
    final categories = ['Health', 'Fitness', 'Productivity', 'Learning', 'Mindfulness', 'Social', 'Creative', 'Other'];

    for (final category in categories) {
      grouped[category] = [];
    }

    for (final habit in habits) {
      final category = habit.category ?? 'Other';
      if (!grouped.containsKey(category)) {
        grouped[category] = [];
      }
      grouped[category]!.add(habit);
    }

    grouped.removeWhere((key, value) => value.isEmpty);
    return grouped;
  }

  Widget _buildHabitsList(
      BuildContext context,
      BitoColorScheme colors,
      Map<String, List<Habit>> groupedHabits,
      ) {
    final completionStates = ref.watch(habitCompletionProvider);

    if (_isSearching || _searchQuery.isNotEmpty) {
      final allHabits = groupedHabits.values.expand((list) => list).toList();
      if (allHabits.isEmpty) {
        return _buildEmptySearchState(colors);
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: allHabits.length,
        itemBuilder: (context, index) {
          final habit = allHabits[index];
          final isCompleted = completionStates[habit.id] ?? habit.isCompleted;
          return _buildHabitCard(context, colors, habit, isCompleted);
        },
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: groupedHabits.keys.length,
      itemBuilder: (context, index) {
        final category = groupedHabits.keys.elementAt(index);
        final habits = groupedHabits[category]!;
        final isSelected = category == _selectedCategory;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? colors.signal : colors.line,
                    width: isSelected ? 2 : 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (isSelected)
                    Container(
                      width: 3,
                      height: 16,
                      color: colors.signal,
                    ),
                  if (isSelected) const SizedBox(width: 8),
                  Text(
                    category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? colors.signal : colors.ink3,
                      letterSpacing: 0.5,
                      fontFamily: 'SpaceMono',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.line2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${habits.length}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: colors.ink3,
                      ),
                    ),
                  ),
                  if (isSelected) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colors.signal.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'SCROLLING TO',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: colors.signal,
                          letterSpacing: 0.5,
                          fontFamily: 'SpaceMono',
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
            ...habits.map((habit) {
              final isCompleted = completionStates[habit.id] ?? habit.isCompleted;
              return _buildHabitCard(
                context,
                colors,
                habit,
                isCompleted,
                isHighlighted: isSelected && habit.category == _selectedCategory,
              );
            }).toList(),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildHabitCard(
      BuildContext context,
      BitoColorScheme colors,
      Habit habit,
      bool isCompleted, {
        bool isHighlighted = false,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted ? colors.signal : colors.line,
          width: isHighlighted ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: () async {
            await ref.read(habitCompletionProvider.notifier).toggleHabit(habit.id);
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted ? colors.signal : colors.line2,
                width: 2,
              ),
              color: isCompleted ? colors.signal : Colors.transparent,
            ),
            child: isCompleted
                ? Icon(Icons.check, size: 16, color: colors.signalInk)
                : null,
          ),
        ),
        title: Text(
          habit.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isCompleted ? colors.ink3 : colors.ink,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          '${_getBlockLabel(habit.block)} • ${_getCadenceLabel(habit.cadence)}',
          style: TextStyle(
            fontSize: 12,
            color: colors.ink3,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (habit.streak > 0)
              Row(
                children: [
                  Icon(
                    PhosphorIcons.fire(),
                    size: 16,
                    color: Colors.orange[400],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    habit.streak.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.ink2,
                    ),
                  ),
                ],
              ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                context.go('/habits/${habit.id}/edit');
              },
              icon: Icon(
                PhosphorIcons.pencil(),
                size: 16,
                color: colors.ink3,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        onTap: () async {
          await ref.read(habitCompletionProvider.notifier).toggleHabit(habit.id);
        },
      ),
    );
  }

  // Custom empty state WITHOUT action button (uses FAB instead)
  Widget _buildEmptyState(BuildContext context, BitoColorScheme colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colors.surface2,
              shape: BoxShape.circle,
            ),
            child: Icon(
              PhosphorIcons.plusCircle(),
              size: 40,
              color: colors.ink3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No habits yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: colors.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start building your routine by adding your first habit.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: colors.ink2,
            ),
          ),
        ],
      ),
    );
  }

  // Search empty state WITHOUT action button
  Widget _buildEmptySearchState(BitoColorScheme colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.magnifyingGlass(),
            size: 48,
            color: colors.ink3,
          ),
          const SizedBox(height: 16),
          Text(
            'No habits found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search',
            style: TextStyle(
              fontSize: 14,
              color: colors.ink2,
            ),
          ),
        ],
      ),
    );
  }

  String _getBlockLabel(HabitTimeBlock block) {
    switch (block) {
      case HabitTimeBlock.morning:
        return 'MORNING';
      case HabitTimeBlock.afternoon:
        return 'AFTERNOON';
      case HabitTimeBlock.evening:
        return 'EVENING';
    }
  }

  String _getCadenceLabel(HabitCadence cadence) {
    switch (cadence) {
      case HabitCadence.daily:
        return 'DAILY';
      case HabitCadence.weekly:
        return 'WEEKLY';
    }
  }
}