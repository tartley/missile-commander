# Missile Command 2023

With vector graphics,
by [Jonathan Hartley](https://mastodon.social/@tartley),
using [Godot](https://godotengine.org/).

## TODO

* Add a preview of ground in the editor?
  https://docs.godotengine.org/en/stable/tutorials/plugins/running_code_in_the_editor.html#doc-running-code-in-the-editor
* Camera pan and tilt to follow mouse cursor
  * consider drawing max extents for the editor
* bombs rain down
  * Consider drawing edge of creation area for editor
* 3 bases exist.
  * Ask the ground where they are placed
  * extract an "annotatedArray" class?
  * Read about structs?
* 6 cities exist. Likewise.

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

