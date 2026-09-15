// lib/data/providers/verse_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/verse_entity.dart';
import '../../domain/repositories/i_verse_repository.dart';
import '../datasources/remote/verse_remote_datasource.dart';
import '../repositories/verse_repository.dart';

// ============================================================
// Data Source
// ============================================================
final verseRemoteDataSourceProvider = Provider<VerseRemoteDataSource>((ref) {
  final dio = Dio();
  return VerseRemoteDataSource(dio);
});

// ============================================================
// Repository
// ============================================================
final verseRepositoryProvider = Provider<IVerseRepository>((ref) {
  final remoteDataSource = ref.watch(verseRemoteDataSourceProvider);
  return VerseRepository(remoteDataSource);
});

// ============================================================
// State Provider
// ============================================================
final dailyVerseProvider = FutureProvider<VerseEntity>((ref) async {
  final repository = ref.watch(verseRepositoryProvider);
  final now = DateTime.now();
  final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
  return await repository.getVerseForDay(dayOfYear);
});
