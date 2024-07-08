import 'dart:math';
//import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'cacti.dart';
import 'cloud.dart';
import 'dino.dart';
//import 'game_object.dart';
import 'dart:core';
import 'game_object.dart';
import 'ground.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Flame.util.fullScreen();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ' '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Dino dino = Dino();
  double runDistance = 0;
  double runvelocity = 40;
  int speedIncreaseScore = 50;
  //double speedIncreaseAmount = 20;

  late AnimationController worldController;
  Duration lastUpdateCall = const Duration();
  List<Cactus> cacti = [Cactus(worldLocation: const Offset(200, 0))];
  List<Ground> ground = [
    Ground(worldLocation: const Offset(10, 0)),
    Ground(worldLocation: Offset(groundSprite.imageWidth / 10, 0))
  ];
  List<Cloud> clouds = [
    Cloud(worldLocation: const Offset(100, 20)),
    Cloud(worldLocation: const Offset(200, 10)),
    Cloud(worldLocation: const Offset(350, -10)),
  ];

  int score = 0;
  int highestScore = 0;

  @override
  void initState() {
    super.initState();

    worldController =
        AnimationController(vsync: this, duration: const Duration(days: 100));
    worldController.addListener(_update);
    worldController.forward();
  }

  void _update() {
    dino.update(lastUpdateCall, worldController.lastElapsedDuration!);
    double elapsedTimeSeconds =
        (worldController.lastElapsedDuration! - lastUpdateCall).inMilliseconds /
            1000;
    runDistance += runvelocity * elapsedTimeSeconds;

    Size screenSize = MediaQuery.of(context).size;
    Rect dinoRect = dino.getRect(screenSize, runDistance);

    // Increment score based on elapsed time or distance
    score = (runDistance / 18)
        .floor(); // Example: 1 point for every 10 units of distance

    for (Cactus cactus in cacti) {
      Rect obstacleRect = cactus.getRect(screenSize, runDistance);
      if (dinoRect.overlaps(obstacleRect.deflate(5))) {
        _die();
      }
      if (obstacleRect.right < 0) {
        setState(() {
          cacti.remove(cactus);
          cacti.add(Cactus(
              worldLocation:
                  Offset(runDistance + Random().nextInt(80) + 100, 0)));
        });
      }
    }

    if (score >= speedIncreaseScore) {
      speedIncreaseScore += 20; // Increase the score threshold
      runvelocity += 15; // Increase the speed
    }

    for (Ground groundlet in ground) {
      if (groundlet.getRect(screenSize, runDistance).right < 0) {
        setState(() {
          ground.remove(groundlet);
          ground.add(Ground(
              worldLocation: Offset(
                  ground.last.worldLocation.dx + groundSprite.imageWidth / 10,
                  0)));
        });
      }
    }
    for (Cloud cloud in clouds) {
      if (cloud.getRect(screenSize, runDistance).right < 0) {
        setState(() {
          clouds.remove(cloud);
          clouds.add(Cloud(
              worldLocation: Offset(
                  clouds.last.worldLocation.dx + Random().nextInt(100) + 50,
                  Random().nextInt(30) - 20.0)));
        });
      }
    }
    lastUpdateCall = worldController.lastElapsedDuration!;
  }

  void _die() {
    setState(() {
      worldController.stop();
      dino.die();
      if (score > highestScore) {
        highestScore = score;
      }
      score = 0;
      runDistance = 0; // Reset run distance
      runvelocity = 40; // Reset run velocity
      speedIncreaseScore = 50; // Reset speed increase score
      cacti.clear(); // Reset cacti
      cacti = [Cactus(worldLocation: const Offset(200, 0))];
      ground.clear(); // Reset ground
      ground = [
        Ground(worldLocation: const Offset(-280, 0)),
        Ground(worldLocation: Offset(groundSprite.imageWidth / 25, 0))
      ];
      clouds = [
        // Reset clouds
        Cloud(worldLocation: const Offset(100, 20)),
        Cloud(worldLocation: const Offset(200, 10)),
        Cloud(worldLocation: const Offset(350, -10)),
      ];
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Container(
            margin: const EdgeInsets.symmetric(vertical: 25),
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 106, 79, 79).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Your score: $highestScore',
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        );
      },
    );
  }

  // void _die() {
  //   setState(() {
  //     worldController.stop();
  //     dino.die();
  //     if (score > highestScore) {
  //       highestScore = score;
  //     }
  //     score = 0;
  //   });

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Game Over'),
  //         content: Container(
  //           margin: const EdgeInsets.symmetric(vertical: 25),
  //           padding: const EdgeInsets.only(top: 20),
  //           decoration: BoxDecoration(
  //             color: const Color.fromARGB(255, 106, 79, 79).withOpacity(0.2),
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           child: Text(
  //             'Your score: $highestScore',
  //             style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //         contentPadding: const EdgeInsets.symmetric(horizontal: 20),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    List<Widget> children = [];

    for (GameObject object in [...clouds, ...ground, ...cacti, dino]) {
      children.add(AnimatedBuilder(
          animation: worldController,
          builder: (context, _) {
            Rect objectRect = object.getRect(screenSize, runDistance);
            return Positioned(
              left: objectRect.left,
              top: objectRect.top,
              width: objectRect.width,
              height: objectRect.height,
              child: object.render(),
            );
          }));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          dino.jump();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 20,
              right: 20,
              child: Text(
                'Score: $score\nHighest Score: $highestScore',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ...children, // Add the existing children here
          ],
        ),
      ),
    );
  }
}
