# Missile Commander

A 2024 vector graphic remake of the 1980 city defence arcade classic "Missile
Command".

## Status

An unfinished work-in-progress. Playable for a minute, but the waves of falling
bombs are not remotely balanced for difficulty.

See [TODO.md](TODO.md), and [README-players.md](README-players.md).

## Links

To play or download: https://tartley.itch.io/missile-commander

Source code: https://github.com/tartley/missile-commander

## Godot Scene Tree diagram

This is from memory, I should confirm the details.

  ```
  Main Node
  |=Screen Node
  | |-TitleScreen
  | | |=Title Label ?
  | |-GameOver Label ?
  | |=Labels Node2D
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
> `=` Node placed in tree statically, from the Godot editor
> `-` Node placed in tree dynamically, at run-time.

## Release Checklist

* Update Changelog, including date on version
* make release
* Consider swinging by itch.io and pasting changelog into there.

