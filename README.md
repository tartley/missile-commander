# Missile Commander

2024 vector graphic remake of the 1980 city defence arcade classic "Missile Command".

## Status

An unfinished work-in-progress. Playable for 30 seconds, but the initial
wave of missiles just gradually loses steam until all the missiles have fallen
and then nothing happens.

## Credits

By Zander Hartley (aged 12) and [Jonathan Hartley](https://tartley.com/pages/about).

Original 1980 concept and implementation by David Theurer for Atari.

Font [Orbitron](https://fonts.google.com/specimen/Orbitron) by [Matt
McInerney](http://pixelspread.com/), licensed under the Open Font License (OFL).

Sound effects created using:
* [Sfxr](http://drpetter.se/project_sfxr.html) by Tomas "DrPetter" Pettersson.
* [Jsfxr](https://sfxr.me/) by Eric Fredricksen with contributions by Chris
  McCormick.
* [Chiptone](https://sfbgames.itch.io/chiptone) by Tom Vian.

Made in [Godot](https://godotengine.org/).

## Godot Scene Tree diagram

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

  = Node placed in tree statically, from the Godot editor
  - Node placed in tree dynamically, at run-time.
  ```
