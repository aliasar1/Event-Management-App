import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';

import '../manager/firebase_constants.dart';
import '../models/event.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        scanQRCode(widget.event.id);
      },
      child: const Icon(
        Icons.qr_code_scanner,
      ),
    );
  }

  void scanQRCode(String eventId) async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;
      final ids = qrCode.split("-");
      final uid = ids[0];
      final eId = ids[1];
      if (eId == eventId) {
        final participantRef = firestore
            .collection('events')
            .doc(eventId)
            .collection('participants')
            .doc(uid);
        await participantRef.update({
          'haveAttended': true,
        });
        Get.snackbar(
          'Success!',
          'Your presence in event is recorded.',
        );
      } else {
        Get.snackbar(
          'Failure!',
          'Participant in not registered in this event.',
        );
      }
    } on PlatformException catch (e) {
      Get.snackbar(
        'Failure!',
        'Error occurred when scanning: ${e.code}',
      );
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        Get.snackbar(
          'Failure!',
          'You have not registered yourself in this event.',
        );
      } else {
        Get.snackbar(
          'Failure!',
          'Error occurred: ${e.toString()}',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Failure!',
        'Error occurred: ${e.toString()}',
      );
    }
  }
}
