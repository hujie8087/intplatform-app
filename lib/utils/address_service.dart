import 'package:logistics_app/http/data/data_utils.dart';
import 'package:logistics_app/http/model/base_model.dart';
import 'package:logistics_app/utils/sp_utils.dart';

class AddressService {
  // 更新区域数据
  void refreshAddressData() async {
    await SpUtils.remove('buildingVersion');
    await SpUtils.remove('building');
    getAddressData();
  }

// 获取区域楼栋数据
  void getAddressData() async {
    int? buildingVersion = await SpUtils.getInt('buildingVersion');
    int newBuildingVersion = 0;
    Object? buildingData = await SpUtils.getModel('building');
    DataUtils.getBuildingVersion(
      success: (data) {
        newBuildingVersion = data['data']['version'];
        if (newBuildingVersion != buildingVersion || buildingData == null) {
          SpUtils.saveInt('buildingVersion', newBuildingVersion);
          DataUtils.getBuildingTree(
            success: (data) {
              BaseModel rowsModel = BaseModel.fromJson(data);
              if (rowsModel.data != null) {
                SpUtils.saveModel('building', rowsModel.data);
              }
            },
          );
        }
      },
      fail: (code, msg) {},
    );
  }
}
