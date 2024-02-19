import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:theme_provider/theme_provider.dart';

class QRExportOverlayRoute extends ModalRoute<void> {
  final String data;

  QRExportOverlayRoute({required this.data});

  @override
  Color? get barrierColor => Colors.black.withOpacity(0.5);

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildTransitions(
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) =>
      FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: animation, child: child),
      );

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    const PrettyQrDecorationImage imgDecor = PrettyQrDecorationImage(
      image: AssetImage('assets/appicon_header.png'),
      position: PrettyQrDecorationImagePosition.embedded,
    );
    return Material(
        child: SafeArea(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
          const Row(children: <Widget>[
            Icon(Icons.qr_code_rounded),
            Text("Transfer Scouting Data via QR Code")
          ]),
          const SizedBox(height: 18),
          PrettyQrView.data(
              data: data,
              decoration: PrettyQrDecoration(
                  shape: PrettyQrRoundedSymbol(
                      color: ThemeProvider.themeOf(context)
                          .data
                          .primaryColor),
                  image: imgDecor))
        ]))));
  }

  @override
  bool get maintainState => false;

  @override
  bool get opaque => true;

  @override
  Duration get transitionDuration =>
      const Duration(milliseconds: 600);
}
