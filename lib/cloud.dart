//import 'dart:ui';

import 'package:flutter/widgets.dart';

// import 'constants.dart';
import 'game_object.dart';
import 'sprite.dart';

Sprite cloudSprite = Sprite()
  ..imagePath = "assets_a/image_a/ptera/cloud.png"
  ..imageWidth = 92
  ..imageHeight = 27;

class Cloud extends GameObject {
  late final Offset worldLocation;

  Cloud({required this.worldLocation});

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      (worldLocation.dx - runDistance) * 3,
      screenSize.height / 4 - cloudSprite.imageHeight - worldLocation.dy,
      cloudSprite.imageWidth.toDouble(),
      cloudSprite.imageHeight.toDouble(),
    );
  }

  @override
  Widget render() {
    return Image.asset(cloudSprite.imagePath);
  }
}
