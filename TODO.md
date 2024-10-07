## TODO

* A longstanding leak reported on exit. title_screen.gd still in use. Run with
  --verbose to see:
  ```
  WARNING: 1 RID of type "CanvasItem" was leaked.
  WARNING: ObjectDB instances leaked at exit
  Leaked instance: GDScriptNativeClass:9223372048464609921
  Leaked instance: GDScript:9223372061483730177 -
      Resource path: res://src/title_screen/title_screen.gd
  Leaked instance: Node2D:111971144986 - Node name: TitleScreen
  ERROR: 1 resources still in use at exit.
     at: clear (core/io/resource.cpp:599)
  Resource still in use: res://src/title_screen/title_screen.gd (GDScript)
  ```
  Hint: Leaked instances typically happen when nodes are removed from the
  scene tree (with `remove_child()`) but not freed (with `free()` or
  `queue_free()`).
  queue_free is called. Does the free fail because something else in-tree has a
  reference to it?

* Levels
  > intro text before a wave
  > pause before first bombs fall
  > Experiment using 'await' between delayed events
  > start next wave
  > outro text on end of wave
  > resupply ammo during outro
    > with sound effects dit-dat-dot!
  > fire bombs throughout the wave
  > repair a single base during outro
    > prefer central base if needed
    > with sound effect after rearm: dit-dat-dot-daah!
  > Move score values onto Score object
  > Score for each missile shot: 10
  > Diversion to write utils for positioning centered labels,
    > even when there are a row of them with uneven sizes.
  > * Bonus for remaining ammo: sum(range(remaining + 1))
  >      0   0
  >      1   1
  >      2   3
  >      .   .
  >      4  10
  >      .   .
  >     10  55
  >      .   .
  >     14 105
  >      .   .
  >     20 210
  >     24 300
  >     28 406
  >     30 465
  >   * with sound effect
  * Bonus counter label should be right-aligned
  * Bonus for remaining cities:
      n 10x2^n      10xtriangular number
      1     10      10
      2     20      30
      3     40      60
      4     80     100
      5    160     150
      6    320     210
    * with sound effect
  * score thresholds repair cities?
    * with sound effect
  * start wave text appears with more flourish?
    * Sound effect?
    * Fade / size in?
  * end wave text flourish
    * sound effect?
    * fade / size in?

* BUG: fullscreen & mouse capture don't work in web. Both these need to be in
  response to a user event. So:
  * In web, start windowed.
  * Clicking on the window captures mouse
  * Toggle: [X] Fullscreen (F11)
  * Start game button (which later will become easy/medium/hard buttons)

* Make a web release
  * Add it to platforms listed in README, itch.io page.

* When bases destroyed or out of ammo, accellerate time so you don't
  have to wait for bombs to fall.
  * Holding fire accellerates time?
  * When it's a button for a base that has no ammo?
  * But that means you can't do it if all bases have ammo?
  * Maybe any fire button should do it if held down?
  * But then you'd have to burn a missile to engage it?
  * But is that a big deal, who would really care?
  * Maybe another button instead of fire?
  * If this was a feature, we'd need a hint that appeared on-screen when
    ammo was gone but bombs remained.

* BUG: mouse capture reportedly doesn't work in i3

* Bug
    NO_GRAB on grabbing mouse. An idea: Comment there suggests we get that event
    twice, and one of them causes the NO_GRAB error, while the other does not.
    Can we distinguish between those events, to conditionally grab the mouse?

* Tidying
  * Read about lables, themes, fonts, etc.
  * Should title_screen/game_over use Labels?
  * Consolidate terminology for level/wave/difficulty

* Differences between waves
  * Go re-read that analysis of the original.
    https://www.retrogamedeconstructionzone.com/2019/11/missilie-command-deep-dive.html
  * Number of bombs
  * Number of cities / bases targetted during the wave (arcade fixed this at 3 +
    3 bases)
  * Proportion of bombs targetting active cities vs empty space or destroyed
    features.
  * Speed distribution of bombs
  * Smaller timing between successive bombs. Cluster them.
  * Allow greater deviation from vertical descent

* Cluster bombs fragment into several halfway down
  * variation between waves
* smart bombs that dodge
  * variation between waves

* Buttons to start game on:
  * Easy (wave 1)
  * Medium (wave X)
  * Hard (wave Y)

* Esc in game adds "[Esc] again to quit" lable for 2 seconds.
* Esc again with label quits game, via "destroy_all_cities", goes to game-over.
* Esc on game-over goes to title screen
* Esc on title screen exits
* Add instructions "[Esc] to exit defence console"

* Credits in the game
  * with links one can click
  * A mastodon hashtag (also put in README, itch.io description)

* High score?

* Planes or satellites fly over

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
  * Trail on missiles, somewhat like bombs
  * missiles launch
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
* Game over animation:
  * zoom camera into last exploding city?
  * slow-mo?
  * Text "game over" grows within the explosion?
  * animation should be unskippable, to prevent rapid presses of fire at the
    end of a frantic game from skipping over this and starting a new game,
    erasing the attained score.
* Program start animation zooms out from central base, to reveal title, etc

