## Changelog

### v0.17

* Rearm all bases between levels.
* Repair one base between levels, preferring the central one.
* Bombs dropped gradually throughout the wave, instead of all at once.
* Refactor: Consolidate whole level control into new 'lifecycle' function.
* Refactor: Alias bases as Base.{left,center,right}.

### v0.16 2024-09-23

* Refactor: Replace Godot tree groups with my own static collections.
* Switched to Godot Forward+ renderer.
* Bases are re-armed between waves.
* Bombs now fall in waves. Each wave just doubles the number of bombs,
  which isn't very difficulty-tuned nor playable.
* Bases have 10 missiles each, not 15, guided by the original.
* Releases now include a README and this CHANGELOG, as HTML.
* Refactor: Internal renames in the code: missile->bomb, shot->missile.

### v0.15 2024-09-11

* Fix thousands of log errors of the form *"missile.gd:44 @ destroy(): Node not
  found: 'Trail'"*. This also massively boosts performance.
* Fix longstanding collision detection bug preventing bombs from being destroyed
  by sky explosions.
* Add a score. Ten points per bomb shot down. Uses 'thin space' character as a
  thousands separator.
* Mouse cursor allowed to go a fraction lower altitude.

### v0.14 2024-09-08

* Automate the upload of new versions to itch.io

### v0.13 2024-09-08

* Game runs, is playable for 30 seconds, correctly handles a "game over" if all
  cities are destroyed, but otherwise the wave of falling bombs just
  gradually runs out, and nothing after that ever happens.

Versions older than this are lost to history, although development started on a
flight from Minneapolis to San Jose in January 2024, and continued sporadically
when both me and my 11 year old could focus on it.

