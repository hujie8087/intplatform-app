import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/http/model/meal_delivery_model.dart';
import 'package:logistics_app/utils/color.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';

class DeliverySiteSelector extends StatefulWidget {
  final List<MealDeliverySiteModel> sites;
  final MealDeliverySiteModel? selectedSite;

  const DeliverySiteSelector({
    super.key,
    required this.sites,
    this.selectedSite,
  });

  @override
  State<DeliverySiteSelector> createState() => _DeliverySiteSelectorState();
}

class _DeliverySiteSelectorState extends State<DeliverySiteSelector> {
  TextEditingController searchController = TextEditingController();
  List<MealDeliverySiteModel> filteredSites = [];

  @override
  void initState() {
    super.initState();
    filteredSites = List.from(widget.sites);
    searchController.addListener(_filterSites);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterSites() {
    setState(() {
      if (searchController.text.isEmpty) {
        filteredSites = List.from(widget.sites);
      } else {
        filteredSites =
            widget.sites
                .where(
                  (site) =>
                      site.fsAddressCn?.toLowerCase().contains(
                        searchController.text.toLowerCase(),
                      ) ??
                      false,
                )
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.px,
      padding: EdgeInsets.symmetric(vertical: 10.px),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.px),
          topRight: Radius.circular(15.px),
        ),
      ),
      child: Column(
        children: [
          // 标题栏
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.px),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    S.of(context).cancel,
                    style: TextStyle(fontSize: 14.px, color: Colors.grey),
                  ),
                ),
                Text(
                  S.of(context).pleaseSelect(S.of(context).delivery_site),
                  style: TextStyle(
                    fontSize: 16.px,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, widget.selectedSite);
                  },
                  child: Text(
                    S.of(context).confirm,
                    style: TextStyle(fontSize: 14.px, color: primaryColor),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1.px, color: Colors.grey),
          // 搜索框
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.px, vertical: 10.px),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.px,
                  vertical: 5.px,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.px),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.px),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.px),
                  borderSide: BorderSide(color: primaryColor),
                ),
                isDense: false,
                prefixIcon: Icon(Icons.search, size: 20.px),
                hintText: S.of(context).delivery_site_search_placeholder,
                hintStyle: TextStyle(fontSize: 14.px, color: Colors.grey),
                suffixIcon:
                    searchController.text.isNotEmpty
                        ? IconButton(
                          icon: Icon(Icons.clear, size: 20.px),
                          onPressed: () {
                            searchController.clear();
                          },
                        )
                        : null,
              ),
            ),
          ),

          // 站点列表
          Expanded(
            child:
                filteredSites.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 50.px,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10.px),
                          Text(
                            S.of(context).delivery_site_search_not_found,
                            style: TextStyle(
                              fontSize: 14.px,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20.px),
                      itemCount: filteredSites.length,
                      itemBuilder: (context, index) {
                        final site = filteredSites[index];
                        final isSelected =
                            widget.selectedSite?.fsAddressCn ==
                            site.fsAddressCn;

                        return Container(
                          margin: EdgeInsets.only(bottom: 8.px),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? primaryColor.withOpacity(0.1)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(8.px),
                            border: Border.all(
                              color:
                                  isSelected ? primaryColor : Colors.grey[300]!,
                              width: 1.px,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8.px),
                              onTap: () {
                                Navigator.pop(context, site);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15.px,
                                  vertical: 8.px,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            site.fsAddressCn ?? '',
                                            style: TextStyle(
                                              fontSize: 14.px,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  isSelected
                                                      ? primaryColor
                                                      : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle,
                                        color: primaryColor,
                                        size: 20.px,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
