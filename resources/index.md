<head><title>Evie | Resources</title></head>

# <center> Resources </center>
<center> A collection of Game Boy libraries and tutorials. </center>

### [regex.inc](https://github.com/eievui5/regex.inc)

regex.inc is a regex parser written in rgbasm.
Its primary use is picking apart the arguments to complex macros, but feel free to get creative.

### [Game Boy VRAM Allocation Library](https://github.com/eievui5/gb-valloc-lib)

A simple Game Boy library for allocating video memory at runtime. Valloc
uses a very basic block pattern which takes advantage of the fact that
VRAM tiles can be addressed using a single byte.

### [Game Boy Sprite Objects Library](https://github.com/eievui5/gb-sprobj-lib)

A small, lightweight library meant to facilitate the rendering of
sprite objects, including Shadow OAM and OAM DMA, single-entry "simple"
sprite objects, and Q12.4 fixed-point position metasprite rendering.

### [Game Boy Interrupts tutorial](interrupts.html)

A tutorial on configuring and using the Game Boy's VBlank interrupt.
