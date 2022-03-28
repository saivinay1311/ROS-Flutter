import 'dart:ui';
import 'dart:math' as math;

import 'package:controller/pose_publisher.dart';
import 'package:flutter/material.dart';

var x_cor;
var y_cor;

class MapViewer extends StatefulWidget {
  final double x_cor;
  final double y_cor;

  const MapViewer(this.x_cor, this.y_cor);

  @override
  _MapViewerState createState() => _MapViewerState();
}

class _MapViewerState extends State<MapViewer> {
  @override
  Widget build(BuildContext context) {
    x_cor = widget.x_cor;
    y_cor = widget.y_cor;
    return InteractiveViewer(
      minScale: 1,
      maxScale: 3,
      panEnabled: true,
      child: Container(
        width: 350,
        height: 350,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.black, Colors.grey])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // const SizedBox(
            //   height: 50,
            // ),
            Stack(
              children: <Widget>[
                Positioned(
                    child: Transform.rotate(
                  angle: -math.pi,
                  child: Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white54, width: 2),
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                            image: AssetImage('assets/map.jpg'),
                            fit: BoxFit.fill)),
                  ),
                )),
                Positioned(
                  top: 80,
                  left: 240,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(children: [
                      const SizedBox(
                        height: 50,
                        width: 50,
                      ),
                      Container(
                        child: Transform.rotate(
                          angle: math.pi / 2,
                          child: CustomPaint(
                            willChange: true,
                            painter: ShapePainter(),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  Size size = const Size(500, 500);
  @override
  void paint(Canvas canvas, size) {
    var paint2 = Paint();
    var paint1 = Paint();
    var paint3 = Paint();

    paint1.color = const Color(0xff63aa65);
    paint1.strokeCap = StrokeCap.round;
    paint1.strokeWidth = 1;

    paint2.color = Color.fromARGB(255, 12, 28, 167);
    paint2.strokeCap = StrokeCap.round;
    paint2.strokeWidth = 3;

    paint3.color = Color.fromARGB(255, 167, 12, 12);
    paint3.strokeCap = StrokeCap.butt;
    paint3.strokeWidth = 10;

    int x_mulitplier = 14;
    double y_multiplier = 14;

    var point_new = [
      Offset((7.0250 - 7.0250) * y_multiplier,
          (6.050000000 - 6.050000000) * x_mulitplier),
      Offset(-(7.0272 - 7.0250) * y_multiplier,
          (7.3204 - 6.050000000) * x_mulitplier),
      Offset((7.0295 - 7.0250) * y_multiplier,
          (8.590 - 6.050000000) * x_mulitplier),
      Offset((7.0318 - 7.0250) * y_multiplier,
          (9.8613 - 6.050000000) * x_mulitplier),
      Offset((7.034 - 7.0250) * y_multiplier,
          (11.13 - 6.050000000) * x_mulitplier),
      Offset((7.0363 - 7.0250) * y_multiplier,
          (12.402 - 6.050000000) * x_mulitplier),
      Offset((7.0386 - 7.0250) * y_multiplier,
          (13.672 - 6.050000000) * x_mulitplier),
      Offset((7.040 - 7.0250) * y_multiplier,
          (14.94 - 6.050000000) * x_mulitplier),
      Offset((7.043 - 7.0250) * y_multiplier,
          (16.213 - 6.050000000) * x_mulitplier),
      Offset((7.045 - 7.0250) * y_multiplier,
          (17.484 - 6.050000000) * x_mulitplier),
      Offset((7.0477 - 7.0250) * y_multiplier,
          (18.754 - 6.050000000) * x_mulitplier),
      Offset(
          (7.05 - 7.0250) * y_multiplier, (20.02 - 6.050000000) * x_mulitplier),
      Offset((8.2687 - 7.0250) * y_multiplier,
          (20.018 - 6.050000000) * x_mulitplier),
      Offset((9.4875 - 7.0250) * y_multiplier,
          (20.012 - 6.050000000) * x_mulitplier),
      Offset((10.706 - 7.0250) * y_multiplier,
          (20.012 - 6.050000000) * x_mulitplier),
      Offset((11.925 - 7.0250) * y_multiplier,
          (20.0062 - 6.050000000) * x_mulitplier),
      Offset((11.937 - 7.0250) * y_multiplier,
          (21.625 - 6.050000000) * x_mulitplier),
      Offset((11.95 - 7.0250) * y_multiplier,
          (23.25 - 6.050000000) * x_mulitplier),
    ];

    // var points = [
    //   //Offset((9.443 / 10) * 100, (6.811 / 10) * 100),
    //   Offset(-(6.810 - 6.811) * y_multiplier, (9.443 - 9.443) * x_mulitplier),
    //   Offset(-(6.811 - 6.811) * y_multiplier, (10.721 - 9.443) * x_mulitplier),
    //   Offset(-(6.812 - 6.811) * y_multiplier, (11.99 - 9.443) * x_mulitplier),
    //   Offset(-(6.813 - 6.811) * y_multiplier, (13.27 - 9.443) * x_mulitplier),
    //   Offset(-(6.814 - 6.811) * y_multiplier, (14.55 - 9.443) * x_mulitplier),
    //   Offset(-(6.815 - 6.811) * y_multiplier, (15.83 - 9.443) * x_mulitplier),
    //   Offset(-(6.816 - 6.811) * y_multiplier, (17.10 - 9.443) * x_mulitplier),

    //   Offset(-(6.817 - 6.811) * y_multiplier, (18.38 - 9.443) * x_mulitplier),
    //   Offset(-(6.818 - 6.811) * y_multiplier, (19.66 - 9.443) * x_mulitplier),
    //   Offset(-(6.819 - 6.811) * y_multiplier, (20.93 - 9.443) * x_mulitplier),
    //   Offset(-(6.821 - 6.811) * y_multiplier, (22.21 - 9.443) * x_mulitplier),
    //   Offset(-(6.82 - 6.811) * y_multiplier, (23.49 - 9.443) * x_mulitplier),
    //   Offset(-(5.892 - 6.811) * y_multiplier, (23.53 - 9.443) * x_mulitplier),
    //   Offset(-(5.887 - 6.811) * y_multiplier, (22.25 - 9.443) * x_mulitplier),
    //   Offset(-(5.882 - 6.811) * y_multiplier, (20.97 - 9.443) * x_mulitplier),
    //   Offset(-(5.877 - 6.811) * y_multiplier, (19.69 - 9.443) * x_mulitplier),
    //   Offset(-(5.871 - 6.811) * y_multiplier, (18.41 - 9.443) * x_mulitplier),
    //   Offset(-(5.866 - 6.811) * y_multiplier, (17.13 - 9.443) * x_mulitplier),
    //   Offset(-(5.861 - 6.811) * y_multiplier, (15.85 - 9.443) * x_mulitplier),
    //   Offset(-(5.856 - 6.811) * y_multiplier, (14.57 - 9.443) * x_mulitplier),
    //   Offset(-(5.850 - 6.811) * y_multiplier, (13.29 - 9.443) * x_mulitplier),
    //   Offset(-(5.845 - 6.811) * y_multiplier, (12.01 - 9.443) * x_mulitplier),
    //   Offset(-(5.840 - 6.811) * y_multiplier, (10.73 - 9.443) * x_mulitplier),
    //   Offset(-(5.834 - 6.811) * y_multiplier, (9.453 - 9.443) * x_mulitplier),

    //   Offset(-(5.860 - 6.811) * y_multiplier, (17.11 - 9.443) * x_mulitplier),
    //   Offset(-(6.805 - 6.811) * y_multiplier, (17.07 - 9.443) * x_mulitplier),
    //   Offset(-(6.809 - 6.811) * y_multiplier, (18.54 - 9.443) * x_mulitplier),
    //   Offset(-(6.813 - 6.811) * y_multiplier, (20.01 - 9.443) * x_mulitplier),
    //   Offset(-(5.884 - 6.811) * y_multiplier, (20.01 - 9.443) * x_mulitplier),

    //   Offset(-(5.834 - 6.811) * y_multiplier, (9.453 - 9.443) * x_mulitplier),
    //   Offset(-(6.810 - 6.811) * y_multiplier, (9.443 - 9.443) * x_mulitplier),

    //   Offset(-(6.813 - 6.811) * y_multiplier, (13.27 - 9.443) * x_mulitplier),
    //   Offset(-(5.850 - 6.811) * y_multiplier, (13.29 - 9.443) * x_mulitplier),
    // ];

    // var bot_cor = [
    //   Offset((y_cor - 0.18) * y_multiplier, (x_cor + 3.14) * x_mulitplier)
    // ];

    var bot_cor = [
      Offset((x_cor - 0.1) * x_mulitplier, (y_cor + 3.00) * y_multiplier)
    ];

    for (int i = 0; i < point_new.length - 1; i++) {
      //print(i);
      canvas.drawLine(point_new[i], point_new[i + 1], paint1);
    }
    canvas.drawPoints(PointMode.points, point_new, paint2);

    canvas.drawPoints(PointMode.points, bot_cor, paint3);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
