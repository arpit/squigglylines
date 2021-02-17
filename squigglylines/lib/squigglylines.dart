import 'package:flutter/material.dart';
import 'wavepainter.dart';

class SquigglyLines extends StatefulWidget {

  final Color color;
  final int wavePeriod;
  final int waveOffset;
  final int waveAmplitude;

  SquigglyLines({@required this.color, this.wavePeriod=40, this.waveOffset=10, this.waveAmplitude=4});

  @override
  _SquigglyLinesState createState() => _SquigglyLinesState();
}

class _SquigglyLinesState extends State<SquigglyLines> with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    final Tween<double> _radiusTween = Tween(begin: 0.0, end: 200);
    animation = _radiusTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, snapshot) {
        return CustomPaint(
          painter: WavePainter(animation.value,
                            widget.color,
                            widget.wavePeriod,
                            widget.waveOffset,
                            widget.waveAmplitude),
          child: Container(),
        );
      },
    );
  }
}