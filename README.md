# Missile Commander

A 2024 vector graphic remake of the 1980 city defence arcade classic "Missile Command".

This file is notes about development.

## Status

An unfinished work-in-progress. Playable for 30 seconds, but the initial
wave of missiles just gradually loses steam until all the missiles have fallen
and then nothing happens.

## Source

https://github.com/tartley/missile-commander/

## Godot Scene Tree diagram

This is from memory, I should confirm the details.

  ```
  Main
  |=Screen
  | |-TitleScreen
  | | |=Title Label ?
  | |-GameOver Label ?
  |=World
  | |=ScoreLabel Label
  | |=Ground Area2D
  | | |-City Node2D (x6)
  | | |-Base Node2D (x3)
  | | | |=Turret Node2D
  | |=Mouse Node2D
  | |=Sky Node2D
  | |=Camera Camera2D
  | |-Missile Node2D  # Rain down from the sky
  | | |=Trail ParticleCPU
  | |-Shot Node2D  # Player fires upwards
  | |-BangGround? Node2D  # Missiles detonate on the ground
  | |-BangSky Node2D  # Shots or missiles detonate in the air
  | |-BangFeature Node2D  # Missiles destroy a city or base
  | |-Trail ParticleCPU  # Reparented after missile destroyed
  |=Common  # Common data members and functions
  |=Geometry  # Geometry functions
  ```

  | Where:
  | `=` Node placed in tree statically, from the Godot editor
  | `-` Node placed in tree dynamically, at run-time.
  ```

