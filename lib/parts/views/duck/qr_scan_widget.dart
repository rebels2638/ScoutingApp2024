import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/blobs/special_button.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/extern/dynamic_user_capture.dart';
import 'package:scouting_app_2024/parts/bits/duc_bit.dart';
import 'package:scouting_app_2024/user/models/team_model.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => QrScannerState();
}

class QrScannerState extends State<QrScanner> {
  late MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "If the camera below does not show, exit and re-enter this page.",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue[400]),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(children: <Widget>[
                Icon(Icons.info_rounded, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  "The scanner will automatically detect QR DUC date.",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  softWrap: true,
                ),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(
              bottom:
                  20), // sized box below doesnt work well because of the mobile scanner being present
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FilledButton.tonalIcon(
                  label: const Text("Flashlight"),
                  onPressed: () => _controller.toggleTorch(),
                  icon: ValueListenableBuilder<TorchState>(
                    valueListenable: _controller.torchState,
                    builder: (BuildContext context, TorchState state,
                            Widget? child) =>
                        state == TorchState.on
                            ? const Icon(Icons.flash_on_rounded)
                            : const Icon(Icons.flash_off_rounded),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                    label: const Text("Orientation"),
                    onPressed: () => _controller.switchCamera(),
                    icon: ValueListenableBuilder<CameraFacing>(
                      valueListenable: _controller.cameraFacingState,
                      builder: (BuildContext context,
                              CameraFacing state, Widget? child) =>
                          state == CameraFacing.front
                              ? const Icon(Icons.camera_front_rounded)
                              : const Icon(Icons.camera_rear_rounded),
                    ))
              ]),
        ),
        SizedBox(
          width: 512,
          height: 512,
          child: MobileScanner(
            controller: _controller,
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final Barcode barcode in barcodes) {
                if (barcode.format == BarcodeFormat.qrCode &&
                    barcode.rawValue != null) {
                  Debug().info(
                      "[DUC] found external code from QR_SCAN. Received RAW=${barcode.rawValue}");
                  Debug().info("Checking if it is a DUC...");
                  String? res =
                      fromDucFormatExtern(barcode.rawValue!);
                  if (res != null) {
                    HollisticMatchScoutingData data =
                        HollisticMatchScoutingData
                            .fromCompatibleFormat(res);
                    if (Provider.of<DucBaseBit>(context,
                            listen: false)
                        .containsID(data.id)) {
                      Debug().warn("DUC already exists, Ignored...");
                      launchInformDialog(context,
                          message: const Text(
                              "This DUC seems to be already recorded..."),
                          title: "Nope...",
                          icon: const Icon(Icons.warning_rounded));
                      return;
                    }
                    Debug().info(
                        "It is a unique DUC! Adding to the list...");
                    Provider.of<DucBaseBit>(context, listen: false)
                        .add(HollisticMatchScoutingData
                            .fromCompatibleFormat(res));
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            AlertDialog(
                                title: const Text("Added DUC!"),
                                content: Center(
                                    child: SpecialButton.premade2(
                                        label: "OK",
                                        icon: const FluentUiEmojiIcon(
                                            fl: Fluents.flOkHand,
                                            w: 40,
                                            h: 40),
                                        onPressed: () {}))));
                  } else {
                    Debug().warn("Not DUC detected, Ignored...");
                  }
                  break;
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
