import '../entities/banner_config.dart';

abstract class BannerRepository {
  Future<BannerConfig?> loadBannerConfig();
  Future<void> saveBannerConfig(BannerConfig config);
  // Add more methods as needed, e.g., for manipulating images, etc.
}
