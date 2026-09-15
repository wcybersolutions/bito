// lib/data/datasources/remote/dashboard_remote_datasource.dart
import '../../models/dashboard/dashboard_model.dart';

class DashboardRemoteDataSource {
  // This will eventually fetch from API
  // For now, return sample data
  Future<DashboardModel> getDashboardData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return DashboardModel.sample();
  }
}
