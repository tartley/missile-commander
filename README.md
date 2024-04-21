# Missile.cmd

Classic vector graphic city defence.

## Status

A work-in-progress.

## Credits

Original 1980 concept and implementation by David Theurer for Atari.

Made in [Godot](https://godotengine.org/).

Font 'Orbitron' by [Matt McInerney](http://pixelspread.com/), licensed under
the Open Font License (OFL).

Sound effects created using:
* [Sfxr](http://drpetter.se/project_sfxr.html) by Tomas "DrPetter" Pettersson.
* [Jsfxr](https://sfxr.me/) by Eric Fredricksen with contributions by Chris McCormick.
* [Chiptone](https://sfbgames.itch.io/chiptone) by Tom Vian.

This remake by Jonathan Hartley, https://tartley.com/pages/about

## TODO

* Title screen should say "use the mouse to aim"

* Automate release with version number in executable filename for:
  * Linux
  * MacOS
  * Windows
  * Web?

* mouse buttons fire

* Display a score
  See https://docs.godotengine.org/en/stable/tutorials/2d/custom_drawing_in_2d.html#drawing-text

* Incoming missiles should come in waves
  * text on screen
  * alert sound
  * fire missiles throughout the wave

* Bonus points at end of each wave
* Resurrect a city, in the least convenient position
  (prefer this over awarding a shield, since it forces player to defend
  multiple locations)

* BUG: Rarely, a falling missile can pass right through an explosion.
       Saw one fly right plain across the explode as it was at greatest radius.
       Other missiles were destroyed by that same explosion.
       Cal also reports collision detection errors.
       Consider completely removing use of godot collisions and just doing it
       myself, brute force.
* BUG: missile.gd:44 @ destroy(): Node not found: "Trail" (relative to "/root/Main/World/@Area2D@28").
         missile.gd:44 @ destroy()
         bang_sky.gd:72 @ destroy_nearby_missiles()
         bang_sky.gd:35 @ _process()
       Sometimes a destroyed missile has no trail.... hmmm...
* BUG: mouse capture reportedly doesn't work in i3
* BUG: mouse capture doesn't work in web. Perhaps my clever minimal event
       handlers are insufficient.
* BUG: fullscreen doesn't work in web, needs to be in response to a user event
       i.e. we must add a 'fullscreen' toggle button.

* A custom icon for downloadable executable

* CRT glow

* Remove Esc to immediate exit
* Pressing escape at any time goes to pause screen, which displays:
  * 'Paused'
  * 'Esc to resume'
  * 'R to restart' (if a game is in progress)
  * 'Q to quit'
* Pressing Esc resumes
* Pressing R returns to Intro
* Pressing Q quits the program
* losing focus during game also goes to this pause screen

* High score

* Credits in the game?
* Suggest a mastodon hashtag. Put in README/credits.

* City/base destruction (BangFeature) needs special effects:
  * screen shake / zoom
  * particles of the city color
  * smoke trail
  * erode base verts?
  * base turret droops?

* BangSky should fluctuate in size. Maybe it is rendered as three different
  circles, and our computed collision 'size' is the max of them? At the very
  least, this would be easier to debug/tune than my initial invisible
  attempt.
* I don't like BangSky's sound. A more regular deep bang.
  Maybe it can fluctuate along with the visual.
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
* Take a look at WorldEnvironment, gamedevacademy says it is crucual for
  atmosphere in Godot games:
  https://gamedevacademy.org/worldenvironment-in-godot-complete-guide/
* Try FSAA instead of drawing with AA=true
* Game over animation zooms into last exploding city? (And slow-mo?)
* Program start animation zooms out from central base, to reveal title, etc
* Animation on launch, to progress to Intro screen?
GPUParticles:
* Use GPU Particle systems / Compatibility renderer for web exports
* Use GPU Particle systems / Forward+ renderer for desktop (incl. MacOS)
  exports
Stars
  * on a parallax background Established ParallaxBackground Node does not
    rotate with the camera, so is no use for me. How about this Godot PR to add a
    replacement for it? https://github.com/godotengine/godot/pull/87391 When it
    lands I can apparently grab a Godot build to use.
  * Should be particles
  * Can they twinkle or delete/add over time?
* Each city has a name
* Planes or satellites fly over
* Vehicles launch missiles from the sides
* Bonus points based on time to complete a wave
* remove the thing where missiles know their target
  * ground will decide whether a feature is hit when it hears of the collision.
  * Only bother to do this if we gain missiles that steer or change target
    in-flight

