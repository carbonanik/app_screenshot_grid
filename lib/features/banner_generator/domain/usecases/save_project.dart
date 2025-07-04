import '../repositories/banner_repository.dart';
import '../entities/banner_config.dart';

class SaveBannerConfig {
  final BannerRepository repository;
  SaveBannerConfig(this.repository);

  Future<void> call(BannerConfig config) async {
    await repository.saveBannerConfig(config);
  }
}
