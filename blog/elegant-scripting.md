<!-- metadata
title = "evscript: Elegant Scripting on the Game Boy"
published = 2023-04-05
tags = ["Esprit Development"]
-->

evscript is a custom scripting language I made for use in Game Boy projects.
I use evscript pretty extensively in Esprit, for things like cutscenes/dialogue,
dungeon generation, and visual effects on the map screen.
I originally came up with the idea for evscript when working on a previous project.
In GBDev we were talking about how Kirby's Adventure used scripting for its enemies' logic,
which seemed silly at the time considering the game's poor performance.
However, a friend mentioned that scripts had the potential to be used as coroutines,
where `yield` can be used to lieu of complex state machines.
I decided to play around with the idea by rewriting the entity logic for my project at the time,
but almost immediately I realized that any complex and powerful scripting system
without a language in front of it would grow rather verbose and disorganized;
it was a lot like assembly for a custom CPU.
At the time, I looked into designing a more elegant syntax I could use,
but I ultimately wasn't able to work on it at the time.
It took until about halfway through Esprit's development before I felt the need for a custom scripting language again.

## Why a new language?

What makes evscript powerful and ideal for a limited system is its modularity.
The interpreter or "virtual machine" can be entirely customized,
containing implementations for only the operations needed in a certain context.
For example, Esprit's evscript interpreter doesn't support multiplication or division,
and this limitation is communicated to and enforced by the compiler.
You can also create custom bytecode, which acts a lot like a function call,
though with some abnormal caveats (namely, all non-const values are always passed by reference).
This all adds up to a relatively efficient and compact scripting language,
without sacrificing the language's readability.

## Early prototype

On the topic of readability, evscript's syntax wasn't always very elegant.
When I first started work on evscript, I was using C++ and Bison as a parser.
This first parser was really poorly designed, and couldn't handle complex expressions.
The language was limited to one operation per statement,
which resulted in long and verbose expressions akin to the "assembly-like" scripting we were trying to escape.

```
// This is how you'd write `u8 x = (1 + 2) * 4;`
u8 x = 1;
x += 2;
x *= 4;
```

This early prototype also had a lot of glaring holes in it;
there was very little proper error handling and nearly any mistakes would result in a segfault.
Despite its poor quality, this early version was pretty crucial in the development of the language,
solidifying its core structure and needs.
I came out of it with two major goals for evscript: proper error handling and reporting, and support for complex expressions.

## RIIR

Late last year I got bored and wanted to undertake another large Rust project after completing evunit.
After playing around with a few parsers, I started work on a new version of evscript using lalrpop.
Lalrpop made it really easy to implement the order of operations for my expresions and construct an AST.
Compiling a big long expression using an AST was surprisingly easy;
you just recursively work downwards, generating code for each step to compose a big list of operations.
It's a lot of fun to work on these big recursive systems with lots of tiny parts and see them flawlessly output working code.

Error handling was exceedingly simple because of Rust's very nature.
`Option` and `Result` types enforce the handling of runtime errors at compile time,
meaning 90% of the work was done simply by virtue of the language being used.
Pretty error reporting was a bit more work, but I was able to use a crate called "codespan" to handle most of the work.
All I had to do was keep track of the locations of each token and pass them up to codespan whenever an error is encountered.

## Vis-à-vis Esprit

In Esprit, the first place I applied evscript was the game's level generator.
It just happened to be what I was working on at the time,
and I was tired of how assembly made tweaking the level generation so difficult.
Despite it being slower than assembly,
the performance penalty wasn't really an issue since level generation only happens between floors.
After having implemented quite a few dungeon generators using it,
I'm really satisfied with evscript's capabilities as a general-purpose programming language.

evscript also made writing cutscenes super easy;
being able to embed the logic right alongside character dialogue makes it trivial to tweak all the little details and animations.
Because cutscenes can play in the middle of a level, evscript can even be used to set flags and control the level environment.
A dungeon could potentially use evscript to randomly generate not only the layout of each level, but also the shape, tileset, items, and enemies.
