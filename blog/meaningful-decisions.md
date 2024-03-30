<!-- metadata
title = "Meaningful Decisions"
published = 2024-03-30
tags = ["Esprit Development"]
-->

I understood early on that I'd need a lot of variety to make the game more interesting,
especially when competing with a relatively repetive game like Pokemon Mystery Dungeon.
This led to me making lots and lots of reskinned enemies and moves with very small tweaks.
But as the game grows, its complexity hasn't.

This is the wrong kind of variety:
It's a variety that conditions you to expect nothing new out of every move and enemy you find—it kills intrigue.
The variety we want out of games is well-designed and gives each feature a specific purpose.

## Items

At the moment, most of esprit's items are cheap re-skins of the humble apple
(Sometimes literally: the pear was a green apple until very recently).
Using these items is a non-choice; players eat food to make space or refill their HP,
or clear the occasional negative status conditions.

Using consumable items should always be a *choice*,
otherwise they get relagated to being your in-pocket HP bar.
Instead of directly healing you,
they could give you slowly decaying bursts of energy to protect you from attacks,
making them ideal for tough encounters where you expect to recieve lots of damage.
Players would still need sources of health to stay alive throughout longer treks,
but this could be moved to the stairway as another benefit of "resting" between floors;
a much more consistent source of HP.

## Moves

An unfortunate side effect of my poorly thought out "moves" implementation,
esprit's repetitive and basic moves are a rather glaring weakness of the game.
With some tweaks, they could be a great vector through which to add more variety and interesting gameplay.

The playable characters' moves are a great example of repetitive abilities.
Despite having different personalities and levels of experience,
they feel very samey when interacting with enemies. 

New animations would go a long way in distinguishing the party's actions.
The more complex attacks have no visual indicator of how they're different;
"Lunge" is especially bad because it doesn't give any indication that it's reaching farther when you use it.

I've been planning for the game to feature more explicit magic for a while,
and giving each character a spell would be a great way to distinguish them.
These spells could replace one of "Scratch" and "Bite", the two early game attacking moves,
providing more clear differences between the characters early on.

Aris, one of the main characters, has been in the esprit world for a relatively long time
and has a lot more experience and understanding of the hostile animals he faces.
His moves should reflect this by making him a strong melee attacker, with powerful early-game attacking moves.
Having a signifigant amount of experience fending off hostile animals allows him to manipulate them with "Growl" and "Howl",
which cause their attacks to occasionally fail and increase the damage they take, respectively.
Being a melee attacker, Aris won't have any damaging spells.
As a second melee attack, he can pounce on enemies,
dealing reduced damage but moving him to the opposite side of the enemy;
perfect for quickly repositioning without ceasing your attakcs.

On the other hand, Luvui's moveset should reflect her anxiety and a fear of the unknown.
For example, she attacks using her weaker claws rather than biting the enemies like Aris,
to keep more of a distance between her and the enemy—this can be reflected in their respective animations.
She also has access to "Lunge", which is a melee attack that can be performed while a tile away from an enemy.
As her power matures she gains another ranged attack,
this time a spell that she can cast from great distances,
allowing her to stay far away from enemies while still contributing to the fight.

------

I'd like to thank my very good friend [Oneirical](https://oneirical.github.io)
for talking with me about this game's design and giving me a wealth of suggestions—writing about my game among them.
This project means a lot to me and I'm very glad I get to share it with you.
