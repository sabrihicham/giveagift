import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

enum CelebrateType {
  all,
  paper,
  ribbon,
  heart,
  star,
  triangle,
  circle,
  square,
}

CelebrateType celebrateTypeFromString(String type) {
  switch (type) {
    case "all":
      return CelebrateType.all;
    case "paper":
      return CelebrateType.paper;
    case "ribbon":
      return CelebrateType.ribbon;
    case "heart":
      return CelebrateType.heart;
    case "star":
      return CelebrateType.star;
    case "triangle":
      return CelebrateType.triangle;
    case "circle":
      return CelebrateType.circle;
    case "square":
      return CelebrateType.square;
    default:
      return CelebrateType.all;
  }
}

class CelebrateIcon {
  final String label;
  final String value;
  final CelebrateType type;

  CelebrateIcon({required this.label, required this.value, required this.type});

  static List<CelebrateIcon> getIcons() {
    return [
      CelebrateIcon(label: "■ ▲ ● All", value: "all", type: CelebrateType.all),
      CelebrateIcon(
          label: "🎉 paper", value: "paper", type: CelebrateType.paper),
      CelebrateIcon(
          label: "🎊 ribbon", value: "ribbon", type: CelebrateType.ribbon),
      CelebrateIcon(
          label: "❤️ heart", value: "heart", type: CelebrateType.heart),
      CelebrateIcon(label: "⭐ star", value: "star", type: CelebrateType.star),
      CelebrateIcon(
          label: "▲ triangle", value: "triangle", type: CelebrateType.triangle),
      CelebrateIcon(
          label: "● circle", value: "circle", type: CelebrateType.circle),
      CelebrateIcon(
          label: "■ square", value: "square", type: CelebrateType.square),
    ];
  }
}

class Celebrate {
  // Singlton
  static final Celebrate _instance = Celebrate._internal();

  static Celebrate get instance => _instance;

  Celebrate._internal();

  _randomInt(int min, int max) {
    return Random().nextInt(max - min) + min;
  }

  final centerNorthOption = ConfettiOptions(
    particleCount: 200,
    spread: 60,
    angle: 90,
    x: 0.5,
    y: 0.5,
  );

  final leftNorthWestOption = ConfettiOptions(
    particleCount: 200,
    spread: 60,
    angle: 45,
    x: -.1,
    y: 0.75,
  );

  final leftNorthEastOption = ConfettiOptions(
    particleCount: 200,
    spread: 60,
    angle: 135,
    x: 1.1,
    y: 0.75,
  );

  void celebrate(BuildContext context, CelebrateType type, bool bigScreen,
      {bool all = true}) {
    for (final direction in [
      centerNorthOption,
      if (all) leftNorthWestOption,
      if (all) leftNorthEastOption
    ]) {
      Confetti.launch(
        context,
        particleBuilder: (index) {
          if (type == CelebrateType.circle) {
            return Circle();
          } else if (type == CelebrateType.square) {
            return Square();
          } else if (type == CelebrateType.triangle) {
            return Triangle();
          } else if (type == CelebrateType.star) {
            return Star();
          } else if (type == CelebrateType.heart) {
            return Shape("❤️");
          } else if (type == CelebrateType.ribbon) {
            return Shape("🎊");
          } else if (type == CelebrateType.paper) {
            return Shape("🎉");
          } else {
            return [
              Circle(),
              Square(),
              Triangle(),
              Star(),
              Shape("❤️"),
              Shape("🎊"),
              Shape("🎉")
            ][_randomInt(0, 7)];
          }
        },
        options: direction.copyWith(
          spread: bigScreen ? 180 : 60,
          particleCount: bigScreen ? null : 100,
        ),
      );
    }
  }
}

class Shape extends ConfettiParticle {
  String icon;

  Shape(this.icon);

  @override
  void paint({
    required ConfettiPhysics physics,
    required Canvas canvas,
  }) {
    canvas.save();

    double x = physics.x;
    double y = physics.y;

    final paint = Paint()
      ..color = physics.color.withOpacity(1 - physics.progress);

    final textStyle = TextStyle(
      fontSize: 15,
      color: paint.color,
    );

    final textSpan = TextSpan(
      text: icon,
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: double.infinity,
    );

    // final headingMatrix = Matrix4.identity()
    //   ..setEntry(3, 2, 0.01)
    //   ..rotateX(pi / 2.25 * physics.progress * 10)
    //   ..rotateY(pi / 2.4 * physics.progress * 10);
    // // ..rotateY(pi * 2.34 * physics.progress * 2)
    // // ..rotateZ(pi * 1.23 * physics.progress * 1);

    // // rotate using heading
    // canvas.translate(x, y);
    // canvas.transform(
    //   headingMatrix.storage,
    // );
    // canvas.translate(-x, -y);

    textPainter.paint(
      canvas,
      Offset(
        x - textPainter.width / 2,
        y - textPainter.height / 2,
      ),
    );

    canvas.restore();
  }
}

class Triangle extends ConfettiParticle {
  @override
  void paint({
    required ConfettiPhysics physics,
    required Canvas canvas,
  }) {
    canvas.save();

    final path = Path()
      ..moveTo(physics.x.floor().toDouble(), physics.y.floor().toDouble())
      ..lineTo(physics.wobbleX.ceil().toDouble(), physics.y1.floor().toDouble())
      ..lineTo(physics.x2.floor().toDouble(), physics.wobbleY.ceil().toDouble())
      ..close();

    final paint = Paint()
      ..color = physics.color.withOpacity(1 - physics.progress);

    canvas.drawPath(path, paint);

    canvas.restore();
  }
}
