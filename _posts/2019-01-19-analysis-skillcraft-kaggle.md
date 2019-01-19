---
title: "Analysis of SkillCraft Kaggle dataset"
date: "January 19, 2019"
excerpt: "Exploratory analysis of the SkillCraft Kaggle dataset using tidyverse"
---



## Introduction

Ah, this brings me back.
To be honest, this dataset wasn't quite selected at random, but rather I stumbled upon it whilst browsing Kaggle.
I've been enthusiastic about StarCraft II and even it's predecessor StarCraft for a long time, although not so much in recent time due to a significant lack of time/setting higher priorities for it.
So, naturally, when I saw the *SkillCraft* dataset from Kaggle (see https://www.kaggle.com/danofer/skillcraft) I had to check it out :)

StarCraft II (or SC2) is a real time strategy (RTS) game which has a large community and even professional leagues.
Before the start of each game you can pick one of three races (or select one at random) and you start by constructing a base of research and construction facilities. The ultimate goal of each (regular) match is then to either 

1 Destroy all buildings of your opponent or
2 Your opponent forfits the game (i. e., craft a situation from which it is clear that your opponent has no more chance of winning)

Let's check it out!

## Data exploration

The datasets contains 20 columns and 3338 rows.
Unfortunately the dataset does not have any more detailed description other 
than the column names.
In the rest of the analysis I'll assume that 'GameID' is actually 'GamerID',
and that the collected stats are summaries over the gamer's game history.


Let's get a feel for the data, just check for any missing values and
get summary stats per column.

| LeagueIndex| GameID| Age| HoursPerWeek| TotalHours| APM| SelectByHotkeys| AssignToHotkeys| UniqueHotkeys| MinimapAttacks| MinimapRightClicks| NumberOfPACs| GapBetweenPACs| ActionLatency| ActionsInPAC| TotalMapExplored| WorkersMade| UniqueUnitsMade| ComplexUnitsMade| ComplexAbilitiesUsed|
|-----------:|------:|---:|------------:|----------:|---:|---------------:|---------------:|-------------:|--------------:|------------------:|------------:|--------------:|-------------:|------------:|----------------:|-----------:|---------------:|----------------:|--------------------:|
|           1|      0|   0|            0|          0|   0|               0|               0|             0|              0|                  0|            0|              0|             0|            0|                0|           0|               0|                0|                    0|
|           2|      0|   0|            0|          0|   0|               0|               0|             0|              0|                  0|            0|              0|             0|            0|                0|           0|               0|                0|                    0|
|           3|      0|   0|            0|          0|   0|               0|               0|             0|              0|                  0|            0|              0|             0|            0|                0|           0|               0|                0|                    0|
|           4|      0|   0|            0|          0|   0|               0|               0|             0|              0|                  0|            0|              0|             0|            0|                0|           0|               0|                0|                    0|
|           5|      0|   0|            0|          0|   0|               0|               0|             0|              0|                  0|            0|              0|             0|            0|                0|           0|               0|                0|                    0|
|           6|      0|   0|            0|          0|   0|               0|               0|             0|              0|                  0|            0|              0|             0|            0|                0|           0|               0|                0|                    0|
|           7|      0|   0|            0|          0|   0|               0|               0|             0|              0|                  0|            0|              0|             0|            0|                0|           0|               0|                0|                    0|

Within the game there are 'leagues' which are encoded in these data with number from 1-7 (7 being the highest league).
We first replace these values with some more 'speaking' names.

{% highlight r %}
league_names <- c("Bronze", "Silver", "Gold", "Platinum", "Diamond", "Master", "GrandMaster")
# we convert to ordered factors for nicer plotting
league_names <- factor(league_names, levels=league_names, ordered = T)
sc <- sc %>% mutate(LeagueIndex=league_names[LeagueIndex])
{% endhighlight %}

We now create a basic overview per league, melting the data frame for easier
plotting on the way.

{% highlight r %}
# prep the data
sc_melted <- melt(sc)
{% endhighlight %}



{% highlight text %}
## Using LeagueIndex as id variables
{% endhighlight %}



{% highlight r %}
# set a less obtrusive style
theme_set(theme_bw())

# plot overviews

# overall number of players per league
league_summary <- sc %>% group_by(LeagueIndex) %>% summarise(count=n())
ggplot(league_summary, aes(y=count, x=LeagueIndex, fill=LeagueIndex)) + 
  geom_bar(stat="identity") + ggtitle("Number of players per league")
{% endhighlight %}

![center](/figs/2019-01-19-analysis-skillcraft-kaggle/overview_plots-1.png)

{% highlight r %}
# age
ggplot(sc, aes(x=Age)) + 
  geom_histogram(stat = "density") + 
  facet_wrap(~LeagueIndex, ncol=3) + ggtitle("Age by League")
{% endhighlight %}



{% highlight text %}
## Warning: Ignoring unknown parameters: binwidth, bins, pad
{% endhighlight %}

![center](/figs/2019-01-19-analysis-skillcraft-kaggle/overview_plots-2.png)

{% highlight r %}
# apm
ggplot(sc, aes(x=APM)) + 
  geom_histogram(stat="density") + 
  facet_wrap(~LeagueIndex, ncol=3) + ggtitle("APM by League")
{% endhighlight %}



{% highlight text %}
## Warning: Ignoring unknown parameters: binwidth, bins, pad
{% endhighlight %}

![center](/figs/2019-01-19-analysis-skillcraft-kaggle/overview_plots-3.png)

{% highlight r %}
# HoursPerWeek
ggplot(sc, aes(x=HoursPerWeek)) + 
  geom_histogram(stat="density") + 
  facet_wrap(~LeagueIndex, ncol=3) + ggtitle("Hours per week by League")
{% endhighlight %}



{% highlight text %}
## Warning: Ignoring unknown parameters: binwidth, bins, pad
{% endhighlight %}

![center](/figs/2019-01-19-analysis-skillcraft-kaggle/overview_plots-4.png)
Above we can see some interesting stuff already.


Now let's check the total hours played.

{% highlight text %}
## Warning: Ignoring unknown parameters: binwidth, bins, pad
{% endhighlight %}

![center](/figs/2019-01-19-analysis-skillcraft-kaggle/totalhours-1.png)
Whoops, this seems kinda odd, we can't really see anything. There are some player who seem to have played an
extraordinary amount of time. Let's quickly check it in log-space.

{% highlight text %}
## Warning: Ignoring unknown parameters: binwidth, bins, pad
{% endhighlight %}

![center](/figs/2019-01-19-analysis-skillcraft-kaggle/totalhours_log-1.png)
This looks better now. It seems that overall there is not too much of a difference between the idnividual
leagues.
Let's check again on the TotalHours, first a summary both in log-space and actual values.

{% highlight text %}
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
{% endhighlight %}

![center](/figs/2019-01-19-analysis-skillcraft-kaggle/totalhours_overall-1.png)

{% highlight text %}
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
{% endhighlight %}

![center](/figs/2019-01-19-analysis-skillcraft-kaggle/totalhours_overall-2.png)

{% highlight text %}
## # A tibble: 3,338 x 21
##    GameID LeagueIndex   Age HoursPerWeek TotalHours   APM SelectByHotkeys
##     <dbl> <ord>       <dbl>        <dbl>      <dbl> <dbl>           <dbl>
##  1   5140 Diamond        18           24    1000000 281.         0.0234  
##  2   6518 Master         20            8      25000 247.         0.0158  
##  3   2246 Diamond        22           16      20000 248.         0.0237  
##  4   5610 Platinum       22           10      18000 152.         0.0120  
##  5   6242 Gold           24           20      10260  76.6        0.000780
##  6     72 GrandMaster    17           42      10000 213.         0.00904 
##  7   6020 Diamond        22           10       9000 106.         0.00357 
##  8     83 Gold           16           16       6000 154.         0.00168 
##  9   9055 Gold           19           20       6000 102.         0.00205 
## 10     55 Diamond        23           10       5000 129.         0.00330 
## # … with 3,328 more rows, and 14 more variables: AssignToHotkeys <dbl>,
## #   UniqueHotkeys <dbl>, MinimapAttacks <dbl>, MinimapRightClicks <dbl>,
## #   NumberOfPACs <dbl>, GapBetweenPACs <dbl>, ActionLatency <dbl>,
## #   ActionsInPAC <dbl>, TotalMapExplored <dbl>, WorkersMade <dbl>,
## #   UniqueUnitsMade <dbl>, ComplexUnitsMade <dbl>,
## #   ComplexAbilitiesUsed <dbl>, TotalHoursLog <dbl>
{% endhighlight %}
Crazy. There is one player with the age of 18 who has apparently a total of 1,000,000 played hours, and quite high APM.

Let's check whether the APM correlate with the total hours played. We remove this extreme outlier
first, since this one might mess up the plot.

![center](/figs/2019-01-19-analysis-skillcraft-kaggle/apm_vs_totalhours-1.png)
Interesting. We can see that apparently, in the lower leagues in general the
APM seem to be a little lower than in the higher leagues, but it doesn't seem
like the APM are high only for players who have played the game exceedingly
long.

Let's briefly check whether higher APM correlate with higher league placement.
![center](/figs/2019-01-19-analysis-skillcraft-kaggle/apm_totalhours_leagueindex-1.png)

{% highlight text %}
## [1] "Summary for APM model:"
{% endhighlight %}



{% highlight text %}
## 
## Call:
## lm(formula = APM ~ LeagueIndex, data = sc)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -93.310 -24.823  -3.928  19.247 241.064 
## 
## Coefficients:
##               Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   115.7080     1.1094 104.302  < 2e-16 ***
## LeagueIndex.L 113.2875     4.0623  27.888  < 2e-16 ***
## LeagueIndex.Q  17.1778     3.8851   4.421 1.01e-05 ***
## LeagueIndex.C   1.8400     3.1248   0.589    0.556    
## LeagueIndex^4  -2.4442     2.2865  -1.069    0.285    
## LeagueIndex^5   0.2665     1.7399   0.153    0.878    
## LeagueIndex^6   1.7966     1.4396   1.248    0.212    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 37.3 on 3331 degrees of freedom
## Multiple R-squared:  0.3999,	Adjusted R-squared:  0.3989 
## F-statistic:   370 on 6 and 3331 DF,  p-value: < 2.2e-16
{% endhighlight %}



{% highlight text %}
## [1] "Summary for TotalHours model:"
{% endhighlight %}



{% highlight text %}
## 
## Call:
## lm(formula = TotalHours ~ LeagueIndex, data = sc)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -1999   -551   -194     36 997976 
## 
## Coefficients:
##               Estimate Std. Error t value Pr(>|t|)  
## (Intercept)     895.90     515.14   1.739   0.0821 .
## LeagueIndex.L  1284.17    1886.34   0.681   0.4961  
## LeagueIndex.Q   -74.28    1804.08  -0.041   0.9672  
## LeagueIndex.C  -355.53    1451.03  -0.245   0.8065  
## LeagueIndex^4   188.83    1061.74   0.178   0.8589  
## LeagueIndex^5   692.01     807.92   0.857   0.3918  
## LeagueIndex^6   655.99     668.50   0.981   0.3265  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 17320 on 3331 degrees of freedom
## Multiple R-squared:  0.001374,	Adjusted R-squared:  -0.0004245 
## F-statistic: 0.764 on 6 and 3331 DF,  p-value: 0.5982
{% endhighlight %}

## Session Info

{% highlight text %}
## R version 3.4.4 (2018-03-15)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Linux Mint 19
## 
## Matrix products: default
## BLAS: /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.7.1
## LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.7.1
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
##  [5] LC_MONETARY=de_DE.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=de_DE.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=de_DE.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  base     
## 
## other attached packages:
##  [1] bindrcpp_0.2.2  reshape2_1.4.3  forcats_0.3.0   stringr_1.3.1  
##  [5] dplyr_0.7.8     purrr_0.2.5     readr_1.3.1     tidyr_0.8.2    
##  [9] tibble_2.0.1    ggplot2_3.1.0   tidyverse_1.2.1 knitr_1.21     
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_1.0.0        highr_0.7         cellranger_1.1.0 
##  [4] pillar_1.3.1      compiler_3.4.4    plyr_1.8.4       
##  [7] bindr_0.1.1       methods_3.4.4     tools_3.4.4      
## [10] digest_0.6.18     viridisLite_0.3.0 lubridate_1.7.4  
## [13] jsonlite_1.6      evaluate_0.12     nlme_3.1-131     
## [16] gtable_0.2.0      lattice_0.20-35   pkgconfig_2.0.2  
## [19] rlang_0.3.1       cli_1.0.1         rstudioapi_0.9.0 
## [22] haven_2.0.0       xfun_0.4          withr_2.1.2      
## [25] xml2_1.2.0        httr_1.4.0        hms_0.4.2        
## [28] generics_0.0.2    grid_3.4.4        tidyselect_0.2.5 
## [31] glue_1.3.0        R6_2.3.0          fansi_0.4.0      
## [34] readxl_1.2.0      modelr_0.1.2      magrittr_1.5     
## [37] backports_1.1.3   scales_1.0.0      rvest_0.3.2      
## [40] assertthat_0.2.0  colorspace_1.4-0  labeling_0.3     
## [43] utf8_1.1.4        stringi_1.2.4     lazyeval_0.2.1   
## [46] munsell_0.5.0     broom_0.5.1       crayon_1.3.4
{% endhighlight %}
