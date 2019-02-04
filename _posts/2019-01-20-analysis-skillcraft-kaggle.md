---
title: "Analysis of the SkillCraft dataset"
date: "January 20, 2019"
excerpt: "Exploratory analysis of the SkillCraft Kaggle dataset using tidyverse"
tags: "skillcraft starcraft2 gaming esports"
toc: true
permalink: /skillcraft/
---



# Introduction

![Starcraft II screenshot](https://bnetcmsus-a.akamaihd.net/cms/page_media/95QJHO5EOTPG1508778076429.jpg){:width="600px"}

*In-game screenshot from StarCraft II*



Ah, this brings me back!
 
To be honest, this dataset wasn't selected at random, but rather I stumbled upon it whilst browsing Kaggle.
I've been enthusiastic about [StarCraft II](https://starcraft2.com/en-us/) and predecessor [StarCraft](https://starcraft.com/en-us/) for a long time, although recently I didn't play/watch any games due to a significant lack of time/setting higher priorities for it.
So, naturally, when I saw the **SkillCraft** dataset from Kaggle ([link](https://www.kaggle.com/danofer/skillcraft)) I had to check it out :)

## StarCraft II
StarCraft II (or SC2) is a real time strategy (RTS) game which has a large community and several professional leagues.
Before the start of each game you can pick one of three races (or select one at random) and you start by constructing a base of research and construction facilities. The ultimate goal of each (regular) match is then to either

1. Destroy all your opponent's buildings or
2. Make your opponent forfeit the game (i. e. craft a situation from which it is clear that your opponent has no more chance of winning)

Players have to devise specialized strategies, frequently and quickly adjusting to their opponent's moves
and finding a delicate balance between developing their base, training an army and mining resources (minerals and gas).

## Player statistics in SCII
During the game, spectators can assess several statistics for each player.
Amongst intuitive measures such as the amount of workers or units built, constructed buildings and
resources mined, other stats such as the APM (actions-per-minute) allow to assess a player's game activity or even skill.

The dataset collected several such measures across the SC2 scene, conveniently collected
to be analyzed by us, so let's check it out!

# Data exploration

{% highlight text %}
## Error: '../datasets/SkillCraft.csv' does not exist in current working directory ('/mnt/d/work/jhawe.github.io/_R').
{% endhighlight %}
































