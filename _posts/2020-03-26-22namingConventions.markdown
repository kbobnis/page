---
layout: post
title:  "My best naming conventions in Unity development"
date:   2020-03-26 22:28:00 +0100
categories: development
---

## Unity projects file structure 
 - `YYYY[.MM optional] <venue it was created at> - <name of the project>`
	- `docs/` *subdirectory with images and other webpage related stuff*
	- `README.md`
		- `title` \(or "Noname"\), a \[game/app/tool\] created \[at game jam name \| for something \| ... \].
		- `authors` (name surname - role [music / programming)
		- `screenshots` or gif
		- `Code is` playable or not.
		- `State of the game` [playable / unplayable prototype \| finished game]
		- `Platform` 2 person coop on PC with xbox controller
	- `<game_name>_unity/` *all unity files go here, this is named like this because in unity hub you will see only this name in project structure*
		- `Assets/<your_name>/`: your own utilities / extensions / common classes
		- `Assets/<game_name>/`: all game specific files *this is because all plugins are located by default in \<unity\>/Assets/ directory and it quickly it is impossible to differentiate between your own classes and 3rd party*
			- `Design` *all non essential images used during development*
			- `Images` *all game images*
			- `Materials`
			- `Prefabs`
			- `Scenes` *even if it's one*
			- `Scriptable Objects` *I am still thinking if spaces are good idea in directories*
			- `Shaders`
			- `Scripts` *all your .cs files*
				- `Commands` *this is the counterpart of Controllers from other frameworks*
				- `Models`
				- `Scriptable Objects` *this is a script for a scriptable object, not the scriptable object instance*
				- `Services`
				- `Widgets`
				
## Code conventions:

- `Assets/<your_game>` I don't write any namespace
- `Assets/<your_name>` i put <your_name> namespace. In my case this is `namespace KBobnis`

## StrangeIOC framework
 
 I use this framework and it greatly organizes the file structure inside the `Scripts` directory. Without it, all you have is components that have all types of responsibilities mixed in together and making any sensible structure is futile
