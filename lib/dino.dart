//import 'dart:ui';

//import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//show Image, Rect, Size, Widget;
import 'package:flutter_dino/constants.dart';
//import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter_dino/game_object.dart';
import 'sprite.dart';

List<Sprite> dino = [
  Sprite()
    ..imagePath = "assets_a/image_a/dino_a/dino_1.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  Sprite()
    ..imagePath = "assets_a/image_a/dino_a/dino_2.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  Sprite()
    ..imagePath = "assets_a/image_a/dino_a/dino_3.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  Sprite()
    ..imagePath = "assets_a/image_a/dino_a/dino_4.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  Sprite()
    ..imagePath = "assets_a/image_a/dino_a/dino_5.png"
    ..imageWidth = 88
    ..imageHeight = 94,
  Sprite()
    ..imagePath = "assets_a/image_a/dino_a/dino_6.png"
    ..imageWidth = 88
    ..imageHeight = 94
];

enum DinoState {
  // ignore: prefer_typing_uninitialized_variables
  jumping,
  dead,
  // ignore: prefer_typing_uninitialized_variables
  running;
}

class Dino extends GameObject {
  Sprite currentSprite = dino[0];
  double dispY = 0;
  double velY = 0;
  DinoState state = DinoState.running;
  @override
  Widget render() {
    return Image.asset(currentSprite.imagePath);
  }

  @override
  Rect getRect(Size screenSize, double runDistance) {
    return Rect.fromLTWH(
      screenSize.width / 10,
      screenSize.height / 2 - currentSprite.imageHeight - dispY,
      currentSprite.imageWidth.toDouble(),
      currentSprite.imageHeight.toDouble(),
    );
  }

  @override
  void update(Duration lastUpdate, Duration elapsedTime) {
    currentSprite = dino[(elapsedTime.inMilliseconds / 100).floor() % 2 + 2];
    double elapsedTimeSeconds =
        (elapsedTime - lastUpdate).inMilliseconds / 1000;
    dispY += velY * elapsedTimeSeconds;
    if (dispY <= 0) {
      dispY = 0;
      velY = 0;
      state = DinoState.running;
    } else {
      velY -= gravity * elapsedTimeSeconds;
    }
  }

  void jump() {
    if (state != DinoState.jumping) {
      state = DinoState.jumping;

      velY = 850;
    }
  }

  void die() {
    currentSprite = dino[5];
    state = DinoState.dead;
  }

  void reset() {}
}
