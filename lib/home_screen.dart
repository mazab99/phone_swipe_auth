import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  List<int> selectedCirclesIndexes = [];
  Offset? currentOffset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Phone Swipe'),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: GestureDetector(
          onPanUpdate: (details) {
            final renderbox = context.findRenderObject() as RenderBox;
            final position = renderbox.globalToLocal(details.globalPosition);
            setState(() {
              currentOffset = position - const Offset(0, 50);
            });
            for (var i = 0; i < 9; i++) {
              final circlePosition = getCurrentCirclePosition(
                renderbox.size,
                3,
                i,
              );
              final distance = (circlePosition - position).distance;

              if (distance < 40 && !selectedCirclesIndexes.contains(i)) {
                if (kDebugMode) {
                  print(distance);
                }
                setState(() {
                  selectedCirclesIndexes.add(i);
                });
              }
            }
          },
          onPanEnd: (details) {
            setState(() {
              currentOffset = null;
              selectedCirclesIndexes = [];
            });
            showDialog(
              context: context,
              useSafeArea: true,
              builder: (context) {
                return Center(
                  child:  Container(
                    color: Colors.grey,
                    height: 200,
                    width: 200,
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: const Text('Mahmoud Azab',style: TextStyle(fontSize: 15),),
                  ),
                );
              },
            );
          },
          onPanStart: (details) {
            if (kDebugMode) {
              print(details.globalPosition);
            }
          },
          child: CustomPaint(
            painter: PatternPainter(
              currentOffset: currentOffset,
              selectedCirclesIndexes: selectedCirclesIndexes,
            ),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

class PatternPainter extends CustomPainter {
  PatternPainter({
    this.currentOffset,
    required this.selectedCirclesIndexes,
  });

  final Offset? currentOffset;
  final List<int> selectedCirclesIndexes;

  @override
  void paint(Canvas canvas, Size size) {
    final circlePaint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final activeCirclePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 9; i++) {
      final position = getCurrentCirclePosition(
        size,
        3,
        i,
      );
      canvas.drawCircle(
        position,
        30,
        circlePaint
          ..color =
              selectedCirclesIndexes.contains(i) ? Colors.green : Colors.white,
      );
      if (selectedCirclesIndexes.contains(i)) {
        canvas.drawCircle(
          position,
          10,
          activeCirclePaint,
        );
      }
    }

    if (selectedCirclesIndexes.isNotEmpty) {
      for (var i = 0; i < selectedCirclesIndexes.length - 1; i++) {
        final p1 = getCurrentCirclePosition(
          size,
          3,
          selectedCirclesIndexes[i],
        );
        final p2 = getCurrentCirclePosition(
          size,
          3,
          selectedCirclesIndexes[i + 1],
        );
        canvas.drawLine(
          p1,
          //+ const Offset(0, 30),
          p2,
          //- const Offset(0, 30),
          Paint()
            ..color = Colors.green
            ..strokeWidth = 2.0
            ..style = PaintingStyle.fill
            ..strokeCap = StrokeCap.round,
        );
      }
    }

    if (currentOffset != null && selectedCirclesIndexes.isNotEmpty) {
      final p1 = getCurrentCirclePosition(
        size,
        3,
        selectedCirclesIndexes.last,
      );
      canvas.drawLine(
        p1,
        //+ const Offset(0, 30),
        currentOffset!,
        Paint()
          ..color = Colors.green
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Offset getCurrentCirclePosition(Size frameSize, double dimension, int i) {
  final x = ((frameSize.width / 1.2) / dimension) * (i % dimension) +
      ((frameSize.width) / dimension) * 0.7;
  final y = ((frameSize.height / 2) / dimension) * (i ~/ dimension) +
      ((frameSize.height) / dimension) * 0.9;
  return Offset(x, y);
}
