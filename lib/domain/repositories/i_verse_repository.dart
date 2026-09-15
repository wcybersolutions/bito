// lib/domain/repositories/i_verse_repository.dart
import '../entities/verse_entity.dart';

abstract class IVerseRepository {
  Future<VerseEntity> getVerseForDay(int dayOfYear);
  List<String> getStaticVerseIds();
}
