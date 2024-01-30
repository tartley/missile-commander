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
    * <new child which draws the Warhead, so it is in front of Trail>
  * Shot <no draw>
    * Trail
    * <new child which draws the Warhead, so it is in front of Trail>
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

* Base and City have similarities. Do they inherit from the same base class?
* Pop, Explosion and Detonation (city/base destruction?) have similarities.
* Implicit Dependencies. It's currently difficult to change ground.ANGLE, mouse
  extent, or camera pan, and have everything else adjust accordingly. They have
  implicit dependencies on each other. I speculate this would be improved by
  making those dependencies explicit, and managed by World or some other high
  level node. That should define the central values they all depend on (e.g.
  planet ANGLE), and pass it down to each child that needs it. Then all deps go
  strictly from World -> (Mouse, Ground, Sky, etc), and changes can be made in
  one place.

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

# Godot Lessons

## Draw Order

Objects are drawn obscuring each other (as if back to front) in the order
of the scene tree:

    1 Main
    2 - Sky
    3 - Ground
    4   - Base1
    5   - City1
    6   - City2
    7   - Base1

Hence, a parent is drawn behind all its children. If you want it in front of
some of the children, then create a new parent node which draws nothing,
the children of which are the old parent and all its children, in the
required order:

    1 Main
    2 - Sky
      - GroundRoot <new parent, not drawn>
    3   - Base1
    4   - City1
    5   - City2
    6   - Base1
    7   - Ground <old parent, in front of other children>

Sometimes you want a node from elsewhere in the scene tree to be drawn
in-between siblings. For example, if need Explosion to be parented to
Main, but be rendered in-between (Cities & Bases), and the Ground.

The solution to this is to use CanvasLayers. Each Node2D has a CanvasLayer,
defaulting to value 0. Nodes with a higher canvas layer are drawn in front,
in a separate pass through the scene tree. eg:

    1 Main
    2 - Sky
      - GroundRoot <new parent, not drawn>
    3   - Base1
    4   - City1
    5   - City2
    6   - Base1
    8   - Ground <layer 1>
    7 - Explosion <layer 0>

Hence layer 1 rendering draws everything except the ground, with Explosion
on top, then it draws the Ground on top of that.

## Order of calls

First we call `_init`, going straight down the scene tree:

1 - Main._init
2   - Sky._init
3   - Ground._init

Then we call `_ready` as we add nodes to the tree, going downwards but children
first:

3 - Main._ready
1   - Sky._ready
2   - Ground._ready

