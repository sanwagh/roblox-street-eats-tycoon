# Street Eats Tycoon

Roblox tycoon game where players run a food stall, price their own menu, and either automate the business or run it themselves.

[roblox.com/games/12833908327/Street-Eats-Tycoon](https://www.roblox.com/games/12833908327/Street-Eats-Tycoon) · 2024 · solo project · released

## What it is

Players claim a plot, place stalls, tables, and an order stand on it, and set a price on what they sell. NPC customers spawn on their own, decide whether to buy based on that price, eat at a table, and leave, while the player restocks inventory and buys new equipment with what they earn.

## NPCs run on tags and attributes, not a central loop

Spawning, buying, seating, and pathfinding are four separate scripts that never call each other directly. An NPC is just a model with attributes on it (`Item`, `Cost`, `OrderGiven`, `Seated`, `Pathfinding`), and each script polls those attributes or reacts to them changing. Tables, stalls, and order stands are identified by `CollectionService` tags instead of direct references, so the spawner doesn't need to know how many of each a plot has or where they are, it just searches for the tag. That means a plot can have any number of stalls or tables, placed anywhere, without the spawning code changing.

## Placement is client-drawn but server-decided

The client shows an instant preview when placing an item: it snaps to a grid, rotates, and turns red on collision, all before anything is real. None of that is authoritative. The actual placement goes through a server function that reclones the item, checks the player's cash and level, checks it's inside the plot bounds, and checks for collisions again, independently of what the client showed. Cash is only deducted after all of those pass. If an item ends up outside the plot bounds anyway, the server kicks the player instead of trying to correct the position.

## Every feature gets its own module and folder

Server and client code both follow the same layout: a top-level script per feature (`NpcSpawning`, `DataStores`, `Monetization`) with a matching `_contents` folder holding whatever that feature needs internally. Placeable items follow the same idea from the other direction, each one is a self-contained model that carries its own script rather than being driven by a shared item-behavior file. New functionality gets a new top-level folder rather than being added to an existing one.

## Status

Released and live on Roblox, built solo.
