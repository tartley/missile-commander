# Missile Command 2023

With vector graphics,
by [Jonathan Hartley](https://mastodon.social/@tartley),

A work in progress.

## Credits

Original 1980 concept and implementation by David Theurer for Atari.

Made in [Godot](https://godotengine.org/).

Sound effects created using:
* [Sfxr](http://drpetter.se/project_sfxr.html) by Tomas "DrPetter" Pettersson.
* [Jsfxr](https://sfxr.me/) by Eric Fredricksen with contributions by Chris McCormick.
* [Chiptone](https://sfbgames.itch.io/chiptone) by Tom Vian.

## TODO

* Intro screen before game starts, with:
  * game title
  * Keys: A | W or S | D to launch from each defence center
  * 'press fire to start'
  * Pressing fire starts game

* Font: Orbitron?
  https://www.theleagueofmoveabletype.com/orbitron

* All cities destroyed is game over
  * A game over screen
  * After a second or two, pressing fire returns to intro screen

* Incoming missiles come in waves
  * introduced by text on screen
  * fire missiles throughout the wave

* Display a score
  See https://docs.godotengine.org/en/stable/tutorials/2d/custom_drawing_in_2d.html#drawing-text

* Bonus points at end of each wave
* resurrect a city? Or award a shield?

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

* How to handle similarities between Nodes?
  * Inheritance: Could inherit from a common base class. Maybe sometimes,
    but be wary of inheritance hell.
* City and Base are Features? Or Destroyables?
* Turret is also a Destroyable.

* Missile and Shot are quite similar. e.g.
  * Shots should have a trail
  * Both accept a start and destination, then move towards it until
    self-destructing.

* BangMissile, BangShot, BangFeature have similarities.

* remove the thing where missiles know their target
  * ground will decide whether a feature is hit when it hears of the collision.
  * Only do this if we gain missiles that steer or change target in-flight

# Decorative / low priority

* CRT glow
* Maybe two sounds, for Source.Shot and Source.Missile.
* BangSky should fluctuate in size. Maybe it is rendered as three different
  circles, and our computed collision 'size' is the max of them? At the very
  least, this would be easier to debug/tune than my initial invisible
  attempt.
* I don't like BangSky's sound. A more regular deep bang.
  Maybe it can fluctuate along with the visual.
* BangFeature should use a different design? Or additional elements?
  * Incorporating the color of the destroyed feature?
  * particle effect using color of the destroyed feature?
  * Camera shake?
  * Sky flash?
* Base shape
* Turret recoil
* Audio listener moves with mouse
* Click1 when fire pressed but out of ammo
* Click2 when fire pressed but base is destroyed
* Speech synthesis?
* Warn beep when low ammo
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
* Stars on a parallax background Established ParallaxBackground Node does not
  rotate with the camera, so is no use for me. How about this Godot PR to add a
  replacement for it? https://github.com/godotengine/godot/pull/87391 When it
  lands I can apparently grab a Godot build to use.
* Fix draw order? (see docs/text/writing/godot-draw-order.md)

# Speculative

* Planes or satellites fly over
* Vehicles launch missiles from the sides
* Bonus points based on time to complete a wave

