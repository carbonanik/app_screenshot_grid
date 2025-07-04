import '../repositories/banner_repository.dart';
import '../entities/banner_config.dart';

class LoadBannerConfig {
  final BannerRepository repository;
  LoadBannerConfig(this.repository);

  Future<BannerConfig?> call() async {
    return await repository.loadBannerConfig();
  }
}
