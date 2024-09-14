## Changelog

### v0.16

* Releases now include a README and this CHANGELOG, as HTML.
* Bases have 10 missiles each, not 15.

### v0.15 2024-09-11

* Fix thousands of log errors of the form "*missile.gd:44 @ destroy(): Node not found: 'Trail'*".
* Fix longstanding collision detection bug preventing bombs from being destroyed by sky
  explosions.
* Add a score. Ten points per bomb shot down. Uses 'thin space' character as a thousands
  separator.
* Mouse cursor allowed to go a fraction lower altitude.

### v0.14 2024-09-08

* Automate the upload of new versions to itch.io

### v0.13 2024-09-08

* Game runs, is playable for 30 seconds, correctly handles a "game over" if all
  cities are destroyed, but otherwise the wave of falling bombs just
  gradually runs out, and nothing after that ever happens.

Versions older than this are lost to history, although development started on a flight from
Minneapolis to San Jose in January 2024, and continued sporadically as and when I could persuade my
11 year old to focus on it.

