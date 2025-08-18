import 'package:flutter/material.dart';
import 'package:logistics_app/generated/l10n.dart';
import 'package:logistics_app/utils/screen_adapter_helper.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  MobileScannerController? controller;
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
            onPressed: () async {
              await controller?.switchCamera();
            },
          ),
          IconButton(
            icon: Icon(Icons.flash_on),
            onPressed: () async {
              // await controller?.toggleFlash();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (capture.barcodes.first.displayValue != null && isScanning) {
                isScanning = false;
                Navigator.pop(context, capture.barcodes.first.displayValue);
              }
            },
            onDetectError: (error, stackTrace) {
              print('error----2222');
            },
          ),
          // 提示文本
          Positioned(
            bottom: 100.px,
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
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller?.start();
    }
  }
}
