import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/extern/dynamic_user_capture.dart';
import 'package:scouting_app_2024/parts/bits/duc_bit.dart';
import 'dart:io';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import 'package:scouting_app_2024/user/models/team_model.dart';
/*
  __
<(o )___
 ( ._> /
  `---'
  __
<(o )___
 ( ._> /
  `---'
  __
<(o )___
 ( ._> /
  `---'
  __
<(o )___
 ( ._> /
  `---'
  __
<(o )___
 ( ._> /
  `---'
  __
<(o )___
 ( ._> /
  `---'
  __
<(o )___
 ( ._> /
  `---'

  quack quack quack
 */

class DataHostingView extends StatefulWidget
    implements AppPageViewExporter {
  const DataHostingView({super.key});

  @override
  State<DataHostingView> createState() => _DataHostingViewState();

  @override
  ({
    Widget child,
    ({Icon activeIcon, Icon icon, String label, String tooltip}) item
  }) exportAppPageView() {
    return (
      child: this,
      item: (
        activeIcon:
            const Icon(CommunityMaterialIcons.account_tie_outline),
        icon: const Icon(CommunityMaterialIcons.duck),
        label: "Duc",
        tooltip: "Integrated Data Collection"
      )
    );
  }
}

class _DataHostingViewState extends State<DataHostingView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics()),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                    onTap: () async => await launchConfirmDialog(
                        // :)
                        context,
                        title: "exoad's memo",
                        message: const Text(
                            "idk, i wanted a duck, so i cut the word down to get 'duc', and then i asked chatgpt an acronym and it came up with 'Dynamic User Capture' so i was like 'ok, lets go with that' LOL ~exoad"),
                        showOkLabel: false,
                        onConfirm: () {}),
                    child: const Icon(CommunityMaterialIcons.duck,
                        size: 38)),
                const SizedBox(width: 12),
                const Text("DUC",
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.black),
                        Text(
                            "Only use this if you know what you are doing or you are a [Scouting Leader]",
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text.rich(
                TextSpan(children: <InlineSpan>[
                  const TextSpan(
                      text: "Total Matches Loaded: ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: Provider.of<DucBaseBit>(context)
                          .length
                          .toString())
                ]),
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 14),
            if (Platform.isAndroid || Platform.isIOS)
              FilledButton.tonalIcon(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<Widget>(
                          builder: (BuildContext context) => Scaffold(
                              appBar: AppBar(
                                  title: const Text("DUC Scanner")),
                              body: const _QrScanner()))),
                  icon: const Icon(Icons.qr_code_scanner_rounded),
                  label: const Text("Scan DUC"))
            else
              Text.rich(TextSpan(children: <InlineSpan>[
                const WidgetSpan(child: Icon(Icons.error_rounded)),
                TextSpan(
                    text:
                        "DUC Scanning is not supported on ${Platform.operatingSystem}")
              ])),
            const SizedBox(height: 14),
            FilledButton.tonalIcon(
                onPressed: () async => await showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        const _PasteDucData()),
                icon: const Icon(Icons.paste_rounded),
                label: const Text("Paste DUC")),
            const SizedBox(height: 14),
            ..._readProviderOfDucs(context)
          ]),
    );
  }

  List<Widget> _readProviderOfDucs(BuildContext context) {
    if (Provider.of<DucBaseBit>(context).length > 0) {
      List<Widget> widgets = <Widget>[];
      Provider.of<DucBaseBit>(context)
          .forEach((HollisticMatchScoutingData e) {
        widgets.add(const Text("Amogus"));
      });
      return widgets;
    }
    return <Widget>[
      const SizedBox(height: 24),
      const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(CommunityMaterialIcons.emoticon_cry, size: 96),
          SizedBox(width: 4),
          Icon(CommunityMaterialIcons.duck, size: 32)
        ],
      ),
      const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "No DUC data found! Please scan or paste some.",
          style: TextStyle(fontSize: 20),
          softWrap: true,
          textAlign: TextAlign.center,
        ),
      )
    ];
  }
}

class _PasteDucData extends StatefulWidget {
  const _PasteDucData();

  @override
  State<_PasteDucData> createState() => _PasteDucDataState();
}

class _PasteDucDataState extends State<_PasteDucData> {
  late TextEditingController _controller;
  late bool _isBadData;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _isBadData = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        icon: const Icon(CommunityMaterialIcons.duck),
        title: const Text("Manual Paste DUC data"),
        content: TextFormField(
            controller: _controller,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                errorMaxLines: 2,
                errorText: _isBadData ? "Bad Data" : null),
            maxLines: null),
        actions: <Widget>[
          FilledButton.tonalIcon(
              onPressed: () async =>
                  await Provider.of<DucBaseBit>(context)
                      .save()
                      .then((_) => Debug().info("[DUC] Saved!")),
              icon: const Icon(Icons.save_rounded),
              label: const Text("Save")),
          FilledButton.tonalIcon(
              onPressed: () {
                final String data = _controller.text;
                String? res = fromDucFormatExtern(data);
                if (res == null) {
                  setState(() => _isBadData = true);
                } else {
                  Provider.of<DucBaseBit>(context).add(
                      HollisticMatchScoutingData.fromCompatibleFormat(
                          res));
                  Navigator.of(context).pop();
                  Debug().info(
                      "Submitted new DUC Information from QR_PASTE");
                }
              },
              icon: const Icon(Icons.check_rounded),
              label: const Text("Submit")),
          FilledButton.tonalIcon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded),
              label: const Text("Cancel"))
        ]);
  }
}

class _QrScanner extends StatefulWidget {
  const _QrScanner();

  @override
  State<_QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<_QrScanner> {
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
                    Debug()
                        .info("It is a DUC! Adding to the list...");
                    Provider.of<DucBaseBit>(context, listen: false)
                        .add(HollisticMatchScoutingData
                            .fromCompatibleFormat(res));
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("DUC Detected and Added!")));
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
