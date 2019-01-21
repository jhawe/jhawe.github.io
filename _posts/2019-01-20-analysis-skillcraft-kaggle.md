---
title: "Analysis of the SkillCraft dataset"
date: "January 20, 2019"
excerpt: "Exploratory analysis of the SkillCraft Kaggle dataset using tidyverse"
tags: "skillcraft starcraft2 gaming esports"
toc: true
permalink: /skillcraft/
---



# Introduction

Ah, this brings me back.
To be honest, this dataset wasn't quite selected at random, but rather I stumbled upon it whilst browsing Kaggle.
I've been enthusiastic about StarCraft II and even of its predecessor StarCraft for a long time, although recently I didn't play/watch any games due to a significant lack of time/setting higher priorities for it.
So, naturally, when I saw the *SkillCraft* dataset from Kaggle (see https://www.kaggle.com/danofer/skillcraft) I had to check it out :)

StarCraft II (or SC2) is a real time strategy (RTS) game which has a large community and even professional leagues.
Before the start of each game you can pick one of three races (or select one at random) and you start by constructing a base of research and construction facilities. The ultimate goal of each (regular) match is then to either 

1. Destroy all buildings of your opponent or
2. Your opponent forfits the game (i. e., craft a situation from which it is clear that your opponent has no more chance of winning)

Let's check it out!

# Data exploration

The datasets contains 20 columns and 3338 rows.
Unfortunately the dataset does not have any more detailed description other 
than the column names.
In the rest of the analysis I'll assume that 'GameID' is actually 'GamerID',
and that the collected stats are summaries over the gamer's game history.


Let's get a feel for the data, just check for any missing values and
get summary stats per column.

{% highlight r %}
kable(sc %>% group_by(LeagueIndex) %>% summarise_all(.funs = function(x) {
    sum(is.na(x) | x == "?" | x == "")
}))
{% endhighlight %}



| LeagueIndex| GameID| Age| HoursPerWeek| TotalHours| APM| SelectByHotkeys| AssignToHotkeys| UniqueHotkeys| MinimapAttacks| MinimapRightClicks| NumberOfPACs| GapBetweenPACs| ActionLatency| ActionsInPAC| TotalMapExplored| WorkersMade| UniqueUnitsMade| ComplexUnitsMade| ComplexAbilitiesUsed|
|-----------:|------:|---:|------------:|----------:|---:|---------------:|---------------:|-------------:|--------------:|------------------:|------------:|--------------:|-------------:|------------:|----------------:|-----------:|---------------:|----------------:|--------------------:|
|           1|      0|   0|            0|          0|   0|               0|               0|             0|              0|                  0|            0|              0|             0|            0|                0|           0|               0|                0|                    0|
|           2|      0|   0|            0|          0|   0|               0|               0|             0|              0|                  0|            0|              0|             0|            0|                0|           0|               0|                0|                    0|
|           3|      0|   0|            0|          0|   0|               0|               0|             0|              0|                  0|            0|              0|             0|            0|                0|           0|               0|                0|                    0|
|           4|      0|   0|            0|          0|   0|               0|               0|             0|              0|                  0|            0|              0|             0|            0|                0|           0|               0|                0|                    0|
|           5|      0|   0|            0|          0|   0|               0|               0|             0|              0|                  0|            0|              0|             0|            0|                0|           0|               0|                0|                    0|
|           6|      0|   0|            0|          0|   0|               0|               0|             0|              0|                  0|            0|              0|             0|            0|                0|           0|               0|                0|                    0|
|           7|      0|   0|            0|          0|   0|               0|               0|             0|              0|                  0|            0|              0|             0|            0|                0|           0|               0|                0|                    0|

Within the game there are 'leagues' which are encoded in these data with numbers from 1-7 (7 being the highest league).
We don't like this representation very much, let's repace it with some more 'speaking' names.


{% highlight r %}
league_names <- c("Bronze", "Silver", "Gold", "Platinum", "Diamond", "Master", 
    "GrandMaster")
# we convert to ordered factors for nicer plotting
league_names <- factor(league_names, levels = league_names, ordered = T)

sc <- sc %>% mutate(LeagueIndex = league_names[LeagueIndex])
{% endhighlight %}

## Per league overviews

### General overview

Let's create a basic overview per league.


{% highlight r %}
# set a less obtrusive style
theme_set(theme_bw())

# plot overviews

# overall number of players per league
league_summary <- sc %>% group_by(LeagueIndex) %>% summarise(count = n())

ggplot(league_summary, aes(y = count, x = LeagueIndex, fill = LeagueIndex)) + 
    geom_bar(stat = "identity") + ggtitle("Number of players per league")
{% endhighlight %}

<img src="/assets/figures/2019-01-20-analysis-skillcraft-kaggle/overview_plots-1.png" title="center" alt="center" style="display: block; margin: auto;" />

{% highlight r %}
# age
ggplot(sc, aes(x = Age)) + geom_histogram(stat = "density") + facet_wrap(~LeagueIndex, 
    ncol = 3) + ggtitle("Age by League")
{% endhighlight %}



{% highlight text %}
## Warning: Ignoring unknown parameters: binwidth, bins, pad
{% endhighlight %}

<img src="/assets/figures/2019-01-20-analysis-skillcraft-kaggle/overview_plots-2.png" title="center" alt="center" style="display: block; margin: auto;" />

{% highlight r %}
# apm
ggplot(sc, aes(x = APM)) + geom_histogram(stat = "density") + facet_wrap(~LeagueIndex, 
    ncol = 3) + ggtitle("APM by League")
{% endhighlight %}



{% highlight text %}
## Warning: Ignoring unknown parameters: binwidth, bins, pad
{% endhighlight %}

<img src="/assets/figures/2019-01-20-analysis-skillcraft-kaggle/overview_plots-3.png" title="center" alt="center" style="display: block; margin: auto;" />

{% highlight r %}
# HoursPerWeek
ggplot(sc, aes(x = HoursPerWeek)) + geom_histogram(stat = "density") + facet_wrap(~LeagueIndex, 
    ncol = 3) + ggtitle("Hours per week by League")
{% endhighlight %}



{% highlight text %}
## Warning: Ignoring unknown parameters: binwidth, bins, pad
{% endhighlight %}

<img src="/assets/figures/2019-01-20-analysis-skillcraft-kaggle/overview_plots-4.png" title="center" alt="center" style="display: block; margin: auto;" />

Above we can see some interesting stuff already.
TODO

### Total hours played 
Now let's check the total hours played over all players, again we first check by league.

{% highlight r %}
# TotalHours
ggplot(sc, aes(x = TotalHours)) + geom_histogram(stat = "density") + facet_wrap(~LeagueIndex, 
    ncol = 3) + ggtitle("Total Hours by League")
{% endhighlight %}



{% highlight text %}
## Warning: Ignoring unknown parameters: binwidth, bins, pad
{% endhighlight %}

<img src="/assets/figures/2019-01-20-analysis-skillcraft-kaggle/totalhours-1.png" title="center" alt="center" style="display: block; margin: auto;" />

Whoops, this seems kinda odd, we can't really see anything. There are some player who seem to have played an
extraordinary amount of time. Let's quickly check it in log-space.


{% highlight r %}
# TotalHours
ggplot(sc, aes(x = log10(TotalHours))) + geom_histogram(stat = "density") + 
    facet_wrap(~LeagueIndex, ncol = 3) + ggtitle("Total Hours by League")
{% endhighlight %}



{% highlight text %}
## Warning: Ignoring unknown parameters: binwidth, bins, pad
{% endhighlight %}

<img src="/assets/figures/2019-01-20-analysis-skillcraft-kaggle/totalhours_log-1.png" title="center" alt="center" style="display: block; margin: auto;" />

This looks better now. It seems that overall there is not too much of a difference between the individual
leagues.
Let's check again on the TotalHours, let's get the table and sort it by TotalHours, decreasingly.


{% highlight r %}
# sort by total hours played and show the top of the list
kable(head(sc %>% arrange(desc(TotalHours))))
{% endhighlight %}



| GameID|LeagueIndex | Age| HoursPerWeek| TotalHours|      APM| SelectByHotkeys| AssignToHotkeys| UniqueHotkeys| MinimapAttacks| MinimapRightClicks| NumberOfPACs| GapBetweenPACs| ActionLatency| ActionsInPAC| TotalMapExplored| WorkersMade| UniqueUnitsMade| ComplexUnitsMade| ComplexAbilitiesUsed|
|------:|:-----------|---:|------------:|----------:|--------:|---------------:|---------------:|-------------:|--------------:|------------------:|------------:|--------------:|-------------:|------------:|----------------:|-----------:|---------------:|----------------:|--------------------:|
|   5140|Diamond     |  18|           24|    1000000| 281.4246|       0.0234282|       0.0007995|             5|      0.0000407|          0.0004472|    0.0051355|        28.1164|       36.1266|       5.8522|               29|   0.0013279|               6|        0.0000000|            0.0000000|
|   6518|Master      |  20|            8|      25000| 247.0164|       0.0157938|       0.0004384|             8|      0.0003081|          0.0013389|    0.0046445|        17.6471|       37.1837|       6.5944|               29|   0.0018602|               6|        0.0000000|            0.0000118|
|   2246|Diamond     |  22|           16|      20000| 248.0490|       0.0237032|       0.0003907|             7|      0.0000000|          0.0002047|    0.0046513|        37.8795|       45.3760|       4.7560|               21|   0.0015256|               6|        0.0000000|            0.0000000|
|   5610|Platinum    |  22|           10|      18000| 152.2374|       0.0119831|       0.0002055|             1|      0.0000158|          0.0003636|    0.0033515|        52.1896|       63.9811|       4.9575|               19|   0.0006798|               5|        0.0000000|            0.0000000|
|   6242|Gold        |  24|           20|      10260|  76.5852|       0.0007798|       0.0001967|             0|      0.0000632|          0.0003161|    0.0024377|        42.9480|       84.6340|       5.9107|               27|   0.0004496|              10|        0.0002459|            0.0003583|
|     72|GrandMaster |  17|           42|      10000| 212.6022|       0.0090397|       0.0006762|             6|      0.0011635|          0.0012530|    0.0049525|        24.6117|       41.7671|       6.6104|               45|   0.0022773|               9|        0.0001293|            0.0002486|



{% highlight r %}
# define our maximum for total_hours (10 years)
max_totalhours <- 10 * 365.25 * 24
{% endhighlight %}

Crazy. There is one player (age 18!) who has apparently a total of 1,000,000 played hours, and quite high APM.
Let's do the math, shall we? So 1,000,000 hours, that would be like 41,666 days and about 114 years. Not bad, but
I think for the sake of our further analysis we should filter out unreasonable total hours (as I mentioned, it might be we did not
interpret the data correctly, too).
Anyways, before doing any more analysis, we remove all players with TotalHours > 8.766 &times; 10<sup>4</sup>, which would 
be about 10 years.


{% highlight r %}
sc <- sc %>% filter(TotalHours < max_totalhours) %>% mutate(TotalHoursLog = log10(TotalHours))

# plot again
ggplot(sc, aes(x = TotalHours)) + geom_histogram() + ggtitle("Total hours played over all players")
{% endhighlight %}

<img src="/assets/figures/2019-01-20-analysis-skillcraft-kaggle/totalhours_filtered-1.png" title="center" alt="center" style="display: block; margin: auto;" />

{% highlight r %}
ggplot(sc, aes(x = TotalHoursLog)) + geom_histogram() + ggtitle("log10 Total hours played over all players")
{% endhighlight %}

<img src="/assets/figures/2019-01-20-analysis-skillcraft-kaggle/totalhours_filtered-2.png" title="center" alt="center" style="display: block; margin: auto;" />

Ah, this looks much better now!

### APM for and TotalHours are indicative of league placement
Let's check whether the APM correlate with the total hours played. We remove this extreme outlier
first, since this would mess up the plot.


{% highlight r %}
ggplot(sc, aes(x = TotalHours, y = APM, col = LeagueIndex)) + geom_point() + 
    ggtitle("Total hours played versus APM")
{% endhighlight %}

<img src="/assets/figures/2019-01-20-analysis-skillcraft-kaggle/apm_totalhours_vs_leagueindex-1.png" title="center" alt="center" style="display: block; margin: auto;" />

Interesting. We can see that apparently, in the lower leagues in general the
APM seem to be a little lower than in the higher leagues, but it doesn't seem
like the APM are high only for players who have played the game exceedingly
long. To get a less crowded picture, let's do the same plot again in log-space
for the TotalHours.


{% highlight r %}
ggplot(sc, aes(x = TotalHoursLog, y = APM, col = LeagueIndex)) + geom_point() + 
    ggtitle("Total hours played versus APM")
{% endhighlight %}

<img src="/assets/figures/2019-01-20-analysis-skillcraft-kaggle/apm_totalhours_vs_leagueindex_log-1.png" title="center" alt="center" style="display: block; margin: auto;" />

Let's briefly check whether higher APM and TotalHours values correlate with 
higher league placement.


{% highlight r %}
# get our two variables and filter out the extreme TotalHours outlier
sc_sub <- sc %>% select(GameID, LeagueIndex, TotalHours, APM)
sc_sub <- melt(sc_sub, id.vars = c("GameID", "LeagueIndex"))
ggplot(sc_sub, aes(x = LeagueIndex, y = value, fill = LeagueIndex)) + geom_violin() + 
    facet_wrap(~variable, nrow = 2, scales = "free") + ggtitle("APM and TotalHours stratified by LeagueIndex")
{% endhighlight %}

<img src="/assets/figures/2019-01-20-analysis-skillcraft-kaggle/apm_totalhours_leagueindex-1.png" title="center" alt="center" style="display: block; margin: auto;" />

{% highlight r %}
# do a simple linear model to see whether LeagueIndex is indicative of the
# APM and TotalHours
lm_apm <- lm(APM ~ LeagueIndex, data = sc)
lm_thours <- lm(TotalHours ~ LeagueIndex, data = sc)

print("Summary for APM model:")
{% endhighlight %}



{% highlight text %}
## [1] "Summary for APM model:"
{% endhighlight %}



{% highlight r %}
summary(lm_apm)
{% endhighlight %}



{% highlight text %}
## 
## Call:
## lm(formula = APM ~ LeagueIndex, data = sc)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -93.310 -24.799  -3.938  19.251 241.251 
## 
## Coefficients:
##               Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   115.6813     1.1068 104.514  < 2e-16 ***
## LeagueIndex.L 113.2522     4.0530  27.943  < 2e-16 ***
## LeagueIndex.Q  17.2389     3.8763   4.447 8.98e-06 ***
## LeagueIndex.C   1.9162     3.1178   0.615    0.539    
## LeagueIndex^4  -2.4592     2.2813  -1.078    0.281    
## LeagueIndex^5   0.1647     1.7361   0.095    0.924    
## LeagueIndex^6   1.7045     1.4365   1.187    0.235    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 37.22 on 3330 degrees of freedom
## Multiple R-squared:  0.4007,	Adjusted R-squared:  0.3996 
## F-statistic: 371.1 on 6 and 3330 DF,  p-value: < 2.2e-16
{% endhighlight %}



{% highlight r %}
print("Summary for TotalHours model:")
{% endhighlight %}



{% highlight text %}
## [1] "Summary for TotalHours model:"
{% endhighlight %}



{% highlight r %}
summary(lm_thours)
{% endhighlight %}



{% highlight text %}
## 
## Call:
## lm(formula = TotalHours ~ LeagueIndex, data = sc)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1341.0  -288.4   -93.8   142.0 24011.6 
## 
## Coefficients:
##               Estimate Std. Error t value Pr(>|t|)    
## (Intercept)     718.36      24.47  29.355  < 2e-16 ***
## LeagueIndex.L  1049.30      89.61  11.710  < 2e-16 ***
## LeagueIndex.Q   332.53      85.70   3.880 0.000106 ***
## LeagueIndex.C   151.85      68.93   2.203 0.027673 *  
## LeagueIndex^4    88.68      50.44   1.758 0.078808 .  
## LeagueIndex^5    14.00      38.38   0.365 0.715322    
## LeagueIndex^6    42.71      31.76   1.345 0.178768    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 822.9 on 3330 degrees of freedom
## Multiple R-squared:  0.07834,	Adjusted R-squared:  0.07668 
## F-statistic: 47.18 on 6 and 3330 DF,  p-value: < 2.2e-16
{% endhighlight %}

## Predicting league placement


{% highlight r %}
library(randomForest)

# remove gameId
data <- mutate(sc, GameID = NULL, TotalHoursLog = NULL)

model <- randomForest(LeagueIndex ~ ., data = data, ntree = 100)
print(model)
{% endhighlight %}



{% highlight text %}
## 
## Call:
##  randomForest(formula = LeagueIndex ~ ., data = data, ntree = 100) 
##                Type of random forest: classification
##                      Number of trees: 100
## No. of variables tried at each split: 4
## 
##         OOB estimate of  error rate: 59.93%
## Confusion matrix:
##             Bronze Silver Gold Platinum Diamond Master GrandMaster
## Bronze          50     64   32       18       3      0           0
## Silver          34    109  104       89      11      0           0
## Gold            22     68  178      204      73      8           0
## Platinum         6     43  144      337     227     54           0
## Diamond          0      7   43      234     334    185           0
## Master           0      0    6       64     223    326           2
## GrandMaster      0      0    0        0       3     29           3
##             class.error
## Bronze        0.7005988
## Silver        0.6858790
## Gold          0.6781193
## Platinum      0.5844636
## Diamond       0.5840598
## Master        0.4750403
## GrandMaster   0.9142857
{% endhighlight %}

### Performance

Wonderful! So we now fitted the random forest model, but as you can see we were not able to do a satisfying job here (out-of-bag error rate 58.75%).


{% highlight r %}
mock_leagues <- factor(c(rep("bad", 4), rep("good", 3)))
names(mock_leagues) <- levels(sc$LeagueIndex)

sc_mock <- mutate(data, LeagueIndex = mock_leagues[LeagueIndex])
model_mock <- randomForest(LeagueIndex ~ ., data = sc_mock, ntree = 100)
{% endhighlight %}
### Feature importance


# Session Info

{% highlight r %}
sessionInfo()
{% endhighlight %}



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
##  [1] randomForest_4.6-14 bindrcpp_0.2.2      reshape2_1.4.3     
##  [4] forcats_0.3.0       stringr_1.3.1       dplyr_0.7.8        
##  [7] purrr_0.2.5         readr_1.3.1         tidyr_0.8.2        
## [10] tibble_2.0.1        ggplot2_3.1.0       tidyverse_1.2.1    
## [13] knitr_1.21         
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_1.0.0        highr_0.7         formatR_1.5      
##  [4] cellranger_1.1.0  pillar_1.3.1      compiler_3.4.4   
##  [7] plyr_1.8.4        bindr_0.1.1       methods_3.4.4    
## [10] tools_3.4.4       digest_0.6.18     viridisLite_0.3.0
## [13] lubridate_1.7.4   jsonlite_1.6      evaluate_0.12    
## [16] nlme_3.1-131      gtable_0.2.0      lattice_0.20-35  
## [19] pkgconfig_2.0.2   rlang_0.3.1       cli_1.0.1        
## [22] rstudioapi_0.9.0  haven_2.0.0       xfun_0.4         
## [25] withr_2.1.2       xml2_1.2.0        httr_1.4.0       
## [28] hms_0.4.2         generics_0.0.2    grid_3.4.4       
## [31] tidyselect_0.2.5  glue_1.3.0        R6_2.3.0         
## [34] readxl_1.2.0      modelr_0.1.2      magrittr_1.5     
## [37] backports_1.1.3   scales_1.0.0      rvest_0.3.2      
## [40] assertthat_0.2.0  colorspace_1.4-0  labeling_0.3     
## [43] stringi_1.2.4     lazyeval_0.2.1    munsell_0.5.0    
## [46] broom_0.5.1       crayon_1.3.4
{% endhighlight %}
