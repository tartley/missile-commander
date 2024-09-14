## TODO

* Each base has 10 shots, not 15.

* Go re-read that analysis of the original.

* Bug
    WARNING: 1 RID of type "CanvasItem" was leaked.
    WARNING: ObjectDB instances leaked at exit (run with --verbose for details).
         at: cleanup (core/object/object.cpp:2284)
    ERROR: 1 resources still in use at exit (run with --verbose for details).
       at: clear (core/io/resource.cpp:604)

* Bug
    NO_GRAB on grabbing mouse
    An idea: Comment there suggests we get that event twice, and one of them causes the NO_GRAB
    error, while the other does not. Can we distinguish between those events, to conditionally
    grab the mouse?

* BUG: mouse capture doesn't work in web. Needs to be in response to a user
  event. Also: Perhaps my clever minimal event handlers are insufficient.
* BUG: fullscreen doesn't work in web, needs to be in response to a user event
       i.e. we must add a 'fullscreen' toggle button.
* Make a web release
  * Add it to documented platforms.
* BUG: mouse capture reportedly doesn't work in i3

* Rename missile -> bomb
* Rename shot -> missile

* Incoming missiles should come in waves
  * text on screen
  * alert sound
  * fire missiles throughout the wave

* End of wave:
  * repairs 1 base
  * resupplies missiles
  * Bonus score for remaining cities, missiles
  * Reaching score thresholds can resurrect a city

* smart bombs that dodge

* Esc in game goes to game-over (via existing `destroy_all_cities`)
* Esc on game-over goes to title screen
* Esc on title screen exits
* Add instructions "Esc to exit defence console"

* Credits in the game
  * with links one can click
  * A mastodon hashtag (also put in README, itch.io description)

* High score

* Planes or satellites fly over

* Vehicles launch missiles from the sides

* In-game upgrade available notification
  https://itch.io/docs/butler/pushing.html#looking-for-updates

# Juice

* CRT glow
  * Take a look at WorldEnvironment, gamedevacademy says it is crucual for
    atmosphere in Godot games:
    https://gamedevacademy.org/worldenvironment-in-godot-complete-guide/
  * Try FSAA instead of drawing with AA=true?
* A custom icon for downloadable executables
  * Linux
  * Windows: Requires reinstating the export option 'modify application', which requires installing
    a working windows resource editor tool (presumably under wine, although some dude has a script
    that replaces it and runs natively under linux)
    * file icon
    * running program icon
* Turret recoil
* Audio listener moves with mouse?
* Sound when fire pressed but base is destroyed
* Click2 when fire pressed but out of ammo
* Beepy warning on low ammo
* Stars
  * on a parallax background using the new Parallax node in 4.3.
    PR: https://github.com/godotengine/godot/pull/87391
  * Should be particles
  * Can they twinkle or delete/add over time?
* GPUParticles:
  Use GPU Particle systems. In 4.2 this required Compatibility renderer for web exports,
  but could use Forward+ renderer for desktop (incl MacOS). What's the situation now?
  Do we prefer one renderer over another?
* More particle effects:
  * Trail on shots, somewhat like missile
  * Shot launch
  * city destroy (red particles?)
  * base destroy (yellow particles?)
* City/base destruction (BangFeature) needs special effects:
  * screen shake / zoom
  * smoke trail
  * erode base verts?
  * base turret droops?
* BangSky should fluctuate in size?
* I don't like BangSky's sound
  * A more regular deep bang?
  * Vary each one slightly in tone?
  * Maybe it can fluctuate along with the visual?
* Speech synthesis?
* Game over animation zooms into last exploding city? (And slow-mo?)
* Program start animation zooms out from central base, to reveal title, etc
* Each city has a name?

