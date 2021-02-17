import 'package:flutter/material.dart';
import 'wavepainter.dart';

class SquigglyLines extends StatefulWidget {

  final Color color;
  final int wavePeriod;
  final int waveAmplitude;
  final int animDuration;

  SquigglyLines({@required this.color,
                this.animDuration=4,
                this.wavePeriod=40, this.waveAmplitude=4});

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
      duration: Duration(seconds: widget.animDuration),
    );

    final Tween<double> _tween = Tween(begin: -widget.wavePeriod.toDouble(), end: widget.wavePeriod.toDouble());
    animation = _tween.animate(controller)
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
                            widget.waveAmplitude),
          child: Container(),
        );
      },
    );
  }
}