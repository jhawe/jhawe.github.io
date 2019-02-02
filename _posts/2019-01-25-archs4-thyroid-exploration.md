---
title: "Analysis of a thyroid gene expression dataset"
date: "January 20, 2019"
excerpt: "Exploratory analysis of a raw and normalized human thyroid gene expression dataset obtained from ARCHS4"
tags: "thyroid gene expression archs4 tsne"
toc: true
publish: false
permalink: /archs4-thyroid-analysis/
---


# Inroduction

This is an exploratory analysis of the downloaded and processed ARCHS<sup>4</sup> 
gene expression data for a [thyroid](https://en.wikipedia.org/wiki/Thyroid) 
tissue specification. 
Data was obtained from ARCHS<sup>4</sup> using the non-official [ARCHS4 data loader](https://github.com/jhawe/archs4_loader)

## Gene expression data
The [central dogma of biology](https://en.wikipedia.org/wiki/Central_dogma_of_molecular_biology) 
states that genes on the DNA of a cell are transcribed into RNAs which are in turn further processed 
and translated into proteins.
Modern experimental technologies such as [next-generation sequencing](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3841808/)
enable researchers to obtain a complete read-out of RNA molecules present in a specific 
biosample at the time of measurement. 
These read-outs can be quantified on a per gene (or per transcript) basis to obtain gene expression
data: A quantitative estimate of the amount of RNA molecules per gene present in individual biosamples.
Using these estimates, scientist seek to answer pressing biomedical questions such as 
to uncover the molecular mechanisms behind cancer or other diseases.

## ARCHS<sup>4<sup>
ARCHS<sup>4</sup> is a project which seeks to unite gene expression data form diverse sources
and provide easy access to a homogenously processed data matrix, containing hundreds of
individual samples, now ready to be jointly analyzed.
In this short analysis we'll have a look on ARCHS<sup>4</sup> Thyroid gene expression data
where we want to get an idea of how uniform these data are and whether additional
(manual) curation is necessary prior to downstream analysis.

## t-SNE
For our look on the data we use the t-SNE algorithm.
TODO

# Exploration
In this analysis we will have have a look at the raw gene counts as well as the
normalized expression matrix as provided by the ARCHS<sup>4</sup> loader.

After loading the data, we see that we have a total of 35238 genes 
measured in 143 samples (common for both raw and normalized data).
Below is a sample of the raw data matrix:


|gene_name | GSM742951| GSM913883| GSM913881| GSM1185644| GSM913884| GSM1185638| GSM913876| GSM913888| GSM1185640|
|:---------|---------:|---------:|---------:|----------:|---------:|----------:|---------:|---------:|----------:|
|A1BG      |  6.927493| 7.0357828| 7.2648815|   6.821685| 7.0674286|   6.134456| 7.5427982|  6.515175|   6.144679|
|A1CF      |  2.782347| 3.1614847| 0.6315621|   2.082302| 0.6385551|   2.411300| 3.2188119|  3.146062|   2.405188|
|A2M       |  9.251757| 9.0018220| 8.9334681|  10.737456| 8.9152148|   9.566849| 8.8980631|  9.897016|  10.421936|
|A2ML1     |  4.100825| 5.1735960| 5.1335194|   3.329747| 4.4340346|   3.678592| 3.7147723|  3.257186|   3.692922|
|A2MP1     |  2.440107| 0.3595955| 2.7401493|   2.133666| 3.2218150|   2.528536| 0.3595955|  3.232522|   2.847332|

In addition to the expression data, the ARCHS<sup>4</sup> loader provides us with
a design table containing the following column names(already somewhat adjusted for better readability):


{% highlight text %}
## [1] "sample"          "tissue"          "series"          "organism"       
## [5] "molecule"        "characteristics" "description"     "instrument"
{% endhighlight %}

Before looking in detail at the expression data, we first have a look at the individual columns
of the design table in order to better get to know our data.
Below we show for each column of the design matrix the unique values contained
therein. This is a bit messy, but for now we accept this:


{% highlight text %}
## [[1]]
## # A tibble: 15 x 1
##    tissue                                      
##    <chr>                                       
##  1 thyroid                                     
##  2 parathyroid adenoma                         
##  3 thyroid tissue                              
##  4 primary thyroid cell line                   
##  5 thyroid cancer cells                        
##  6 non-medullary thyroid carcinoma cell line   
##  7 thyroid gland tissue female fetal (40 weeks)
##  8 thyroid gland tissue female fetal (37 weeks)
##  9 thyroid gland tissue male adult (54 years)  
## 10 thyroid gland tissue male adult (37 years)  
## 11 thyroid gland tissue female adult (51 year) 
## 12 thyroid gland tissue female adult (53 years)
## 13 papillary thyroid cancer invasive region    
## 14 papillary thyroid cancer central region     
## 15 papillary thyroid                           
## 
## [[2]]
## # A tibble: 2 x 1
##   molecule 
##   <chr>    
## 1 polyA RNA
## 2 total RNA
## 
## [[3]]
## # A tibble: 75 x 1
##    characteristics                                                         
##    <chr>                                                                   
##  1 library type: single-endXx-xXread length: 50                            
##  2 patient: 2Xx-xXtissue: Parathyroid tumorXx-xXagent: OHTXx-xXtime: 24h   
##  3 patient: 2Xx-xXtissue: Parathyroid tumorXx-xXagent: DPNXx-xXtime: 24h   
##  4 disease state: TumorXx-xXtissue: thyroid                                
##  5 patient: 2Xx-xXtissue: Parathyroid tumorXx-xXagent: OHTXx-xXtime: 48h   
##  6 disease state: NormalXx-xXtissue: thyroid                               
##  7 patient: 1Xx-xXtissue: Parathyroid tumorXx-xXagent: DPNXx-xXtime: 48h   
##  8 patient: 3Xx-xXtissue: Parathyroid tumorXx-xXagent: DPNXx-xXtime: 48h   
##  9 patient: 1Xx-xXtissue: Parathyroid tumorXx-xXagent: ControlXx-xXtime: 2…
## 10 patient: 2Xx-xXtissue: Parathyroid tumorXx-xXagent: ControlXx-xXtime: 4…
## # … with 65 more rows
## 
## [[4]]
## # A tibble: 64 x 1
##    description
##    <chr>      
##  1 <NA>       
##  2 Sample 11  
##  3 Sample 9   
##  4 Sample 12  
##  5 Sample 4   
##  6 Sample 16  
##  7 Sample 1   
##  8 Sample 8   
##  9 Sample 5   
## 10 Sample 22  
## # … with 54 more rows
## 
## [[5]]
## # A tibble: 4 x 1
##   instrument          
##   <chr>               
## 1 Illumina HiSeq 2000 
## 2 Illumina HiSeq 2500 
## 3 Illumina NextSeq 500
## 4 Illumina HiSeq 4000
{% endhighlight %}

Let's also check how many samples we get if we group by the individual 'tissues':


{% highlight text %}
## # A tibble: 15 x 2
##    tissue                                       count
##    <chr>                                        <int>
##  1 thyroid tissue                                  35
##  2 thyroid                                         30
##  3 non-medullary thyroid carcinoma cell line       27
##  4 parathyroid adenoma                             23
##  5 thyroid cancer cells                             8
##  6 papillary thyroid cancer central region          3
##  7 papillary thyroid cancer invasive region         3
##  8 primary thyroid cell line                        2
##  9 thyroid gland tissue female adult (53 years)     2
## 10 thyroid gland tissue female fetal (37 weeks)     2
## 11 thyroid gland tissue female fetal (40 weeks)     2
## 12 thyroid gland tissue male adult (37 years)       2
## 13 thyroid gland tissue male adult (54 years)       2
## 14 papillary thyroid                                1
## 15 thyroid gland tissue female adult (51 year)      1
{% endhighlight %}

As we can see there is some diversity in this column. We can also see, however, that we can probably combine some of these annotations since they seem very similar (look e.g. at the 'thyroid tissue' and 'thyroid' annotation).
If we'd want to extract a dataset as homogenuous as possible from these data we could consider doing this, but for now we stick with what we have.

## Raw and batch normalized gene expression

Ok, now let's have a look at the actual gene expression data.
We will have a look at the histogram of all expression values and a heatmap
of the top 1% most variable genes. We will do this both for the normalized
data as well as the raw gene expression counts for comparison:

<img src="/assets/figures/2019-01-25-archs4-thyroid-exploration/expression_overview-1.png" title="center" alt="center" style="display: block; margin: auto;" /><img src="/assets/figures/2019-01-25-archs4-thyroid-exploration/expression_overview-2.png" title="center" alt="center" style="display: block; margin: auto;" /><img src="/assets/figures/2019-01-25-archs4-thyroid-exploration/expression_overview-3.png" title="center" alt="center" style="display: block; margin: auto;" />

TODO describe what we see

## t-SNE
Now let's do some tSNE plots to see whether we can see any specific clusters emerging.
Specifically, we will look at two types of t-SNE plots: One for the raw expression data as 
was extracted from ARCHS4 and one using the batch normalized data.

<img src="/assets/figures/2019-01-25-archs4-thyroid-exploration/tsne-1.png" title="center" alt="center" style="display: block; margin: auto;" /><img src="/assets/figures/2019-01-25-archs4-thyroid-exploration/tsne-2.png" title="center" alt="center" style="display: block; margin: auto;" />

TODO describe what we see

# Session Info

{% highlight text %}
## R version 3.4.4 (2018-03-15)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 18.04.1 LTS
## 
## Matrix products: default
## BLAS: /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.7.1
## LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.7.1
## 
## locale:
##  [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
##  [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
##  [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
## [10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  base     
## 
## other attached packages:
##  [1] RColorBrewer_1.1-2 bindrcpp_0.2.2     Rtsne_0.15        
##  [4] pheatmap_1.0.12    reshape2_1.4.3     forcats_0.3.0     
##  [7] stringr_1.3.1      dplyr_0.7.8        purrr_0.3.0       
## [10] readr_1.3.1        tidyr_0.8.2        tibble_2.0.1      
## [13] ggplot2_3.1.0      tidyverse_1.2.1    knitr_1.21        
## 
## loaded via a namespace (and not attached):
##  [1] tidyselect_0.2.5 xfun_0.4         haven_2.0.0      lattice_0.20-35 
##  [5] colorspace_1.4-0 generics_0.0.2   utf8_1.1.4       rlang_0.3.1     
##  [9] pillar_1.3.1     glue_1.3.0       withr_2.1.2      modelr_0.1.2    
## [13] readxl_1.2.0     bindr_0.1.1      plyr_1.8.4       munsell_0.5.0   
## [17] gtable_0.2.0     cellranger_1.1.0 rvest_0.3.2      evaluate_0.12   
## [21] labeling_0.3     fansi_0.4.0      highr_0.7        broom_0.5.1     
## [25] methods_3.4.4    Rcpp_1.0.0       scales_1.0.0     backports_1.1.3 
## [29] jsonlite_1.6     digest_0.6.18    hms_0.4.2        stringi_1.2.4   
## [33] grid_3.4.4       cli_1.0.1        tools_3.4.4      magrittr_1.5    
## [37] lazyeval_0.2.1   crayon_1.3.4     pkgconfig_2.0.2  xml2_1.2.0      
## [41] lubridate_1.7.4  assertthat_0.2.0 httr_1.4.0       rstudioapi_0.9.0
## [45] R6_2.3.0         nlme_3.1-131     compiler_3.4.4
{% endhighlight %}
