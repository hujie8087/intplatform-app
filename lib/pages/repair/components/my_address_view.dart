import 'package:flutter/material.dart';
import 'package:logistics_app/common_ui/divider_widget.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/my_address_view_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:provider/provider.dart';
import 'package:logistics_app/pages/repair/repair_data_model.dart';

class MyAddressView extends StatelessWidget {
  final List<AddressModel> addressList;
  final AddressModel? defaultAddress;
  final Function(AddressModel) onAddressSelected;
  final VoidCallback onAddAddress;
  final List<dynamic>? areaIds;

  const MyAddressView({
    Key? key,
    required this.addressList,
    this.defaultAddress,
    required this.onAddressSelected,
    required this.onAddAddress,
    this.areaIds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RepairDataModel>(
      builder: (context, model, child) {
        return Container(
          padding: EdgeInsets.all(8.px),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.px)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 8.px),
                child: Text(
                  S.of(context).pleaseSelect(S.of(context).address),
                  style:
                      TextStyle(fontSize: 14.px, fontWeight: FontWeight.bold),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.3,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final address in model.addressList)
                        Column(
                          children: [
                            InkWell(
                              onTap: areaIds == null
                                  ? () => onAddressSelected(address)
                                  : areaIds!.contains(address.areaId)
                                      ? () => onAddressSelected(address)
                                      : null,
                              child: Padding(
                                padding: EdgeInsets.all(10.px),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 24.px,
                                      child:
                                          model.defaultAddress?.id == address.id
                                              ? Icon(
                                                  Icons.radio_button_checked,
                                                  color: primaryColor,
                                                  size: 20.px,
                                                )
                                              : Container(),
                                    ),
                                    SizedBox(width: 10.px),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            address.detailedAddress ?? '',
                                            style: TextStyle(
                                                fontSize: 12.px,
                                                fontWeight: FontWeight.bold,
                                                color: areaIds == null ||
                                                        areaIds!.contains(
                                                            address.areaId)
                                                    ? Colors.black
                                                    : Colors.grey),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Text(address.name ?? '',
                                                  style: TextStyle(
                                                      fontSize: 10.px,
                                                      color: Colors.grey)),
                                              SizedBox(width: 8.px),
                                              Text(address.tel ?? '',
                                                  style: TextStyle(
                                                      fontSize: 10.px,
                                                      color: Colors.grey)),
                                              SizedBox(width: 8.px),
                                              // 默认地址
                                              if (address.isDefault == '0')
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5.px,
                                                      vertical: 2.px),
                                                  decoration: BoxDecoration(
                                                    color: primaryColor[500],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.px),
                                                  ),
                                                  child: Text(
                                                    S.of(context).defaultValue,
                                                    style: TextStyle(
                                                        fontSize: 10.px,
                                                        color: Colors.white),
                                                  ),
                                                )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.edit,
                                      color: areaIds == null ||
                                              areaIds!.contains(address.areaId)
                                          ? primaryColor
                                          : Colors.grey,
                                      size: 18.px,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            DividerWidget()
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 10.px),
                // 这个container的高度
                height: 40.px,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor[500],
                      padding: EdgeInsets.symmetric(vertical: 3.px),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: 16.px,
                  ),
                  label: Text(
                    S.of(context).addAddress,
                    style: TextStyle(fontSize: 12.px),
                  ),
                  onPressed: onAddAddress,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
