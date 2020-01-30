---
title: Unix AWK madness
permalink: /awk-numeric-madness/
excerpt: A brief journey of using the unix AWK tool for filtering small numeric values
tags: awk unix filtering small exponential numeric values
---

> Ok, not really 'madness' but still this issue somewhat made me feel like I'm
loosing my mind at some point...

If you are using Unix's [awk](https://en.wikipedia.org/wiki/AWK) on a regular basis,
you might encounter a case where you want to filter a file by a column containing
numeric values. You can do this by a simple statement if, for example, you want to
filter in the first column (the '$1' in the code):

```
awk '{if($1+0 <= 0.05) print; }'
```
The line above reads: If the value of the first entry in a row is smaller than
0.05, print the whole line.
> NOTE: You could also use exponential representation, e.g. `5e-2`, `1e-5`, etc.

**IMPORTANT**: You need to add the '+0' to make `awk` convert the column values into
numeric ('adding 0' so we do not change the value). I first did not know about this,
which led to a weird behavior of `awk` (i.e. some values which matched the criteria were not filtered, but only rows with a value below the cutoff were present in the output). Of course,
this was entirely me not being knowledgeable enough to use `awk` properly...

Just wanted to put this information out there, hope this helps someone encountering
the same issue in the future!
