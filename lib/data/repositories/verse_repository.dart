// lib/data/repositories/verse_repository.dart
import '../../domain/entities/verse_entity.dart';
import '../../domain/repositories/i_verse_repository.dart';
import '../datasources/remote/verse_remote_datasource.dart';
// import '../models/verse_model.dart';  // ← REMOVE - not needed

class VerseRepository implements IVerseRepository {
  final VerseRemoteDataSource _remoteDataSource;

  VerseRepository(this._remoteDataSource);

  @override
  Future<VerseEntity> getVerseForDay(int dayOfYear) async {
    try {
      final model = await _remoteDataSource.getVerseForDay(dayOfYear);
      // Convert model to entity
      return VerseEntity(
        text: model.text,
        reference: model.reference,
      );
    } catch (e) {
      // Fallback to static verse
      final staticVerses = _getStaticVerses();
      final index = dayOfYear % staticVerses.length;
      return staticVerses[index];
    }
  }

  @override
  List<String> getStaticVerseIds() {
    return _remoteDataSource.getVerseIds();
  }

  List<VerseEntity> _getStaticVerses() {
    return [
      const VerseEntity(
        text: '"Though the fig tree should not blossom, nor fruit be on the vines, the produce of the olive fail and the fields yield no food, the flock be cut off from the fold and there be no herd in the stalls, yet I will rejoice in the Lord; I will joy in the God of my Salvation."',
        reference: 'Habakkuk 3:17-18',
      ),
      const VerseEntity(
        text: '"For I know the plans I have for you, declares the Lord, plans for welfare and not for evil, to give you a future and a hope."',
        reference: 'Jeremiah 29:11',
      ),
      const VerseEntity(
        text: '"Be strong and courageous. Do not fear or be in dread of them, for it is the Lord your God who goes with you. He will not leave you or forsake you."',
        reference: 'Deuteronomy 31:6',
      ),
      const VerseEntity(
        text: '"Trust in the Lord with all your heart, and do not lean on your own understanding. In all your ways acknowledge him, and he will make straight your paths."',
        reference: 'Proverbs 3:5-6',
      ),
      const VerseEntity(
        text: '"I can do all things through him who strengthens me."',
        reference: 'Philippians 4:13',
      ),
      const VerseEntity(
        text: '"The Lord is my shepherd; I shall not want. He makes me lie down in green pastures. He leads me beside still waters. He restores my soul."',
        reference: 'Psalm 23:1-3',
      ),
      const VerseEntity(
        text: '"And we know that for those who love God all things work together for good, for those who are called according to his purpose."',
        reference: 'Romans 8:28',
      ),
      const VerseEntity(
        text: '"Do not be anxious about anything, but in everything by prayer and supplication with thanksgiving let your requests be made known to God."',
        reference: 'Philippians 4:6',
      ),
      const VerseEntity(
        text: '"The steadfast love of the Lord never ceases; his mercies never come to an end; they are new every morning; great is your faithfulness."',
        reference: 'Lamentations 3:22-23',
      ),
      const VerseEntity(
        text: '"But they who wait for the Lord shall renew their strength; they shall mount up with wings like eagles; they shall run and not be weary; they shall walk and not faint."',
        reference: 'Isaiah 40:31',
      ),
    ];
  }
}

