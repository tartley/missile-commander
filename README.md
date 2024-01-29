# Missile Command 2023

With vector graphics,
by [Jonathan Hartley](https://mastodon.social/@tartley),
using [Godot](https://godotengine.org/).

A work in progress.

## TODO

- Bases can fire Shots
  - Shots are too big
  - Shots are too fast
  - Some shots miss their destination
  - Shots should emerge from turret barrel
  - shot sound effect
  * Key repeat
  * Shots should have a trail

* Explosion should destroy missiles

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

* If Bases were in a group, would that prevent Ground having to know about
  Mouse? Then I think that unlocks the following:
* Why is city[0] the rightmost? Aha, is it that `.add_child` adds it at the
  start start of the array of children? Can we make it not do, so cities[0] is
  leftmost? Does using Groups for cities help?
* Use Groups for bases?
* World mentioned some dependency that isn't injected. Do that in World, too.
* Abandon the -y transform
* Delete the useless World node?
  * depends on abandoning the -y transform, because trying it without that was
    a mess: missiles visible but flying upwards, ground nowhere to be seen.
    (or, probably an equivalent amount of work: Tidying up the above after
    removing the World while retaining the -y transform in a Node2D root node)
* consistent angle representation, remove all the +/-PI/2 offsets.
  * get clear in my head how Vector2.angle, etc, work.
* I reparent some things to Ground, but I should probably reparent them to
  World.
* Fix draw order. Problem is we want draw order to be (back to front):

  * Sky
  * Missile
    * Trail (both initially and after missile is gone)
    * <new child which draws the Warhead, so it is in front of Trail>
  * Shot
    * Trail
    * <new child which draws the Warhead, so it is in front of Trail>
  * City
  * Base <no draw>
    * Turret
    * Foundation
  * Pop
  * Explosion
  * Mouse
  * Ground

  But we want City & Base to be children of Ground. They are positioned by the
  ground, and would move with it if it were to move (although it won't). But
  treat this as a learning exercise in tree rendering order and CanvasLayers.
  Hence we add the following layers, drawn in ascending order:

  -- layer 0
  * Sky
  * Missile <no draw>
    * Trail (both initially and after missile is gone)
    * Warhead
  * Shot <no draw>
    * Trail
    * Warhead
  -- layer 1
  * Pop
  * Explosion
  * Mouse
  * Ground <no draw>
    -- layer 0
    * City
    * Base <no draw>
      * Turret
      * Foundation
    -- layer 1
    * <new child which draws the planet surface>

  Keep ^ this reasoning around somewhere for if we need to return to it.

* Implicit Dependencies. It's currently difficult to change ground.ANGLE, mouse
  extent, or camera pan, and have everything else adjust accordingly. They have
  implicit dependencies on each other. I speculate this would be improved by
  making those dependencies explicit, and managed by World or some other high
  level node. That should define the central values they all depend on (e.g.
  planet ANGLE), and pass it down to each child that needs it. Then all deps go
  strictly from World -> (Mouse, Ground, Sky, etc), and changes can be made in
  one place.

# Low priority Features

* Fire when out of ammo is click1
* Fire when base destroyed is click2
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

