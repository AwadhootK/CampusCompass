import 'package:firebase/screens/QR%20Code%20+%20ID/logic/result_cubit.dart';
import 'package:firebase/screens/QR%20Code%20+%20ID/ui/result_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQr extends StatefulWidget {
  bool isLogin;
  ScanQr({required this.isLogin});

  @override
  State<ScanQr> createState() => _ScanQrState();
}

String? val;
bool isScanned = true;

class _ScanQrState extends State<ScanQr> {
  String? code;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "QR code scanner",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Place the QR Code in the camera to scan",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Scanning is done automatically'),
            ],
          )),
          Expanded(
            flex: 3,
            child: MobileScanner(
              controller: MobileScannerController(
                detectionSpeed: DetectionSpeed.noDuplicates,
                facing: CameraFacing.back,
                detectionTimeoutMs: 1000,
              ),
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                final Uint8List? image = capture.image;

                for (final barcode in barcodes) {
                  try {
                    if (barcode.rawValue != null) {
                      val = barcode.rawValue.toString();
                      break;
                    } else {
                      throw (barcode);
                    }
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error: $error',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => ResultCubit()..getUserData(val!),
                      child: ResultScreen(
                        code: val.toString(),
                        isLogin: widget.isLogin,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
              child: Container(
            alignment: Alignment.center,
            child: const Text(
              "Developed by Campus Compass",
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          )),
        ]),
      ),
    );
  }
}
