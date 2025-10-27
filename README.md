# MARIA - A Mario-like Game

A simple and fun Mario-style platformer game built with Flutter and the Flame game engine.

## Features

- **Simple Controls**: Move left and right, jump
- **Character**: Female character with pink dress and long hair
- **Platform Mechanics**: Jump and land on platforms
- **Gravity Physics**: Realistic gravity and collision detection
- **Clean UI**: Simple and clear game interface

## Controls

- **Arrow Keys** or **WASD**: Move left/right and jump
- **W or Up Arrow**: Jump
- **A/Left Arrow**: Move left
- **D/Right Arrow**: Move right

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK

### Installation

1. Clone the repository
2. Navigate to the project directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the Game

```bash
flutter run
```

## How to Play

1. Use arrow keys or WASD to control the character
2. Jump between platforms by pressing W or the Up arrow
3. Collect coins and avoid enemies (future features)
4. Reach the end of the level to win!

## Game Mechanics

- **Movement**: Character can move left and right at a constant speed
- **Jumping**: Single jump ability with gravity-based physics
- **Collision Detection**: Character lands on platforms and the ground
- **Camera Follow**: Camera automatically follows the character as she moves

## Technologies Used

- **Flutter**: UI framework
- **Flame**: 2D game engine for Flutter
- **Dart**: Programming language

## Project Structure

```
lib/
├── main.dart              # App entry point
└── game/
    ├── mario_game.dart    # Main game class
    └── components/
        ├── mario.dart     # Character (female)
        └── platform.dart  # Platform/brick blocks
```

## Future Enhancements

- Enemies and obstacles
- Collectible coins
- Multiple levels
- Power-ups
- Sound effects and background music
- Score system
- More complex level design

## License

This project is open source and available for educational purposes.

## Credits

Created with Flutter and Flame game engine.
