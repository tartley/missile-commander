## TODO

* BUG: Ten thousand instances of message:

    E 0:00:58:0891   missile.gd:44 @ destroy(): Node not found: "Trail" (relative to "/root/Main/World/@Area2D@632").
      <C++ Error>    Method/function failed. Returning: nullptr
      <C++ Source>   scene/main/node.cpp:1792 @ get_node()
      <Stack Trace>  missile.gd:44 @ destroy()
                     bang_sky.gd:72 @ destroy_nearby_missiles()
                     bang_sky.gd:35 @ _process()
        var trail := $Trail

    even with only 1000 missiles. Could it be that when a bangsky destroys a
    missile, it removes that missile from its 'nearby_missiles' array,
    but not from all the other explosion's arrays?

* BUG: Rarely, a falling missile can pass right through an explosion. Cal also
  reports collision detection errors. I once saw one fly right plain across the
  explode as it was at greatest radius. Other missiles were destroyed by that
  same explosion. I don't actually know how that happens.

IDEA:

    Consider removing the explosion of missiles when they die, so that a single
    shot explosion will easily hit multiple missiles

  Consider completely removing use of Godot collisions:

  1. Time the current method.
  2. Replace current method with a brute force one.
  3. Compare timings.

* Display a score
  See https://docs.godotengine.org/en/stable/tutorials/2d/custom_drawing_in_2d.html#drawing-text

* Deply a README and CHANGELOG to users

* Incoming missiles should come in waves
  * text on screen
  * alert sound
  * fire missiles throughout the wave

* Bonus points at end of each wave
* Resurrect a city, in the least convenient position
  (prefer this over awarding a shield, since it forces player to defend
  multiple separate locations)

* BUG: mouse capture doesn't work in web. Needs to be in response to a user
  event. Also: Perhaps my clever minimal event handlers are insufficient.
* BUG: fullscreen doesn't work in web, needs to be in response to a user event
       i.e. we must add a 'fullscreen' toggle button.
* Make a release including 'web' platform.
  * Add it to documented platforms.
* BUG: mouse capture reportedly doesn't work in i3
* Is the following a case of checking for variables != null (or truthy) before
  using them? If the instance has been marked for deletion then it will not
  be null, but dereferencing it will be treated as though it was null.
  Instead use is_instance_valid. Alternatively, do not use such values after
  marking for deletion, i.e. do not use that variable again, or delete the
  value from your array, etc.)
* BUG: Sometimes a destroyed missile has no trail.... hmmm...
  missile.gd:44 @ destroy(): Node not found: "Trail" (relative to "/root/Main/World/@Area2D@28").
    ```
    missile.gd:44 @ destroy()
    bang_sky.gd:72 @ destroy_nearby_missiles()
    bang_sky.gd:35 @ _process()
    ```

* CRT glow

* Consider rich text label for title screen so that I can use bold, colors, etc.
  https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html

* A custom icon for downloadable executables
  * Linux
  * Windows: Requires reinstating the export option 'modify application', which requires installing
    a working windows resource editor tool (presumably under wine, although some dude has a script
    that replaces it and runs natively under linux)
    * file icon
    * running program icon

* In-game upgrade available notification
  https://itch.io/docs/butler/pushing.html#looking-for-updates

* Esc in game goes to game-over (via existing `destroy_all_cities`)
* Esc on game-over goes to title screen
* Esc on title screen exits
* Add instructions "Esc to exit defence console"

* High score

* Credits in the game
* Suggest a mastodon hashtag. Put in README/credits.

* City/base destruction (BangFeature) needs special effects:
  * screen shake / zoom
  * particles of the city color
  * smoke trail
  * erode base verts?
  * base turret droops?

* BangSky should fluctuate in size? Maybe it is rendered as three different
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

