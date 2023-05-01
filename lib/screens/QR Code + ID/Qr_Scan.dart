import 'Profile_screen.dart';
import 'result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


class ScanQr extends StatefulWidget {
  const ScanQr({super.key});

  @override
  State<ScanQr> createState() => _ScanQrState();
}

String? val;

class _ScanQrState extends State<ScanQr> {
  bool scanCompleted = false;
  void closeScreen() {
    scanCompleted = false;
  }

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
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Place QR in the box to scan ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Scanning is automatically done'),
            ],
          )),
          Expanded(
            flex: 3,
            // child: MobileScanner(
            //   onDetect: (barcode) {
            //     if (!scanCompleted) {
            //       code = barcode.raw.toString();
            //       scanCompleted = true;
            //       String Code = code.toString();
            //       print("hello all " + code!);

            // Navigator.push(
            //     context,
            //     // MaterialPageRoute(builder: (context) => Idcard(code!)))
            //     MaterialPageRoute(
            //         builder: (context) => ResultScreen(
            //               code: Code,
            //               closeScreen: closeScreen,
            //             )));
            // }
            //   },
            // ),
            child: MobileScanner(
              controller: MobileScannerController(
                detectionSpeed: DetectionSpeed.noDuplicates,
                facing: CameraFacing.back,
                // torchEnabled: true,
              ),
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                final Uint8List? image = capture.image;

                for (final barcode in barcodes) {
                  // debugPrint('Barcode found! ${barcode.rawValue}');
                  try {
                    if (barcode.rawValue != null) {
                      val = barcode.rawValue.toString();
                      break;
                    } else {
                      throw (barcode);
                    }
                  } catch (error) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfileScreen()));
                  }
                }
                debugPrint("this is the value " + val!);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResultScreen(
                              code: val.toString(),
                              closeScreen: closeScreen,
                            )));
              },
            ),
          ),
          Expanded(
              child: Container(
            alignment: Alignment.center,
            child: Text(
              "Developed by Campus Compass",
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          )),
        ]),
      ),
    );
  }
}
