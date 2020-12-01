import 'package:PassPuss/logic/Database.dart';

import 'service.dart';

class AutoSyncService extends Service<void>{
  static final String AutoSyncSetting = "AutoSyncDrive";
  AutoSyncService._();
  @override
  void serve(void obj) async {
    await DBProvider.saveDrive();
  }

  static Service getService() {
    return AutoSyncService._();
  }

}