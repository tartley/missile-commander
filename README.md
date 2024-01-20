# Missile Command 2023

With vector graphics,
by [Jonathan Hartley](https://mastodon.social/@tartley),
using [Godot](https://godotengine.org/).

## TODO

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
  * A little explosion?

* consistent angle representation, remove all the +/-PI/2 offsets.
* Consider using TAU

* Consider AnnotatedVector2 class, extends Vector2
* Consider AnnotatedVector2Array class, which provides access to co-ords of named features

* small explosion when missiles die

* 3 bases exist.
  * Ask the ground where they are placed

* Should we try to use GPUParticles on non-MacOS?

* Add previews in the editor?
  https://docs.godotengine.org/en/stable/tutorials/plugins/running_code_in_the_editor.html#doc-running-code-in-the-editor
  * Ground?
  * Camera and mouse max extents?
  * Star max extents?

* Stars on a parallax background
  https://docs.godotengine.org/en/stable/classes/class_parallaxbackground.html
  or
  that github issue I commented on

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

