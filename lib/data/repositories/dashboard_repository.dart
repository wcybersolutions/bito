// lib/data/repositories/dashboard_repository.dart
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/i_dashboard_repository.dart';
import '../datasources/remote/dashboard_remote_datasource.dart';
import '../models/dashboard/dashboard_model.dart'; // <-- Added missing import

class DashboardRepository implements IDashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepository(this._remoteDataSource);

  @override
  Future<DashboardEntity> getDashboardData() async {
    try {
      final model = await _remoteDataSource.getDashboardData();
      return model.toDomain();
    } catch (e) {
      // Fallback to sample data
      return DashboardModel.sample().toDomain();
    }
  }
}

