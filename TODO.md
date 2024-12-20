## TODO

* Wave chooses bomb destinations in advance
  NO: Initial destinations might be gone when bomb is launched
  we should choose hit/miss counts in advance, then choose target at bomb launch.

* Cluster bombs fragment into several halfway down
  * Arcade broke into up to four

* smart bombs that dodge expanding explosions

* Bomber planes
  * fly lower and slower (12 seconds to cross)
* Satellites start in wave 2
  * take 8 seconds to cross
  * Drop bombs
  * As wave increases:
    * Fly lower
    * Drop more bombs
* Only one such vehicle appears at a time

* Arcade rebuilds ALL bases between waves
  (and this would simplify end of wave show, consolidating the rebuild/rearm)

* Differences between waves
  * Consolidate terminology for wave/difficulty
  * Go re-read that analysis of the Arcade.
    https://www.retrogamedeconstructionzone.com/2019/11/missilie-command-deep-dive.html
  * Bombs more numerous
    Arcade starts with 8 in wave 1
  * Bombs fall faster
  * Bombs target more cities/bases during a wave
    (arcade fixed this at 3 cities + 3 bases on every wave)
  * Bombs more likely to target active cities
  * Bombs more likely to target bases
  * More Bombs drop concurrently
  * Groups of bombs have smaller pauses between them
  * Bombs angle of descent can deviate further from vertical
  * Cluster bombs more numerous
  * Cluster bombs split into more
  * Satellite frequency
  * Satellites speed increases
  * Satellite number of bombs increases
  * Satellite altitude decreases
  * Satellites cluster bombs increase
  * Bomber frequency
  * Bomber speed increases
  * Bomber number of bombs dropped increases
  * Bomber altitude decreases
  * Bomber smart bombs increase
  * Aim at bases at start of wave, at cities at end

* BUG: fullscreen & mouse capture don't work in web. Both these need to be in
  response to a user event. So:
  * In web, start windowed.
  * Clicking on the window captures mouse
  * Toggle: [X] Fullscreen (F11)
  * Start game button (which later will become easy/medium/hard buttons)

* Make a web release
  * Add it to platforms listed in README, itch.io page.

* BUG: A longstanding leak reported on exit. title_screen.gd still in use.
  Run with --verbose to see:
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

* End of wave show
  * Bonus popup from each base, INSTEAD of current HUD text?
    Ah, this relies upon bonus value being per-base, not (as currently)
    growing with the total amount of remaining ammo. Hmmm... That would encourage
    players to concentrate on using ammo from one base while hoarding it at others.
    That might not be terrible, since it acts in opposition to what's best for the
    player. It means these bonuses will be very low at higher waves where the number
    of incoming bombs is presumably high. Hmm. Maybe higher waves should not consistently
    have such a high number of bombs? Certainly we should not have number of bombs exceed
    the number of player missiles, except to the extent we can expect (or force) multiple
    bombs to be destroyable with one shot. Ah, but actually, we could have a high number
    of bombs, but have many of them miss, so an adept player could still hold back many
    shots and score a bonus.
  * Visual effect to highlight base repair.
  * ...Instead of current HUD text?
    Or should current HUD text be one line, that describes what's currently happening,
    instead of multiple lines as currently. Hmmm.
  * Bonus for remaining cities: SEE existing stash
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

* Time accelleration for impatient players
  * Scenario: Awaiting slow bombs to fall, either because they will miss, or because we are
    out of ammo.
  * Scenario: Don't care about the inter-wave show
  * Holding [space] or any other mouse button accellerates time
  * Can we make the effect ramp up?
  * With a sound effect?

* BUG: mouse capture reportedly doesn't work in i3

* Bug
    NO_GRAB error on grabbing mouse. An idea: Comment there suggests we get that
    event twice, and one of them causes the NO_GRAB error, while the other does
    not. Can we distinguish between those events, to conditionally grab the
    mouse?

* Tidying
  * Read about lables, themes, fonts, etc.
  * Should title_screen/game_over use Labels?

* Buttons to start game on:
  * Easy (wave 1)
  * Medium (wave X)
  * Hard (wave Y)

* Esc in game adds "[Esc] again to quit" lable for 2 seconds.
* Esc again with label quits game, via "destroy_all_cities", goes to game-over.
* Esc on game-over goes to title screen
* Esc on title screen exits
* Add instructions "[Esc] to exit defence console"

* Credits, in game
  * with links one can click
  * A mastodon hashtag (also put in README, itch.io description)
* Rules, in game.
  * Behind an "Advanced play" button
  * Scoring
  * Rebuilt base at the end of each wave
  * Rebuilt city every X points
  * Time accelleration

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
  It is already centered on the camera. I'm not sure I like this.
  Explosions to the side are very quiet. If I make them louder then the effect
  is more subtle, is it even achieving anything except puzzlingly inconsistent
  volume levels? This would be doubly true for a lister on the cursor, which
  gets even further away from the far side of the world. Maybe I just remove
  the audio listener.
* Check out kenney's assets science fiction sounds
  * And add to credits if we use
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
* Repetitive sounds should vary a bit - maybe adjust pitch of launch depending on how far
  the missile is going? Adjust pitch of bangs randomly? Plus a notch for their generation?
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

