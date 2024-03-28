<!-- metadata
title = "Game Boy Interrupts"
published = 2021-12-02
tags = ["gbdev"]
-->

This guide assumes you have a short project to test code on. ISSOtm's
"Hello World!" tutorial should work fine as a base.

Interrupts are used to call a given function when certain conditions are
met. On the Game Boy, these conditions are:

- The beginning of the VBlank period
- A Joypad input
- A serial data transfer from the link cable
- The tick of a configurable timer
- A configurable LCD Status interrupt

For the purposes of this short guide we will focus on the most prevalent
interrupt - VBlank

## VBlank

VBlank refers to the period of time that the screen spends returning to
the upper-left hand corner, and during this time the PPU gives the CPU
access to VRAM. Because of this, most VRAM access during normal gameplay
must occur during VBlank.

But how do you know when VBlank has started? If you have read ISSOtm's
gb-asm-tutorial you likely know how to use a loop for this, which checks the
value of `rLY` to see if it is past the screen area. However, because
this loop must continually run to check for VBlank, you may miss VBlank
entirely or enter your VBlank code too late. Additionally, loops like
that keep the CPU running, wasting power on real hardware. This isn't an
issue for turning off the screen, but when you have time-sensitive code
and a loop running game logic, it's important to make sure everything is
run at predictable intervals.

This is where the VBlank interrupt comes in. When the VBlank period
starts a flag will be set that tells the CPU to stop what it's doing,
and call the address `$0040`.

Before we even enable interrupts, let's write some VBlank code...

```
; Define a new section and hard-code it to be at $0040.
SECTION "VBlank Interrupt", ROM0[$0040]
VBlankInterrupt:
	; This instruction is equivalent to `ret` and `ei`
	reti
```

That handler doesn't do anything yet, but without it our VBlank
interrupt would jump to `$0040` and begin running random code, either
the header or a portion of your ROM. Additionally, when an interrupt is
fired it automatically runs `di`, which disables interrupts so that
nothing else conflicts with the handler. `reti` is the same as an `ei`
followed by a `ret`, so the interrupted code can continue executing and
VBlank can be fired the next time it's needed.

## Configuring an interrupt

Make sure you have a copy of 'hardware.inc', we're going to use it quite
a bit here.

To enable the VBlank interrupt we need to write to the
[Interrupt Enable register](https://gbdev.io/pandocs/#ffff-ie-interrupt-enable-r-w),
`rIE`. If you take a look at `rIE` on the Pandocs, you can see what
interrupt each bit corresonds to, but we're going to focus on VBlank's
bit, bit 0. To enable the VBlank interrupt, all we need to do is set bit
0 of `rIE` to 1, so let's do that!

```
SECTION "Init", ROM0
Init:
	; Place the following somewhere in your initiallization code:
	; hardware.inc defines a handy flag that we can use.
	ld a, IEF_VBLANK
	ldh [rIE], a
	; ...
```

Additionally, we should clear another register while we're at it, `rIF`.
`rIF` is used by the CPU to begin an interrupt; basically, if any of
the bits in `rIF` and `rIE` match, the corresponding inturrupt is
called. However, `rIF` may have leftover values that would accidentally
set off an interrupt at the wrong time, so we need to manually clear it.

```
	xor a, a ; This is equivalent to `ld a, 0`!
	ldh [rIF], a
```

Finally! Now the last step is running the instuction `ei`, which
globally enables interrupts. This is *not* the same as `rIE`.

```
	ei
```

If you run your rom now... you'll notice no difference. That's because
our VBlank code doesn't do anything yet. But we can make it do something
with just one instruction: `halt`.

Your program likely has a loop somewhere which either does nothing, or
continually runs some logic:

```
.endlessLoop
	jr .endlessLoop
```

But this keeps the CPU running forever! Instead, we should give it a rest
using the `halt` instruction. Just place `halt` at the end of that loop...

```
.endlessLoop
	halt
	jr .endlessLoop
```

... and run your program! If you're using BGB or Emulicious, you can check
the Game Boy's CPU usage in their debuggers. Open it up and compare the
meter with and without halt. You should see nearly *0%* usage when halt is
being used, because only three instructions are run per frame now.

## Taking advantage of VBlank

Okay, saving power is great, but how does this help you write a Game Boy
game? Well since the interrupt occurs as soon as VBlank starts, it gives
us the perfect opportunity to access VRAM and graphics-related registers.
We can start by playing with palettes. First, define a variable in HRAM;
we'll use this as a frame counter.

```
SECTION "Frame Counter", HRAM
hFrameCounter:
	db
```

Now, go back to that loop from earlier. Right before `halt`, add some code
to increment `hFrameCounter`.

```
.endlessLoop
	; Make sure to use `ldh` for HRAM and registers, and not a regular `ld`
	ldh a, [hFrameCounter]
	inc a
	ldh [hFrameCounter], a
	halt
	jr .endlessLoop
```

Now, right before the loop halts, it'll increment a little timer which
we can use for delays. We're going to use that timer to flicker the
palettes back and forth in a short cycle during VBlank.

However, there is *one* issue to take care of: we only have 8 bytes of
space in the VBlank interrupt handler! This is fine though, just jump
outiside of the handler and continue execution. And while we're at it,
we're going to `push` every register, including the flags, to the stack.
This is because there's a good chance VBlank will occur before the loop
gets back to `halt` in a real game, and we don't want to ruin any
registers that the game was relying on.

```
SECTION "VBlank Interrupt", ROM0[$0040]
VBlankInterrupt:
	push af
	push bc
	push de
	push hl
	jp VBlankHandler

SECTION "VBlank Handler", ROM0
VBlankHandler:
	; Now we just have to `pop` those registers and return!
	pop hl
	pop de
	pop bc
	pop af
	reti
```

Perfect! Now let's write some code. I'll heavily comment this to help
you follow:

```
SECTION "VBlank Handler", ROM0
VBlankHandler:

	; Begin by loading the frame counter
	ldh a, [hFrameCounter]

	; Now check the 5th bit, causing it to set the zero flag for 32 frames,
	; every 32 frames. (about half a second on and off)
	bit 5, a

	; Now we're going to load a standard palette into `a`, but if the zero
	; flag is set we'll complement it, inverting every color.
	ld a, %11100100

	jr z, .skipCpl
	cpl ; ComPleMent `a`. Flips every bit in `a`
.skipCpl

	; Finally, load `a` into `rBGP`, the Game Boy's Background Palette register.
	ldh [rBGP], a


	; Now we just have to `pop` those registers and return!
	pop hl
	pop de
	pop bc
	pop af
	reti
```

Now you should see the colors invert every 32 frames.

If you're looking for something else to try on your own, try writing to
a different tile each VBlank to slowly fill up the screen with a custom
tile. Or load different graphics during VBlank to animate an existing
tile!
