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

* Restore Ground rendering to the parent node, delete that child, and set
  .show_behind_parent for Cities, Bases, etc.

* Fix draw order:

## Problem

  Problem is, in this simplified scene tree:

  * Sky
  * Missile
    * Trail
  * Explosion
  * MouseCursor
  * Ground
    * City
    * GroundRender

  ...we want City to render in in between Missiles and Explosions.

## Solutions

1. Keep the tree as-is, and assign a Canvas Layer to everything. This has the
   advantage that it should still work no matter how the tree changes in
   future.

  Hence we can add a CanvasLayer to split apart the children of Ground,
  and that lets us rearrange the tree:

  * Sky
  * Missile
    * Trail
  * Ground  # moved from bottom/frontmost
    * City
    * CanvasLayer 1  # keeps GroundRender in front of *everything*
      * GroundRender
  * Pop
  * Explosion
  * Mouse

2. Abandon the idea of bases and cities being children of the ground, which was
   always a bit academic because we aren't actually going to *move* the ground,
   etc. Hence:

  * Sky
  * Missile
    * Trail
  * Shot
    * Trail
  * City           # moved from within Ground
  * Base           #
    * Turret       #
    * Foundation   #
  * Pop
  * Explosion
  * Mouse
  * Ground
    * GroundRender # maybe not even required any more?

  I don't like this option though because this seems like ideal practice for a
  later game of Asteroids, which definitely WILL move, taking any bases, etc,
  with them.

3. Part of this is that we also need to group similar items together, which
   doesn't currently happen. This will be more of an issue when Missiles are
   getting added dynamically during a level.

Hence, for example, put all Missiles, and their Trails, into a 'Missiles' node.

- singleton node
* multiple nodes

  - Sky
  - Trails
    * Trail (after missile is gone)
  - Missiles
    * Missile
      * Trail (initially)
      * MissileRender
  - Shots
    * Shot
      * Trail (initially)
      * ShotRender
  - Pops
    * Pop
  - Explosions
    * Explosion
  - Mouse
  - Ground
    - Features
      * City
      * Base
        - Turret
        - Foundation
    - GroundRender

Phew. I don't yet see how I can avoid having to do this, PLUS then (1) or (2)
above. Maybe ask on the forums!

* Missile and Shot have similarities.
  * Both requrie a new child node so that trails appear behind warheads
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

# Godot Lessons

## Order of calls

### _init()

First we call `_init`, going straight down the scene tree:

    1 - Main
    2   - Sky
    3   - Ground
    4     - Base1
    5     - City1

Parents cannot access their children, which do not yet exist.

### _ready()

Then we call `_ready` as we add nodes to the tree, going downwards but children
first:

    5 - Main
    1   - Sky (Start with children of Main, in order)
    4   - Ground (But cannot do Ground until we've done its children)
    2     - Base1
    3     - City1

Parents can access their children, which have already been both created
*and* added to the tree.

## _draw()

Just like `_init`, objects are drawn in the order of the scene tree, with
later entries obscuring earlier ones, ie. back to front:

    1 - Main (background)
    2   - Sky
    3   - Ground
    4     - Base1
    5     - City1 (foreground)

### Ordering, between siblings

For more control over the draw order of siblings, set the ordering property.
For example, if adding and deleting a lot of children from a parent, setting
some children to 'ordering=2' will keep those nodes in front. But this can
only affect interactions between direct siblings.

### Drawing parents before their children

According to all the above, a parent is drawn behind all its children. If you
want it in front of some of the children, then set the child's
`.show_behind_parent`.

(The above para replaces a section about the hack of moving the parent's
draw code into a new final child.)

### CanvasLayer, total control

This draw order can be overridden with CanvasLayers, added as tree nodes.
TODO read https://docs.godotengine.org/en/4.2/tutorials/2d/canvas_layers.html
e.g. To draw an explosion, parented to Main, in front of Bases but behind
Cities:

    1 - Main
    2   - Sky
    3   - Ground
    4     - Base1 (show behind parent = true)
          - CanvasLayer 1
    6       - City1 (show behind parent = true)
    5   - Explosion

Hence layer 1 rendering draws everything except the City, with Explosion
on top, then it draws the City on top of that.

