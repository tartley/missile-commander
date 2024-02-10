# Missile Command 2023

With vector graphics,
by [Jonathan Hartley](https://mastodon.social/@tartley),

A work in progress.

## Credits

Made in [Godot](https://godotengine.org/).

Sound effects created using:
* [Sfxr](http://drpetter.se/project_sfxr.html) by Tomas "DrPetter" Pettersson.
* [Jsfxr](https://sfxr.me/) by Eric Fredricksen with contributions by Chris McCormick.
* [Chiptone](https://sfbgames.itch.io/chiptone) by Tom Vian.

TODO: Credit the creators of the original missile command.

## TODO

* Two sounds play when a city is destroyed, one by the
  BangFeature, and one by the city.
  * Sanity check it doesn't happen with Bases
  Problem is, I think it sounds better with them both.
  * check that
  * merge the sounds into one
  * have the explosion play it
  * remove the city's audioplayer
  * remove leftover `audio/explode-city.*`

* Rationalize creation of explosions etc.
  * Missile hitting ground is handled by
    ground.on_entered:
        if missile.target (or close to feature):
            City.destroy():
        else:
            create BangGround
  * City.destroy:
        if self.destroyed:
            # create BangGround
        else:
            self.destroyed = true
            # create BangFeature
  * same for Base

* BangSky should fluctuate in size corresponding to its
  sound

- Create BangFeature (with City or Base variants)
  * Looks different. Bigger, slower, more dramatic.
  - Own sound effect
  - other sound effects should be quieter?
  * particle effect using color of the destroyed feature?
  * Camera shake?
  * Sky flash?

* Display ammo under each base
* Firing a shot reduces ammo from that base
* No shots when out of ammo

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

* How to handle similarities between Nodes?
  * Inheritance: Could inherit from a common base class. Maybe sometimes,
    but be wary of inheritance hell.
  * Shared logic: Can I just define methods on a commonly-used class, and call
    them from each? Maybe sometimes, but this isn't fabulous, it doesn't cover
    storing common data upon which those functions depend.
  * Composition: Can I add a variable of a type which defines common traits?
    It's unclear to me how that would work, e.g. as a 'destroyable'.

City:

    var destroyable := Destroyable.new(
        get_verts,
        Color.YELLOW,
        get_destroyed_verts,
        Color.GREY,
    )

    var destroyed:boolean:
        get():
            return destroyable.destroyed
        set(d):
            destroyable.destroyed = d

    func _draw():
        destroyable.draw()

I'm not sure it's worth it.

Alternative, destroyable wraps our class, and we define get_verts, color, etc,
with standard names, so we don't need to pass so much into the contructor:

    var destroyable := Destroyable.new(self)

But we'd still need to forward destroyed, `_draw`, etc.

How about the other way around? Our class wraps a Destroyable.

City:

    func _init(destroyable):
        ...

I think this looks a lot like owning a Destroyable variable, above.

Ah, the node is a Destroyable:

Destroyable:

    var destroyed:boolean:
        set(d):
            if not d:
                # instantiate BangFeature
            for child in get_children():
                child.destroyed = d
            destroyed = d
            queue_redraw()


    func _init(get_verts, color, get_destroyed_verts, color_destroyed):
        ...

    func _draw():
        if destroyed:
            draw_polygon(get_verts(), [Color.BLACK])
            draw_multiline(get_verts(), get_color())

City creation, maybe in Main:

    city = Destroyable(get_city_verts, Color.YELLOW, get_city_destroyed_verts, Color.GREY)

This seems ok, but still might not be worth it. Perhaps all the red in the PR would
convince me. But lack of flexibility might hurt. Also consider:

* Turret is also a Destroyable.

* Missile and Shot are quite similar. e.g.
  * Shots should have a trail
  * Both accept a start and destination, then move towards it until
    self-destructing.

* BangMissile, BangShot, BangFeature have similarities.

* remove the thing where missiles know their target
  * ground will decide whether a feature is hit when it hears of the collision.
  * Only do this if we gain missiles that steer or change target in-flight

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
  Established ParallaxBackground Node does not rotate with the camera,
  so is no use for me.
  How about this Godot PR to add a replacement for it?
  https://github.com/godotengine/godot/pull/87391
  When it lands I can apparently grab a Godot build to use.
* Fix draw order? (see docs/text/writing/godot-draw-order.md)

