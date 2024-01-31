# Missile Command 2023

With vector graphics,
by [Jonathan Hartley](https://mastodon.social/@tartley),
using [Godot](https://godotengine.org/).

A work in progress.

## TODO

* Missiles emit 'strike' event. Ground listens, decides whether Pop or
  Detonation (& destroyed feature) results. (I think this is how it already
  works. I'm just getting clarity). Whereas:
* Shots directly cause an Explosion, which does collision check to destroy
  Missiles.
* Missile and Shot are quite similar. e.g.
  * Shots should have a trail
  * Both accept a start and destination, then move towards it until
    self-destructing. Are they actually the same class?

* Display ammo under each base
* Firing a shot reduces ammo from that base

* Intro screen before game starts, with:
  * game title
  * Keys: A | W or S | D to launch from each defence center
  * 'press fire to start'
  * Pressing fire starts game
  * Display keys here? Yeah, I guess.

* All cities destroyed is game over
  * A game over screen
  * After a second or two, pressing fire returns to intro screen

* Display a score
  See https://docs.godotengine.org/en/stable/tutorials/2d/custom_drawing_in_2d.html#drawing-text

* Incoming missiles come in waves
  * introduced by text on screen
  * Director (find a better name) fires missiles throughout the
    wave
  * When a wave ends, give bonus points

* Pressing escape at any time goes to pause screen, which displays:
  * 'Paused'
  * 'Esc to resume'
  * 'I to start over' (if a game is in progress)
  * 'Y to quit'
* Pressing Esc resumes
* Pressing I returns to Intro
* Pressing Y quits the program
* losing focus during game also goes to this pause screen

* City destruction needs special effects:
  * explosion: Maybe regular explosion is small, thin expanding ring,
    city explosion is larger, longer lived, thicker ring, starting as a white
    hot circle.
  * sound effect. Mix a subtle wail in with the effect
  * screen shake / zoom?
* base destruction also needs special effects. Mix an alert in?

* High score

* Rename for findability?
  * Missile Commander
  * Mslcmd
  * msl.cmd (in use by some '100 plays' musician)
  * Missile.cmd

* Include credits to original game designers
* Suggest a mastodon hashtag

# Refactors

* Missile and Shot have similarities.
* Base and City have similarities.
* Turret and Foundation have some similar similarities (ie being destroyable) ^
  Do they inherit from the same base class? Maybe prefer composition over
  inheritance, a parent no-draw node owns a child of type 'HasVerts' or
  'HasVertsDestroyable'
* Pop, Explosion and Detonation (city/base destruction?) have similarities.

# Low priority Features

* Click1 when fire pressed but out of ammo
* Click2 when fire pressed but base is destroyed
* Warn beep when low ammo
* Audio listener moves with mouse
* More particle effects:
  * Trail on shots, somewhat like missile
  * Shot launch
  * pop
  * explosion
  * city destroy (red particles?)
  * base destroy (yellow particles?)
  * stars
* Take a look at WorldEnvironment, gamedevacademy says it is crucual for
  atmosphere in Godot games:
  https://gamedevacademy.org/worldenvironment-in-godot-complete-guide/
* Try FSAA instead of drawing with AA=true
* Game out animation zooms into last exploding city? (And slow-mo?)
* Program start animation zooms out from central base, to reveal title, etc
* Attract mode animations while waiting on Intro screen?
* Animation on launch, to progress to Intro screen?
* GPUParticles:
  * Use GPU Particle systems / Compatibility renderer for web exports
  * Use GPU Particle systems / Forward+ renderer for desktop (incl. MacOS)
    exports
  * Use for stars in the sky? Can we make them twinkle or delete/add over time?
* prettier explosions.
* Destroyed city gains smoke
* Undestroyed city loses smoke
* Each city has a name
* Stars on a parallax background
  https://docs.godotengine.org/en/stable/classes/class_parallaxbackground.html
  or that github issue I commented on or that links to a newer PR against Godot
  to add a replacement for ParalaxBackground
* Fix draw order? (see docs/text/writing/godot-draw-order.md)

