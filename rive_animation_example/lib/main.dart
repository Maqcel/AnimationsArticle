import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() => runApp(const MaterialApp(home: HoldappLogoRiveWidget()));

class HoldappLogoRiveWidget extends StatefulWidget {
  const HoldappLogoRiveWidget({Key? key}) : super(key: key);

  @override
  State<HoldappLogoRiveWidget> createState() => _HoldappLogoRiveWidgetState();
}

class _HoldappLogoRiveWidgetState extends State<HoldappLogoRiveWidget> {
  Artboard? _riveArtboard;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/holdapp_logo.riv').then((data) {
      // Load the RiveFile from the binary data.
      final file = RiveFile.import(data);

      // The artboard is the root of the animation
      // and gets drawn in the Rive widget.
      final artboard = file.mainArtboard;
      var controller =
          StateMachineController.fromArtboard(artboard, 'State Machine 1');
      if (controller != null) {
        artboard.addController(controller);
      }
      setState(() => _riveArtboard = artboard);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: _riveArtboard != null
            ? Rive(artboard: _riveArtboard!)
            : const Center(
                child: CircularProgressIndicator(),
              ),
      );
}
