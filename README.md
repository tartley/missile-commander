# Missile Command 2023

With vector graphics,
by [Jonathan Hartley](https://mastodon.social/@tartley),
using [Godot](https://godotengine.org/).

A work in progress.

## TODO

* Bases have tiny turrets on
  * Are they quite right? Should I use this mess calculating the angle
    as incentive to get rid of the -y thing now?
  * find a better shape for them. Just a rectangle, perhaps.

* City destruction needs special effects:
  * explosion
  * sound effect
  * screen shake / zoom?

* base destruction also needs special effects

* Bases can fire Shots
* shot sound effect
* Shots explode at destination
* explosion sound effect
* Explosion destroys missiles
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

* High score

* Rename to 'Missile Commander' for findability?

* Include credits to original game designers
* Suggest a mastodon hashtag

# Refactors

* Consider using TAU
* Abandon the -y transform
* Delete the useless World node
  * depends on abandoning the -y transform, because trying it without that
    was a mess: missiles visible but flying upwards, ground nowhere to be
    seen. (or, probably an equivalent amount of work: Tidying up the above
    after removing the World while retaining the -y transform in a Node2D
    root node)
* consistent angle representation, remove all the +/-PI/2 offsets.

# Low priority Features

* Attract mode animations on Intro screen?
* Animation on launch, to progress to Intro screen?
* GPUParticles:
  * Use GPU Particle systems / Compatibility renderer for web exports
  * Use GPU Particle systems / Forward+ renderer for desktop (incl. MacOS) exports
* prettier explosions.
* stars in the sky as a particle system
* Destroyed city gains smoke
* Undestroyed city loses smoke
* Each city has a name
* Stars on a parallax background
  https://docs.godotengine.org/en/stable/classes/class_parallaxbackground.html
  or
  that github issue I commented on
  or
  that links to a newer PR against Godot to add a replacement for ParalaxBackground

## Done

* Draw the ground using triangle mesh
* Draw the ground, with hills, using a polygon
* Draw the ground as a curved planet surface, with hills, using a polygon
  with the surface at the center at world co-ordinates 0,0.
* Embed "features" in the ground surface, so we can later ask the ground
  for the world co-ords of bases & cities.
* Add a static camera, giving us a sensible view centered above the ground.
  with scaling to correct for window size/aspect.
* get rid of that camera x2 zoom.
  Just draw everything 2x bigger, surely?
* mouse cursor in world co-ordinates

# Sharing code between nodes
* Scripts for globally useful functions like polar conversion might go:
  * In a Singleton, aka "Autoload" node, which are enumerated in the Project
    settings, autoload tab, and can them be accessed by name from any Node.
  * Consider autoload nodes with `static func` or `static var`,
    to create helper functions without having to create an instance to call
    them.
  * Use `class_name` to register your script as a new named type in the editor.
  * Use `extends XXX` to inherit from an existing Node or other type. If not
    specified, everything inherits from `RefCounted`. Only explicitly `virtual`
    methods can be reliably overriden. Methods include `_init` and
    `_static_init`.
  * All in one: `class_name Character extends Entity`

* Re-org co-ordinates
  - One camera
  - set it to show a large area so we can see everything
    (or should this be in the editor?)
  - ground renders with (0, 0) at planet center
  - mouse moves in a polar segment
  - camera pan left right, in a polar manner so with tilt
    such that ground rotates beneath us properly
    (Should work even with high rotation values)
  - camera also pans up down slightly (polar though)

* 6 cities exist.

* How to raise an error from ground? (see TODO there)

* bombs rain down
  * I don't think they need to be polar.
  * Consider drawing creation area for editor?

* missiles should also aim for the gaps between cities

* Replace mouse 'extent_polar:Rect2' with a pair of Polar.
  (or remove the TODO there if I decide not to)

* See the tutorial way of adding new nodes to the tree programatically.
  https://docs.godotengine.org/en/4.2/getting_started/first_2d_game/05.the_main_game_scene.html

* Add a text node so I can figure out if scale.y=-1 is a disaster
  No: I can also set same on the Label to fix the upsid3-down text.

* Detect missiles colliding with the ground
  - Make the Ground an Area2D, with a CollisionShape2D child, populated with a
    ConvexPolygon2d (Although ground is a concave shape, a ConcavePolygon2D is
    not great for collision detection, it is only sensitive at the edges, not
    throughout the interior. So, we'll have to somehow compose our 'Ground'
    Area2D out of multiple Shape2Ds.
  - Add some collision boundary to missils.
  - on collision, kill the missile
  - Detect collisions with the hills
  - Missiles shouldn't collide with each other
  - Retain the trail, reparenting it to the Ground
  - delete each trail when all its particles end
  - A little explosion?
    - explosion grows over time
    - explosion fades over time
    ? explosion is a ring?

* Pops render behind the ground
* Cities and Missiles too, now I come to think of it

* Mouse cursor can go lower
* Each city looks different?
- cities can get destroyed

* Press Escape to exit

* 3 bases exist.
  * modify their storage on Ground to match Cities: An array of Node2Ds
  * Ask the ground where they are placed
  * bases are destroyed by missiles

* Sound effects for missile strike

