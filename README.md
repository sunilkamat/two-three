# TwoThree

A fun and challenging iOS game where you shoot numbers to reduce falling blocks to zero. The game combines quick reflexes with mathematical thinking.

## Game Overview

In TwoThree, you control a launcher that can shoot two different numbers (2 and 3) at falling blocks. The goal is to reduce the numbers on the falling blocks to zero by shooting the appropriate number at them.

### Features

- **Tilt Controls**: Use your phone's tilt to aim the launcher
- **Dual Shooting**: Shoot number 2 by touching the left side of the screen, or number 3 by touching the right side
- **Progressive Difficulty**: 
  - Blocks fall faster as you progress through levels
  - Level increases every 50 points
  - Gravity increases by 0.05 for each level
- **Scoring System**: 
  - Points for each number you subtract
  - Bonus points for perfect zero matches
- **High Scores**: Track your best performances with player names
- **Visual Indicators**: Clear on-screen indicators for number 2 and 3 shooting zones
- **Level Display**: Current level shown in the top-right corner

## How to Play

1. **Aim the Launcher**:
   - Tilt your phone left or right to aim the launcher
   - The launcher will follow your phone's tilt

2. **Shoot Numbers**:
   - Touch the left side of the screen to shoot number 2
   - Touch the right side of the screen to shoot number 3
   - Projectiles spawn from the center of the launcher's base

3. **Match Numbers**:
   - Shoot numbers at falling blocks to reduce their value
   - For example, if a block shows "5", shoot a "2" to make it "3"
   - Get perfect matches (reducing to zero) for bonus points

4. **Progress**:
   - The launcher moves up when blocks pass it
   - Game ends if the launcher reaches 75% of the screen height
   - Level increases every 50 points
   - Blocks fall faster with each level

## Technical Details

- Built with SpriteKit and Swift
- Uses CoreMotion for tilt controls
- Implements physics-based gameplay
- Stores high scores using UserDefaults
- Projectiles spawn from the center of the launcher's semi-circular base
- Visual indicators show shooting zones for numbers 2 and 3

## Requirements

- iOS 13.0 or later
- Xcode 13.0 or later
- Swift 5.0 or later

## Installation

1. Clone the repository
2. Open the project in Xcode
3. Build and run on your iOS device or simulator

## Development

The game is structured with the following main components:
- `GameScene.swift`: Main game logic and scene management
- `GameViewController.swift`: Game view controller setup

> **Note:** This project was developed using Cursor AI Code Editor with minimal manual intervention, demonstrating the power of AI-assisted development.

## License

This project is available under the MIT License. See the LICENSE file for more info. 