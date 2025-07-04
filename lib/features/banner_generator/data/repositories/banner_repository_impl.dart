import '../../domain/entities/banner_config.dart';
import '../../domain/repositories/banner_repository.dart';
import '../datasources/banner_local_datasource.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerLocalDataSource localDataSource;
  BannerRepositoryImpl(this.localDataSource);

  @override
  Future<BannerConfig?> loadBannerConfig() async {
    return await localDataSource.loadBannerConfig();
  }

  @override
  Future<void> saveBannerConfig(BannerConfig config) async {
    await localDataSource.saveBannerConfig(config);
  }
}
