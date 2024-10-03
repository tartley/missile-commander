# Missile Commander

A 2024 vector graphic remake of the 1980 city defence arcade classic "Missile
Command".

## Status

Playable but unfinished. Missing some planned features. See [TODO.md](TODO.md).

Built executables are uploaded [to itch.io](https://tartley.itch.io/missile-commander).

## Overview

Made in Godot v4.

### Scene tree

This is from memory, I should confirm the details.

  ```
  Main Node
  |=Screen Node
  | |-TitleScreen
  | | |=Title Label ?
  | |-GameOver Label ?
  |=World Node
  | |=ScoreLabel Label
  | |=Ground Area2D
  | | |-City Node2D (x6)
  | | |-Base Node2D (x3)
  | | | |=Turret Node2D
  | |=Mouse Node2D
  | |=Sky Node2D
  | |=Camera Camera2D
  | |-Game
  | | |-Level
  | |-Bomb Node2D  # Rain down from the sky
  | | |=Trail ParticleCPU
  | |-Missile Node2D  # Player fires upwards
  | |-BangGround? Node2D  # Bombs detonate on the ground
  | |-BangSky Node2D  # Missiles or bombs detonate in the air
  | |-BangFeature Node2D  # Bombs destroy a city or base
  | |-Trail ParticleCPU  # Reparented after bomb destroyed
  |=Common  # Common data members and functions
  |=Geometry  # Geometry functions
  ```

> Where:
> `=` Node placed in tree in the Godot editor
> `-` Node placed in tree in code, at run-time.

## Release Checklist

* Update Changelog, including date on version
* Update README & README-player
* make release
* Swinging by itch.io, paste status, changelog.

