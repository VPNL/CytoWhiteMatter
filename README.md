# CytoWhiteMatter
**Kubota, Grotheer, Finzi, Natu, Gomez, &amp; Grill-Spector (2022)**

This repository contains code to analyze the data, compute statistics, and make the individual figure elements. 

#### Overall organization 
Code relating to figures and statistical tests, and data analyses is provided in subdirectories `matlab/` and `r/`. 

`matlab/` contains the matlab code used to generate Figures 1B, 2A, and 6 and Supplementary Figures 1-8. 

'r/code` folder contains the R code used to generate all other figures and statistics in the 'figures/' and 'statistics/' subdirectories.

`r/data` includes the processed data used for figure generation and statistics.

`r/code/classifier` contains the code used for the classification analysis. 

`r/supplement` includes code and data to generate Supplementary Figures 9-12. 

#### Dependencies :package:
The code in `r/` should be runnable on your local machine assuming the following dependencies:
```
R (>= 3.6.0)

tidyverse
lmerTest
patchwork
RColorBrewer 
ggcorrplot

```
