import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:logistics_app/utils/color.dart';

class LostFoundDetailPage extends StatefulWidget {
  const LostFoundDetailPage({Key? key}) : super(key: key);

  @override
  _LostFoundDetailPageState createState() => _LostFoundDetailPageState();
}

class _LostFoundDetailPageState extends State<LostFoundDetailPage> {
  String? title;
  String? content;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // 获取路由参数
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var map = ModalRoute.of(context)?.settings.arguments;
      print(map);
      if (map is Map) {
        title = map['noticeTitle'];
        content = map['noticeContent'];
        setState(() {});
      }
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickMultiImage();
    if (pickedFile != null && _images.length < 5) {
      setState(() {
        _images.addAll(pickedFile.map((e) => File(e.path)));
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          '发布丢失信息',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormColumn('姓名', _nameController),
                  _buildFormColumn('丢失地点', _locationController),
                  _buildFormColumn('物品名称', _itemNameController),
                  _buildFormColumn('物品数量', _quantityController,
                      keyboardType: TextInputType.number),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '丢失日期',
                        style: TextStyle(
                            fontSize: 14, color: Colors.black, height: 3),
                        textAlign: TextAlign.left,
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.date_range),
                              SizedBox(width: 10),
                              Text(_selectedDate == null
                                  ? '选择日期'
                                  : '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildFormColumn('物品描述', _descriptionController, maxLines: 3),
                  SizedBox(height: 16.0),
                  Text('上传物品图片'),
                  SizedBox(height: 8.0),
                  Wrap(
                    spacing: 8.0,
                    children: _images
                        .map((image) => Stack(
                              children: [
                                Image.file(
                                  image,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _images.remove(image);
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(secondaryColor),
                    ),
                    onPressed: _pickImage,
                    child: Text('选择图片', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Process data
                          print('Name: ${_nameController.text}');
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.teal),
                      ),
                      child: Container(
                          width: double.infinity,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Text("提交信息",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormColumn(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.black, height: 3),
            textAlign: TextAlign.left,
          ),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            cursorHeight: 20.0,
            decoration: InputDecoration(
              hintText: '请输入 $label',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
              filled: true,
              fillColor: Colors.white,
              isCollapsed: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '请输入 $label';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
