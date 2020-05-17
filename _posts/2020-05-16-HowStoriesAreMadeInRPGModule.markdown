---
layout: post
title: "How stories are made in RPG Module"
date: 2020-05-16 00:36:00 +0100
categories: server
---

## What is RPG Module

RPG Module is a text adventure **game** for android phones. 

It has two versions: free version and paid full

[![](/assets/rpg_module_stories/logo.png)](https://play.google.com/store/apps/details?id=com.wyspianStudios.rpgModule&hl=en)

[![](/assets/rpg_module_stories/logo_full.png)](https://play.google.com/store/apps/details?id=com.wyspianStudios.rpgModuleFull&hl=en)

Player can choose one of several adventures to play.

![](/assets/rpg_module_stories/screens.png)

Each adventure has multiple endings and parameters.


### Adventures 

Full versions let the player dive into a story for a few hours, mini version are for 20 minute sessions.

| Adventure Name| Version | Translations | Char count |
|---------------|---------|--------------|------------|
| Cube          | full    | pl, en, it   | 55k        |
| Ardens        | full    | pl, en       | 67k        |
| Hermit        | full    | pl, en       | 102k       |
| Me, prophet   | full    | pl           | 56k        |
| Unknown thief | mini    | pl, en       | 12k        |
| Closed world  | mini    | pl, en, it   | 26k        |
| Centuria      | mini    | pl, en       | 15k        |
| The worse     | mini    | pl           | 18k        |


## How's RPG Module different than a regular text adventure


In RPG Module there are several guidelines that often don't exist in other adventure games:
* every situation has at least two answers
* there's never more than 5-10 sentences for the player to read at once before deciding on an action
* it is not obvious which one of many endings is the true one, actually there is no true ending, all have the same value

## How a story config file looks like


This is how the start of Cube story looks like
```
Story cube

Parameter
	zdr starts with 3
	spr starts with 2
	wyt starts with 0
	samo starts with 0

Syt: pok1
	The walls seem wet to the touch, but it might be just an impression. You take a good look at their surface. On the opposite wall you notice a curved rectangular shape. Without a sound, the shape moves up revealing a passage marked with the digit “1”. ( syt -> pok1.stay)
		if [Self-awareness = 0]: 
			Answer: Where am I?
				 () : You take a look around. Flat metal walls and translucent light fixtures do not really indicate much. You take a long look at the glowing digit “1” placed on one of the walls. You come closer and touch it. The “1” digit is just as flat as the wall, but it feels different.
				 (syt -> pok1) : 
		if [Self-awareness = 0]: 
		if [Self-awareness = 1]: 
			Answer: Who am I?
				 () : For a brief moment you feel presence of someone else inside your mind. A separate being that makes itself known to you. You rub your temples to reduce the headache and refocus.
				 (syt -> pok1) : 
		if [Self-awareness = 1]: 
		if [Self-awareness = 2]: 
			Answer: Why am I here?
				 () : You were just a common... Who were you exactly? There is almost nothing you remember from your past. It seems to be shrouded in mist, hidden behind a fence you cannot breach.
				 (syt -> pok1) : 
		if [Self-awareness = 2]: 
			() : You jog your memory determined to find out what happened to you. Unfortunately, you cannot penetrate the dark void inside your head. It is as if your memories have been blocked.
		if [Self-awareness > 0]: 
			Answer: I commit suicide.
				 (endGame -> SpotEnd) : You select one of the walls, take a deep breath, accelerate and, with all your strength, drive your head into the flat metal surface. Your forehead is alight with pain, but you suddenly feel relieved. It seems as if one of the blockades was removed. You get up and run towards the wall. The second time seems easier. And several times more. When you had no more strength to try again, you could almost see your soul abandoning your body.
		Answer: I enter the passage.
			 () : You go in, with one hand outstretched. The door automatically recedes into the upper wall. A blinding white light floods the room. You walk through.
			jeśli samo>0 () : When you enter the light, you hear a scraping noise of large surfaces inside the room you just left. You turn back to find out what is going on, but the door is locked.
			jeśli samo<1 () : Once you enter the light, the door closes behind you.
			 (syt -> pok2) : 
		Answer: I am going nowhere.
			 () : You take a step back and stop in the centre of the room. You sit down on the floor.
```

As you can see, there's some conditional logic baked in those stories.

## How stories are made for RPG Module

I, Krzysztof Bobnis never can't finish a story. They all have just too many possibilities and I get discouraged whenever I try to write one. I always hire or team up with a writer. You can see authors for every story when you open RPG Module and click more info on each adventure.

### Stage 1. Worldbuilding

First stage in each adventure is figuring out the world that the action will take place. For most of our stories we not only declare the world that the story takes place, but also build it.

### Stage 2. Figuring out a story

After we decide or create a world, we are figuring out a story to take place in it.

### Stage 3. Writing first draft of mini adventure situations

We create this and other versions in a plain text file with human readable logic. It more of less looks like the code pasted above. Often this first draft makes us realize how little we have thought about the world and the story. This makes us go back, refine the worldbuilding phase, figure out a more coherent version of what's going on and then write another draft of mini adventure situations.

Exceptions happen where the first draft was already good the first time. With the Cube adventure we had a clear sense of what we want to achieve within the story instead of figuring out a world where the story takes place. But when you want to create a story, but don't have an excellent idea, it's still good to work on the worldbuilding and an even better adventure might come out of it anyway.

### Stage 4. Polishing mini adventure situations

The first draft of situations is always too poor. We need to add conditions, parameter changes and more descriptive texts. We also add more diversity and options to skip some situations or even go the other way with the story. Those story U turns often result in a spectacular end of the story like this one in cube:

```
Answer: I stay where I am.
	 () : You sit down in the middle of the room so that the trembling does not knock you over. The vibrations make your teeth chatter and your head is exploding with pain once again. You are struggling not to throw up. When you think you can’t take it any longer, the trembling stops.
	
	if samo=0 () : You breathe a sigh of relief, but just then you are hit by a massive electric shock. Your muscles contract involuntarily. Everything goes black for you.
	
	if samo=0 (endGame -> ShockEnd) : Then comes another shock, much stronger than the previous one. It throws you against the wall covered with travelling blue lightnings. What comes next is pure pain and darkness.
	
	if samo>0 () : You feel bounded to the labyrinth.
```

### Stage 5. Writing first draft of full adventure situations

See stage 3. But I always find myself writing too many situations at first and compressing them a lot into smaller number of situations but more packed with action, answers and other interesting stuff.

It is not uncommon to squeze 40 situations into 23, but definitely more interesting ones with the same amount of plot.

### Stage 6. Polishing full adventure situation

See stage 4. I think this is the easiest part of all stages. It's pretty straightforward to add parameter changes in already created situations, add conditional answers, endings and more descriptions here and there.

### Stage 7. Moving the story into RPG module config file

A a word document based loosely defined adventure is needed now to be converted into a config file in RPG Module. This is done completely by the developer (Krzysztof Bobnis) and then tested a lot to see whether all situations and endings can be achieved.

### Stage 8. Additional polishing after first reactions of playing in the game.

After the writers will play the adventure a little in the RPG Module engine, it is time to add even more fun parts and conditional texts.
