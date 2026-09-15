// lib/domain/repositories/i_dashboard_repository.dart
import '../entities/dashboard_entity.dart';

abstract class IDashboardRepository {
  Future<DashboardEntity> getDashboardData();
}

