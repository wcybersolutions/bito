// lib/features/journal/widgets/journal_text_controller.dart
import 'package:flutter/material.dart';
import 'package:bito/theme/theme_extensions.dart';

/// A custom TextEditingController that parses and styles Markdown & formatting tokens
/// in real-time inside the journal TextField editor.
class JournalTextEditingController extends TextEditingController {
  final BuildContext context;

  JournalTextEditingController({
    required this.context,
    super.text,
  });

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final colors = Theme.of(context).extension<BitoColorScheme>();
    final baseColor = colors?.ink ?? Colors.white;
    final ink3 = colors?.ink3 ?? Colors.grey;
    final signal = colors?.signal ?? Colors.amber;
    final signal2 = colors?.signal2 ?? Colors.greenAccent;

    final defaultStyle = (style ?? const TextStyle()).copyWith(
      color: baseColor,
      fontSize: 15,
      height: 1.6,
      fontFamily: 'SpaceMono',
    );

    if (text.isEmpty) {
      return TextSpan(text: '', style: defaultStyle);
    }

    final spans = <InlineSpan>[];
    final lines = text.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final isLastLine = i == lines.length - 1;
      final lineEnding = isLastLine ? '' : '\n';

      // Check for Line-Level Block Styles
      if (line.startsWith('#### ')) {
        spans.add(TextSpan(
          text: '#### ',
          style: defaultStyle.copyWith(color: ink3, fontSize: 14, fontWeight: FontWeight.w700),
        ));
        spans.addAll(_parseInlineFormatting(line.substring(5), defaultStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: colors?.ink ?? Colors.white,
        ), colors));
        spans.add(TextSpan(text: lineEnding, style: defaultStyle));
      } else if (line.startsWith('### ')) {
        spans.add(TextSpan(
          text: '### ',
          style: defaultStyle.copyWith(color: ink3, fontSize: 16, fontWeight: FontWeight.w700),
        ));
        spans.addAll(_parseInlineFormatting(line.substring(4), defaultStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: colors?.ink ?? Colors.white,
        ), colors));
        spans.add(TextSpan(text: lineEnding, style: defaultStyle));
      } else if (line.startsWith('## ')) {
        spans.add(TextSpan(
          text: '## ',
          style: defaultStyle.copyWith(color: ink3, fontSize: 18, fontWeight: FontWeight.w700),
        ));
        spans.addAll(_parseInlineFormatting(line.substring(3), defaultStyle.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: colors?.ink ?? Colors.white,
        ), colors));
        spans.add(TextSpan(text: lineEnding, style: defaultStyle));
      } else if (line.startsWith('# ')) {
        spans.add(TextSpan(
          text: '# ',
          style: defaultStyle.copyWith(color: ink3, fontSize: 22, fontWeight: FontWeight.w800),
        ));
        spans.addAll(_parseInlineFormatting(line.substring(2), defaultStyle.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: colors?.ink ?? Colors.white,
        ), colors));
        spans.add(TextSpan(text: lineEnding, style: defaultStyle));
      } else if (line.startsWith('> ')) {
        spans.add(TextSpan(
          text: '▌ ',
          style: defaultStyle.copyWith(color: signal2, fontWeight: FontWeight.w700),
        ));
        spans.addAll(_parseInlineFormatting(line.substring(2), defaultStyle.copyWith(
          fontStyle: FontStyle.italic,
          color: colors?.ink2 ?? Colors.grey.shade300,
        ), colors));
        spans.add(TextSpan(text: lineEnding, style: defaultStyle));
      } else if (line.startsWith('- [ ] ') || line.startsWith('- [x] ')) {
        final isChecked = line.startsWith('- [x] ');
        spans.add(TextSpan(
          text: isChecked ? '☑ ' : '☐ ',
          style: defaultStyle.copyWith(
            color: isChecked ? signal : ink3,
            fontWeight: FontWeight.bold,
          ),
        ));
        spans.addAll(_parseInlineFormatting(
          line.substring(6),
          defaultStyle.copyWith(
            decoration: isChecked ? TextDecoration.lineThrough : null,
            color: isChecked ? ink3 : baseColor,
          ),
          colors,
        ));
        spans.add(TextSpan(text: lineEnding, style: defaultStyle));
      } else if (line.startsWith('- ') || line.startsWith('* ') || line.startsWith('• ')) {
        spans.add(TextSpan(
          text: '• ',
          style: defaultStyle.copyWith(color: signal, fontWeight: FontWeight.bold),
        ));
        spans.addAll(_parseInlineFormatting(line.substring(2), defaultStyle, colors));
        spans.add(TextSpan(text: lineEnding, style: defaultStyle));
      } else if (RegExp(r'^\d+\.\s').hasMatch(line)) {
        final match = RegExp(r'^(\d+\.\s)').firstMatch(line)!;
        final numPrefix = match.group(1)!;
        spans.add(TextSpan(
          text: numPrefix,
          style: defaultStyle.copyWith(color: signal2, fontWeight: FontWeight.bold),
        ));
        spans.addAll(_parseInlineFormatting(line.substring(numPrefix.length), defaultStyle, colors));
        spans.add(TextSpan(text: lineEnding, style: defaultStyle));
      } else {
        // Normal paragraph line
        spans.addAll(_parseInlineFormatting(line, defaultStyle, colors));
        spans.add(TextSpan(text: lineEnding, style: defaultStyle));
      }
    }

    return TextSpan(children: spans, style: defaultStyle);
  }

  /// Parses inline markdown elements like **bold**, *italic*, <u>underline</u>, ~~strike~~,
  /// ==highlight==, [color:red]text[/color], [bg:yellow]text[/bg], @mentions, and [Date: ...]
  List<InlineSpan> _parseInlineFormatting(
    String text,
    TextStyle baseStyle,
    BitoColorScheme? colors,
  ) {
    if (text.isEmpty) return [];

    final spans = <InlineSpan>[];
    // Regex pattern for all inline tokens
    final tokenRegex = RegExp(
      r'(\*\*(.*?)\*\*)|' // 1: **bold** (2: content)
      r'(\*(.*?)\*)|' // 3: *italic* (4: content)
      r'(<u>(.*?)<\/u>)|' // 5: <u>underline</u> (6: content)
      r'(~~(.*?)~~)|' // 7: ~~strike~~ (8: content)
      r'(==(.*?)==)|' // 9: ==highlight== (10: content)
      r'(\[color:([a-zA-Z0-9#]+)\](.*?)\[\/color\])|' // 11: [color:x]text[/color] (12: color, 13: content)
      r'(\[bg:([a-zA-Z0-9#]+)\](.*?)\[\/bg\])|' // 14: [bg:x]text[/bg] (15: bg, 16: content)
      r'(@[a-zA-Z0-9_]+)|' // 17: @mention
      r'(\[Date:[^\]]+\])|' // 18: [Date: ...]
      r'(!?\[(.*?)\]\((.*?)\))', // 19: [text](url) or ![alt](url) (20: alt, 21: url)
    );

    int currentIndex = 0;
    for (final match in tokenRegex.allMatches(text)) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, match.start),
          style: baseStyle,
        ));
      }

      final ink3 = colors?.ink3 ?? Colors.grey;
      final signal = colors?.signal ?? Colors.amber;

      if (match.group(1) != null) {
        // **bold**
        final content = match.group(2) ?? '';
        spans.add(TextSpan(text: '**', style: baseStyle.copyWith(color: ink3.withOpacity(0.5))));
        spans.add(TextSpan(
          text: content,
          style: baseStyle.copyWith(fontWeight: FontWeight.bold),
        ));
        spans.add(TextSpan(text: '**', style: baseStyle.copyWith(color: ink3.withOpacity(0.5))));
      } else if (match.group(3) != null) {
        // *italic*
        final content = match.group(4) ?? '';
        spans.add(TextSpan(text: '*', style: baseStyle.copyWith(color: ink3.withOpacity(0.5))));
        spans.add(TextSpan(
          text: content,
          style: baseStyle.copyWith(fontStyle: FontStyle.italic),
        ));
        spans.add(TextSpan(text: '*', style: baseStyle.copyWith(color: ink3.withOpacity(0.5))));
      } else if (match.group(5) != null) {
        // <u>underline</u>
        final content = match.group(6) ?? '';
        spans.add(TextSpan(
          text: content,
          style: baseStyle.copyWith(decoration: TextDecoration.underline),
        ));
      } else if (match.group(7) != null) {
        // ~~strike~~
        final content = match.group(8) ?? '';
        spans.add(TextSpan(text: '~~', style: baseStyle.copyWith(color: ink3.withOpacity(0.5))));
        spans.add(TextSpan(
          text: content,
          style: baseStyle.copyWith(decoration: TextDecoration.lineThrough, color: ink3),
        ));
        spans.add(TextSpan(text: '~~', style: baseStyle.copyWith(color: ink3.withOpacity(0.5))));
      } else if (match.group(9) != null) {
        // ==highlight==
        final content = match.group(10) ?? '';
        spans.add(TextSpan(
          text: content,
          style: baseStyle.copyWith(
            backgroundColor: (colors?.signal ?? Colors.amber).withOpacity(0.3),
            color: colors?.ink ?? Colors.white,
          ),
        ));
      } else if (match.group(11) != null) {
        // [color:x]content[/color]
        final colorName = match.group(12) ?? 'ink';
        final content = match.group(13) ?? '';
        final parsedColor = _parseColor(colorName, colors);
        spans.add(TextSpan(
          text: content,
          style: baseStyle.copyWith(color: parsedColor),
        ));
      } else if (match.group(14) != null) {
        // [bg:x]content[/bg]
        final bgName = match.group(15) ?? 'yellow';
        final content = match.group(16) ?? '';
        final parsedBg = _parseBgColor(bgName, colors);
        spans.add(TextSpan(
          text: content,
          style: baseStyle.copyWith(backgroundColor: parsedBg),
        ));
      } else if (match.group(17) != null) {
        // @mention
        spans.add(TextSpan(
          text: match.group(17),
          style: baseStyle.copyWith(
            color: signal,
            fontWeight: FontWeight.w600,
          ),
        ));
      } else if (match.group(18) != null) {
        // [Date: ...]
        spans.add(TextSpan(
          text: match.group(18),
          style: baseStyle.copyWith(
            color: colors?.signal2 ?? Colors.greenAccent,
            fontWeight: FontWeight.w600,
            fontSize: (baseStyle.fontSize ?? 15) * 0.9,
          ),
        ));
      } else if (match.group(19) != null) {
        // [text](url)
        final isImage = match.group(19)!.startsWith('!');
        final textPart = match.group(20) ?? '';
        spans.add(TextSpan(
          text: isImage ? '🖼 $textPart' : '🔗 $textPart',
          style: baseStyle.copyWith(
            color: colors?.signal2 ?? Colors.blueAccent,
            decoration: TextDecoration.underline,
          ),
        ));
      }

      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: baseStyle,
      ));
    }

    return spans;
  }

  Color _parseColor(String colorName, BitoColorScheme? colors) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.redAccent.shade200;
      case 'blue':
        return Colors.lightBlueAccent.shade200;
      case 'green':
        return Colors.greenAccent.shade400;
      case 'yellow':
      case 'signal':
        return colors?.signal ?? Colors.amber;
      case 'signal2':
        return colors?.signal2 ?? Colors.greenAccent;
      case 'orange':
        return Colors.orangeAccent;
      case 'purple':
        return Colors.purpleAccent.shade100;
      case 'pink':
        return Colors.pinkAccent.shade100;
      case 'gray':
      case 'grey':
        return colors?.ink3 ?? Colors.grey;
      case 'ink':
      case 'white':
        return colors?.ink ?? Colors.white;
      default:
        if (colorName.startsWith('#') && colorName.length == 7) {
          final hex = int.tryParse('FF${colorName.substring(1)}', radix: 16);
          if (hex != null) return Color(hex);
        }
        return colors?.ink ?? Colors.white;
    }
  }

  Color _parseBgColor(String bgName, BitoColorScheme? colors) {
    switch (bgName.toLowerCase()) {
      case 'yellow':
      case 'signal':
        return (colors?.signal ?? Colors.amber).withOpacity(0.35);
      case 'gray':
      case 'grey':
        return (colors?.line2 ?? Colors.grey).withOpacity(0.5);
      case 'red':
        return Colors.red.withOpacity(0.3);
      case 'blue':
        return Colors.blue.withOpacity(0.3);
      case 'green':
        return Colors.green.withOpacity(0.3);
      case 'purple':
        return Colors.purple.withOpacity(0.3);
      default:
        return (colors?.signal ?? Colors.amber).withOpacity(0.3);
    }
  }

  /// Helper to toggle or apply text wrapping format (e.g. **bold**, *italic*, <u></u>, ~~strike~~)
  void applyInlineFormat({required String prefix, String suffix = ''}) {
    final currentText = text;
    final sel = selection;

    if (!sel.isValid || sel.start == -1) {
      // Append at end
      final newText = '$currentText$prefix$suffix';
      value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: currentText.length + prefix.length),
      );
      return;
    }

    if (sel.start == sel.end) {
      // No text selected -> insert tags and put cursor in the middle
      final start = sel.start;
      final newText = currentText.substring(0, start) + prefix + suffix + currentText.substring(start);
      value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: start + prefix.length),
      );
    } else {
      // Text selected -> wrap or unwrap
      final selectedText = currentText.substring(sel.start, sel.end);

      // Check if already wrapped
      if (prefix.isNotEmpty && suffix.isNotEmpty &&
          selectedText.startsWith(prefix) && selectedText.endsWith(suffix)) {
        // Unwrap
        final unwrapped = selectedText.substring(prefix.length, selectedText.length - suffix.length);
        final newText = currentText.substring(0, sel.start) + unwrapped + currentText.substring(sel.end);
        value = TextEditingValue(
          text: newText,
          selection: TextSelection(
            baseOffset: sel.start,
            extentOffset: sel.start + unwrapped.length,
          ),
        );
      } else {
        // Wrap
        final wrapped = '$prefix$selectedText$suffix';
        final newText = currentText.substring(0, sel.start) + wrapped + currentText.substring(sel.end);
        value = TextEditingValue(
          text: newText,
          selection: TextSelection(
            baseOffset: sel.start,
            extentOffset: sel.start + wrapped.length,
          ),
        );
      }
    }
  }

  /// Helper to apply line prefix (e.g., #, ##, ###, >, -, 1., - [ ])
  void applyLinePrefix(String linePrefix) {
    final currentText = text;
    final sel = selection;

    final cursorPosition = (sel.isValid && sel.start >= 0) ? sel.start : currentText.length;

    // Find the start of the current line
    final beforeCursor = currentText.substring(0, cursorPosition);
    final lastNewline = beforeCursor.lastIndexOf('\n');
    final lineStart = lastNewline == -1 ? 0 : lastNewline + 1;

    // Find the end of the current line
    final nextNewline = currentText.indexOf('\n', cursorPosition);
    final lineEnd = nextNewline == -1 ? currentText.length : nextNewline;

    final currentLine = currentText.substring(lineStart, lineEnd);

    // List of known prefixes to replace if already present
    final knownPrefixes = ['#### ', '### ', '## ', '# ', '> ', '- [ ] ', '- [x] ', '- ', '* ', '• '];

    String existingPrefix = '';
    for (final p in knownPrefixes) {
      if (currentLine.startsWith(p)) {
        existingPrefix = p;
        break;
      }
    }

    String newLine;
    int newOffset;

    if (existingPrefix == linePrefix) {
      // Toggle off
      newLine = currentLine.substring(existingPrefix.length);
      newOffset = (cursorPosition - existingPrefix.length).clamp(lineStart, lineStart + newLine.length);
    } else if (existingPrefix.isNotEmpty) {
      // Replace prefix
      newLine = '$linePrefix${currentLine.substring(existingPrefix.length)}';
      newOffset = (cursorPosition - existingPrefix.length + linePrefix.length).clamp(lineStart, lineStart + newLine.length);
    } else {
      // Add prefix
      newLine = '$linePrefix$currentLine';
      newOffset = cursorPosition + linePrefix.length;
    }

    final newText = currentText.substring(0, lineStart) + newLine + currentText.substring(lineEnd);
    value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }

  /// Helper to insert a block or template at current position
  void insertBlock(String block, {int cursorOffset = 0}) {
    final currentText = text;
    final sel = selection;

    final cursor = (sel.isValid && sel.start >= 0) ? sel.start : currentText.length;
    final end = (sel.isValid && sel.end >= 0) ? sel.end : cursor;

    final newText = currentText.substring(0, cursor) + block + currentText.substring(end);
    final targetOffset = cursor + block.length + cursorOffset;

    value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: targetOffset.clamp(0, newText.length)),
    );
  }
}
