// lib/data/datasources/remote/verse_remote_datasource.dart
import 'package:dio/dio.dart';
import '../../models/verse_model.dart';

class VerseRemoteDataSource {
  static const String _baseUrl = 'https://bible-api.com';
  static const List<String> _verseIds = [
    'habakkuk 3:17-18',
    'jeremiah 29:11',
    'deuteronomy 31:6',
    'proverbs 3:5-6',
    'philippians 4:13',
    'psalm 23:1-3',
    'romans 8:28',
    'philippians 4:6',
    'lamentations 3:22-23',
    'isaiah 40:31',
  ];

  final Dio _dio;

  VerseRemoteDataSource(this._dio);

  Future<VerseModel> getVerseForDay(int dayOfYear) async {
    final index = dayOfYear % _verseIds.length;
    final verseId = _verseIds[index];

    final response = await _dio.get(
      '$_baseUrl/$verseId?translation=kjv',
    );

    if (response.statusCode == 200 && response.data != null) {
      return VerseModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load verse');
    }
  }

  List<String> getVerseIds() => _verseIds;
}

