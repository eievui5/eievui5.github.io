<!-- metadata
title = "Understanding Structures"
published = 2024-02-17
tags = ["Esprit Development"]
-->

A common point of confusion for beginners to Game Boy development
is how high level constructs like "structs", "classes", or "records" translate to assembly.
This problem is a lot simpler than it seems, though; it just requires an understanding of how structures work.

Put simply, structs are a collection of ordered values *of varying size*–sounds like an array, doesn't it?
Like an array, each value in a struct is represented by an index (usually, this is the member's "name").
However, unlike an array, values in the structure cannot be added or removed.
This is a consequence of having a mix of types and sizes for each entry.

Given this connection, making structures for your game suddenly seems a lot easier.
Let's make some constants to assign names to each field, and then create a few structures:

```rgbasm
def HEALTH equ 0 ; This should be 16-bit, so the next value is HEALTH+2
def MAGIC equ 2 ; Magic will be 8 bit, so we'll only add 1 next time
def SPEED equ 3 ; This value is also 8-bit, which means the final size is 4 bytes.

; Keeping track of the size of a struct is important for accurately allocating enough space to instantiate it.
def SIZE equ 4 

Player:
  ds SIZE
Enemy:
  ds SIZE
```

Now you have two objects with common fields!
You can assess members by adding one of those constants to the base label.

For example:

```rgbasm
; a = magic value
SetPlayerMagic:
  ld [Player + MAGIC], a
  ret

; Slow down the actor at `hl` by one point
; hl = actor
SlowActor:
  rept SPEED
    inc hl
  endr
  dec [hl]
  ret
```

rgbasm actually has some kewords that make defining structs a little easier...

```rgbasm
rsreset ; set the index to 0
def HEALTH rb 2 ; allocate two bytes at 0
def MAGIC rb 1 ; allocate one byte at 2
def SPEED rb 1 ; allocate one byte at 3

def SIZE rb 0 ; save the current index as the structure's size.
```

...but we can make this even simpler

## Enter: rgbds-structs

[rgbds-structs](https://github.com/ISSOtm/rgbds-structs) is a library, like hardware.inc,
that provides some macros you can use for creating structures.

Here's the previous example, rewritten for rgbds-structs:

```rgbasm
include "structs.inc"

  struct Actor
    bytes 2, Health
    bytes 1, Magic
    bytes 1, Speed
    ; rgbds-structs keeps track of the size for you (sizeof_Actor).
  end_struct

; You can define structs now using the dstructs macro.
dstruct Actor, Player
dstruct Actor, Enemy

; a = magic value
SetPlayerMagic:
  ; Notice that this is a single label now, instead of `Player + Actor_Magic`.
  ; dstructs defines these labels for each field.
  ld [Player_Magic], a
  ret

; Slow down the actor at `hl` by one point
; hl = actor
SlowActor:
  rept Actor_Speed
    inc hl
  endr
  dec [hl]
  ret
```

You can read more about rgbds-structs on its [GitHub repository](https://github.com/ISSOtm/rgbds-structs).
I'll be using it for the rest of this article.

## Polymorphism

Now's where things get fun.
Polymorphism is often useful for assigning different behaviors to objects in video games.
For example, you might want to swap out the AI function for your actor structure,
or add extra fields to items of a certain type.

We'll start by adding extra fields to a basic structure.
You can accomplish this by using `extends` in rgbds-structs;
this copies the field of one struct to another, allowing you to extend it!

```rgbasm
  ; Every item has a name and a cost (for buying/selling)
  struct Item
    bytes 2, Name ; This is a pointer
    bytes 1, Cost
  end_struct

  ; Healing items have one more field: the amount of health they heal.
  struct HealingItem
    extends Item
    bytes 1, HealingAmount
  end_struct
```

This works, but we'll also need a way to tell `Item`s and `HealingItem`s apart.
You could do this using a discriminator byte, like this:

```rgbasm
; add `bytes 1, Discriminator` to `Item` and set it to one of the following:
def ITEM equ 0
def HEALING_ITEM equ 1
```

Alternatively, you could use a function pointer.
This is much more flexible and might be a little bit easier to
reason about if you're used to using class inheritence.

```rgbasm
  struct Item
    ; Set this to either `ItemUseFunction` or `HealingItemUseFunction`.
    bytes 2, UseFunction
    bytes 2, Name
    bytes 1, Cost
  end_struct

; hl = Item pointer
ItemUseFunction:
  ld a, SFX_ERROR
  jp PlaySound ; Play the sound in `a`

; hl = HealingItem pointer
HealingItemUseFunction:
  ld bc, HealingItem_HealingAmount
  add hl, bc
  ld a, [hl]
  jp HealPlayer ; Heal player by `a`
```

This has the added benefit of allowing you to assign multiple use functions to the same structure type.
For example, if you have a `HealingItem` that should play a special sound,
you can create another function and assign it to that `HealingItem`.

## Structures and Design

As a closing tip, I'd like to recommend that you use structs early and often.
Assembly is an abstract and foreign language to many people, and having the modern comfort of thinking about
your program in terms of objects can make it easier to reason about your design.

That's not to say your program should be "object oriented", or that you need to be using polymorphism everywhere;
you'll thank yourself for keeping things simple when it comes time to start writing code.

I also recommend commenting/documenting the usage of your struct extensively.
It's a lot easier to read a description of what data your program stores and why
than it is to dive into assembly code to figure out what it does.

## Further reading

Here are some example structures from esprit, for reference:
- https://github.com/eievui5/esprit/src/include/entity.inc
  - Large, heavily commented entity structures. Also makes use of a sort of "VTable".
- https://github.com/eievui5/esprit/src/include/item.inc
  - Makes use of `extends` and a discriminator byte (`Item_Type`).
- https://github.com/eievui5/esprit/src/include/dungeon.inc
  - Contains a "sub-structure", as an example of how to nest structs.

If you have an array of large structures that you're changing often throughout the development of your engine,
such as a list of actors or enemies, you might be interested in [Creating Efficient Entity Structures](efficient-entity-structs.html)
