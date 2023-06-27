import 'package:get_storage/get_storage.dart';

mixin CacheManager {
  void saveToken(bool isLogin) {
    final box = GetStorage();
    box.write('isLogin', isLogin);
  }

  bool? getToken() {
    final box = GetStorage();
    return box.read('isLogin');
  }

  Future<void> removeToken() async {
    final box = GetStorage();
    await box.remove('isLogin');
  }
}
