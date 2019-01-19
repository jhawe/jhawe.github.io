---
permalink: /kaggle/
---

## KAGGLE 
Kaggle (https://www.kaggle.com/) offers numerous interesting datasets to the 
interested data scientist and hosts competitions in different fields

## Retrieving Datasets from KAGGLE
To obtain datasets from KAGGLE we can use their dataset API (https://github.com/Kaggle/kaggle-api#datasets).

For now, we simply get the first 100 datasets available which are tagged with 'sport':

```{bash}
mkdir kaggle_dataset_lists
# we get 20 results per page, so we get 5 pages. We remove the header and add it manually
for i in {1..5} ; do 
  sleep 1
  kaggle datasets list -p $i --file-type csv -v --tags sports ; 
done | grep -v downloadCount >> kaggle_dataset_lists/sports.csv
```

Now, whenever we want to select a new dataset for analysis we just 
execute the following lines to download the data and remember
the chosen dataset.

```{bash}
# get random line and extract dataset
sel=$(sort -r kaggle_dataset_lists/sports.csv | head -1)
echo $sel >> kaggle_dataset_lists/sports_selected.csv
grep -v "$sel" kaggle_dataset_lists/sports.csv > temp && mv temp kaggle_dataset_lists/sports.csv
dataset=`echo $sel | cut -f 1 -d ","`

```
