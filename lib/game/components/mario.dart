import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../mario_game.dart';
import 'platform.dart';

class Mario extends PositionComponent with CollisionCallbacks, HasGameReference<MarioGame> {
  static const double speed = 400.0;
  static const double jumpSpeed = -300.0;
  static const double gravity = 500.0;
  
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool isMoving = false;
  String direction = 'right';
  
  Mario({required super.position, super.size}) {
    size = Vector2(40, 50);
  }
  
  @override
  Future<void> onLoad() async {
    // Add hitbox
    await add(RectangleHitbox());
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Save previous ground state before resetting
    final wasOnGround = isOnGround;
    
    // Reset ground state - will be set by collision detection if on platform
    isOnGround = false;
    
    // Get keyboard state from game
    final left = game.keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
                game.keysPressed.contains(LogicalKeyboardKey.keyA);
    final right = game.keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
                  game.keysPressed.contains(LogicalKeyboardKey.keyD);
    final up = game.keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
               game.keysPressed.contains(LogicalKeyboardKey.keyW) ||
               game.keysPressed.contains(LogicalKeyboardKey.space);
    
    // Handle jump (only when on ground)
    if (up && wasOnGround) {
      jump(left, right);
    }
    
    // Handle horizontal movement - allow continuous input in both air and on ground
    if (left) {
      velocity.x = -speed;
      direction = 'left';
      isMoving = true;
    } else if (right) {
      velocity.x = speed;
      direction = 'right';
      isMoving = true;
    } else {
      // When not pressing keys, only stop on ground (allow momentum in air)
      if (wasOnGround) {
        velocity.x = 0;
        isMoving = false;
      }
    }
    
    // Apply gravity
    if (!isOnGround) {
      velocity.y += gravity * dt;
    }
    
    // Clamp fall speed
    if (velocity.y > 400) {
      velocity.y = 400;
    }
    
    // Update position
    position += velocity * dt;
  }
  
  void moveLeft() {
    velocity.x = -speed;
    isMoving = true;
    direction = 'left';
  }
  
  void moveRight() {
    velocity.x = speed;
    isMoving = true;
    direction = 'right';
  }
  
  void jump(bool isMovingLeft, bool isMovingRight) {
    velocity.y = jumpSpeed;
    isOnGround = false;
    
    // Apply horizontal velocity for angled jumps
    // This allows you to jump while holding left/right arrow keys
    if (isMovingLeft) {
      velocity.x = -speed;
      direction = 'left';
    } else if (isMovingRight) {
      velocity.x = speed;
      direction = 'right';
    }
    // If neither key is pressed, jump straight up (velocity.x remains as is)
  }
  
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Platform) {
      handlePlatformCollision(other);
    }
    super.onCollisionStart(intersectionPoints, other);
  }
  
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Platform) {
      handlePlatformCollision(other);
    }
    super.onCollision(intersectionPoints, other);
  }
  
  void handlePlatformCollision(Platform platform) {
    // Check if landing on top of platform
    final platformTop = platform.position.y;
    final characterBottom = position.y + size.y;
    
    // Check if character is above or on top of the platform
    if (position.y < platformTop && characterBottom >= platformTop) {
      // Land/stand on top
      position.y = platformTop - size.y;
      velocity.y = 0;
      isOnGround = true;
    }
  }
  
  @override
  void render(Canvas canvas) {
    // Draw female character body
    final paint = Paint();
    
    // Draw face (beige/skin tone)
    paint.color = const Color(0xFFFFDBB3);
    canvas.drawCircle(const Offset(20, 25), 12, paint);
    
    // Draw hair (brown/long)
    paint.color = const Color(0xFF8B4513);
    // Hair top
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(6, 10, 28, 20),
        const Radius.circular(12),
      ),
      paint,
    );
    
    // Hair side wisps
    canvas.drawOval(const Rect.fromLTWH(2, 18, 8, 12), paint);
    canvas.drawOval(const Rect.fromLTWH(30, 18, 8, 12), paint);
    
    // Draw dress (pink)
    paint.color = const Color(0xFFFF69B4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(8, 25, 24, 25),
        const Radius.circular(8),
      ),
      paint,
    );
    
    // Draw dress top part
    canvas.drawRect(const Rect.fromLTWH(10, 25, 20, 15), paint);
    
    // Draw apron/belt (white)
    paint.color = Colors.white;
    canvas.drawRect(const Rect.fromLTWH(12, 27, 6, 8), paint);
    canvas.drawRect(const Rect.fromLTWH(22, 27, 6, 8), paint);
    canvas.drawRect(const Rect.fromLTWH(13, 30, 16, 2), paint);
    
    // Draw bow on hair
    paint.color = const Color(0xFFFF69B4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(10, 8, 8, 4),
        const Radius.circular(2),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(22, 8, 8, 4),
        const Radius.circular(2),
      ),
      paint,
    );
    
    // Draw arms
    paint.color = const Color(0xFFFFDBB3);
    canvas.drawRect(const Rect.fromLTWH(5, 22, 7, 5), paint);
    canvas.drawRect(const Rect.fromLTWH(28, 22, 7, 5), paint);
    
    // Draw legs (under dress)
    paint.color = const Color(0xFFFF69B4);
    canvas.drawRect(const Rect.fromLTWH(12, 45, 6, 5), paint);
    canvas.drawRect(const Rect.fromLTWH(22, 45, 6, 5), paint);
    
    // Draw socks (white)
    paint.color = Colors.white;
    canvas.drawRect(const Rect.fromLTWH(12, 40, 5, 8), paint);
    canvas.drawRect(const Rect.fromLTWH(23, 40, 5, 8), paint);
    
    // Draw shoes (red)
    paint.color = const Color(0xFFFF0000);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(10, 46, 8, 3),
        const Radius.circular(3),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(22, 46, 8, 3),
        const Radius.circular(3),
      ),
      paint,
    );
    
    // Draw eyes
    paint.color = const Color(0xFF000000);
    canvas.drawCircle(const Offset(16, 23), 2, paint);
    canvas.drawCircle(const Offset(24, 23), 2, paint);
    
    // Draw smile
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.5;
    paint.color = const Color(0xFF000000);
    canvas.drawArc(
      const Rect.fromLTWH(16, 24, 8, 4),
      0,
      3.14,
      false,
      paint,
    );
    
    // Flip if moving left
    if (direction == 'left') {
      canvas.translate(size.x, 0);
      canvas.scale(-1, 1);
    }
  }
}

