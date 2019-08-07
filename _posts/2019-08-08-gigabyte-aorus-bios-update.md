---
title: Q-Flash for Gigabyte B450 I AORUS PRO WIFI
permalink: /flash-bios-b450-i-aorus-pro-wifi/
excerpt: Brief description of how to update/flash the BIOS of the B450 I AORUS PRO WIFI while avoiding the 'BIOS ID check error'
tags: b450,aorus,gigabyte,bios,update,flash,id check
---

## Motivation
OK, this is a little off topic, but might help someone else at some point so I just post this hardware issue related post.

I recently purchased parts for a new mini-ITX PC system (yeah!). More specifically, I purchased these main components:

* Gigabyte B450 I AORUS PRO WIFI (rev 1.0)
* AMD Ryzen 7 3700X
* Sapphire Radeon RX 5700 XT
* ... other stuff

Now, to be able to get it to run successfully, I knew that I'd have to flash/update the BIOS prior to installing the 3rd Gen Ryzen
processor. For this, I obtained a 'CPU bootkit' (see [here](https://www.amd.com/en/support/kb/faq/pa-100#faq-Short-Term-Processor-Loan-Boot-Kit)) directly from AMD with which I was able to start the PC and enter the BIOS to perform the update, however, ...

> NOTE 1: really nice from AMD: just write them, make it clear that you need an 'old' CPU for flashing the BIOS and they'll send you one 
> (of course: you have to send it back once your're done)

> NOTE 2: Be aware that not every mobo supports the new Ryzens from the start and that a firmware update might be required!

## Problem description
After downloading the (what I thought..) *correct* BIOS version, every time I entered the BIOS and tried to flash the BIOS (pressing F8 to access the Q-Flash utility)
I go the 'BIOS ID check error'.. that. sucked.
Even after trying several different BIOS versions in addition to a collection of different USB devices (which is suggested in some online forums), 
I couldn't get the new BIOS version to install (original was F30, my target version was F40 to enable the 3rd Gen Ryzen).

## Solution
It. Was. So. Simple.

I used the BIOS updates from [this](https://www.gigabyte.com/Motherboard/B450-AORUS-PRO-WIFI-rev-10/support#support-dl-bios) page, although I should have used the ones from [here](https://www.gigabyte.com/Motherboard/B450-I-AORUS-PRO-WIFI-rev-10/support#support-dl-bios).
See the difference? I didn't either,.. at first. Turns out there are two very similar mobo (nice slang for 'motherboard') models:

* B450 I AORUS PRO WIFI (rev 1.0)
* B450 AORUS PRO WIFI (rev 1.0)

Of course, I have the first one since I built a mini-ITX system, however, when looking for the BIOS updates
I neglected the 'I' completely, leading to the failed attempts of updateing the BIOS.

After downloading simply the updates for the correct mobo, it all worked like a charm...

## Summary
Well, really only one thing to say:

** Check, in absolute detail, your mainboard model and make sure to download the appropriate update files! **

That's it, clean and simple. Apparently, other people on the world wide web were able
to resolve their problems exactly the same way...

Until then, farewell!

