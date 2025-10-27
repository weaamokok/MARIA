import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'components/mario.dart';
import 'components/platform.dart';

class MarioGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late Mario mario;
  final Set<LogicalKeyboardKey> keysPressed = {};

  @override
  Color backgroundColor() => const Color(0xFF87CEEB);

  @override
  Future<void> onLoad() async {
    // Set up camera viewfinder first
    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.visibleGameSize = Vector2(size.x, size.y);
    
    // Create platforms first
    await _createPlatforms();

    // Create Mario standing on the ground
    // Ground is at size.y - 20, character height is 50
    // So character should start at size.y - 20 - 50 = size.y - 70
    mario = Mario(position: Vector2(50, size.y - 70));
    await add(mario);

    // Make camera follow Mario
    camera.follow(mario);
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      this.keysPressed.add(event.logicalKey);
    } else if (event is KeyUpEvent) {
      this.keysPressed.remove(event.logicalKey);
    }
    return super.onKeyEvent(event, keysPressed);
  }

  Future<void> _createPlatforms() async {
    final platforms = [
      // Ground
      Platform(
        position: Vector2(0, size.y - 20),
        size: Vector2(size.x * 3, 20),
      ),
      // Platform 1
      Platform(
        position: Vector2(300, size.y - 120),
        size: Vector2(150, 20),
      ),
      // Platform 2
      Platform(
        position: Vector2(550, size.y - 220),
        size: Vector2(150, 20),
      ),
      // Platform 3
      Platform(
        position: Vector2(850, size.y - 120),
        size: Vector2(150, 20),
      ),
      // Platform 4
      Platform(
        position: Vector2(1100, size.y - 320),
        size: Vector2(150, 20),
      ),
    ];

    for (final platform in platforms) {
      await add(platform);
    }
  }
}
