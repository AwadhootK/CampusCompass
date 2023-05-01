import 'package:flutter/material.dart';
import '../../helpers/global_data.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCode extends StatefulWidget {
  const QrCode({super.key});

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  bool getqr = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 400)),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: QrImage(
                    data: User.m!['UID'],
                    version: QrVersions.auto,
                    size: 250,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            );
          }
        }));
  }
}
