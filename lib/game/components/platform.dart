import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class Platform extends PositionComponent with CollisionCallbacks {
  Platform({required super.position, required super.size});
  
  @override
  Future<void> onLoad() async {
    // Add hitbox
    await add(RectangleHitbox());
  }
  
  @override
  void render(Canvas canvas) {
    // Draw platform with brick texture
    final paint = Paint();
    
    // Base color
    paint.color = const Color(0xFF8B4513);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      paint,
    );
    
    // Brick pattern
    paint.color = const Color(0xFFA0522D);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;
    
    const brickWidth = 30.0;
    const brickHeight = 10.0;
    
    for (double x = 0; x < size.x; x += brickWidth) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.y),
        paint,
      );
    }
    
    for (double y = 0; y < size.y; y += brickHeight) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.x, y),
        paint,
      );
    }
    
    // Shadow line for depth
    paint.color = const Color(0x33000000);
    canvas.drawRect(
      Rect.fromLTWH(0, size.y - 2, size.x, 2),
      paint,
    );
    
    paint.color = const Color(0x4DFFFFFF);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, 1),
      paint,
    );
  }
}

