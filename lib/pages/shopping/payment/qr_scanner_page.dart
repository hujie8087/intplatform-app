import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  MobileScannerController controller = MobileScannerController();
  bool isScanning = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.scanQRCode, style: TextStyle(fontSize: 16.px)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.flip_camera_ios),
            onPressed: () => controller.switchCamera(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller.torchState,
              builder: (context, state, child) {
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off);
                  case TorchState.on:
                    return const Icon(Icons.flash_on);
                }
              },
            ),
            onPressed: () => controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && isScanning) {
                isScanning = false; // 防止重复扫描
                final String code = barcodes.first.rawValue ?? '';
                // ProgressHUD.showSuccess(code);
                Navigator.pop(context, code); // 返回扫描结果
              }
            },
          ),
          // 扫描框
          Center(
            child: Container(
              width: 250.px,
              height: 250.px,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12.px),
              ),
            ),
          ),
          // 提示文本
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Text(
              S.current.scanQRCodeTips,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.px,
                shadows: [
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 3.0,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
