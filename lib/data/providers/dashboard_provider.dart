// lib/data/providers/dashboard_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/i_dashboard_repository.dart';
import '../datasources/remote/dashboard_remote_datasource.dart';
import '../repositories/dashboard_repository.dart';

// Data Source
final dashboardRemoteDataSourceProvider = Provider<DashboardRemoteDataSource>((ref) {
  return DashboardRemoteDataSource();
});

// Repository
final dashboardRepositoryProvider = Provider<IDashboardRepository>((ref) {
  final remoteDataSource = ref.watch(dashboardRemoteDataSourceProvider);
  return DashboardRepository(remoteDataSource);
});

// State Provider
final dashboardProvider = FutureProvider<DashboardEntity>((ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return await repository.getDashboardData();
});

