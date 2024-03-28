<head>
<title>Evie | Projects</title>
<style>
    .image {
        float: left;
        padding: 5px;
        max-width: 360px;
        height: auto;
    }
    .image-row::after {
        content: "";
        clear: both;
        display: table;
    }
</style>
</head>

Hi! I'm Evie.
I'm currently working on a game called [esprit](https://github.com/eievui5/esprit) and a complementary scripting language,
[evscript](https://github.com/eievui5/evscript).
You can find a collection of my projects below.

# [Esprit](https://github.com/eievui5/esprit)

A Game Boy "Mystery Dungeon" engine, making extensive use of the
console's limited video capabilities. Features 8 independant entities which
each have a unique color palette and set of graphics, procedurally
generated levels, a powerful variable-width-font engine which makes text
compact and easy to read, and a custom scripting language created from
scratch for this project, evscript.

<div class=image-row>
<img class=image src="assets/esprit-title.png">
<img class=image src="assets/esprit-gameplay.png">
</div>

# [evscript](https://github.com/eievui5/evscript)

A simple yet versatile programming language originally made for the
Game Boy. Intended to replace the macro based scripting languages often
used in assembly projects, evscript provides control flow structures,
variable declarations and operators, and compact bytecode output which
saves space compared to C or even some assembly code.

<div class=image-row>
<img class=image src="assets/evscript-source.png">
<video class=image loop controls>
<source src="assets/evscript-hello-world.mp4" type="video/mp4">
</video>
</div>

# [evunit](https://github.com/eievui5/evunit)

A unit testing program for Game Boy ROMs.
Configure tests using TOML files and instantly execute them with the built-in CPU emulator.

<div class=image-row>
<img class=image src="assets/rgbunit-results.png">
</div>

# [Kirby’s Dream Land DX](https://github.com/eievui5/kdl-dx)

My first project on the Game Boy. KDL DX is a romhack
which adds Game Boy Color support to Kirby's Dream Land.

<div class=image-row>
<video class=image loop controls>
<source src="assets/kdl-dx.mp4" type="video/mp4">
</video>
</div>

# [VuiBui](https://github.com/eievui5/vuibui-engine)

A Game Boy engine written entirely in RGBASM/SM83 assembly,
with two macro-based scripting languages for programming events and enemies.
These scripting languages led to the creation of evscript.

<div class=image-row>
<img class=image src="assets/vuibui.png">
</div>
