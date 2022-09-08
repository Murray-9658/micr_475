hmk_02
================
murray stokes

### Load tidyverse and suppress its message

``` r
library(tidyverse)
```

### Assign values to objects “a” and “b”

``` r
a <- 4/9
b <- 4/11
```

### Determine if a is less than b

``` r
a > b
```

    [1] TRUE

### List objects in environment

``` r
ls()
```

    [1] "a" "b"

### Remove objects from environment

``` r
rm(list = ls())
```

### List objects in environment

``` r
ls()
```

    character(0)

### Display loaded pacakges

``` r
search()
```

     [1] ".GlobalEnv"        "package:forcats"   "package:stringr"  
     [4] "package:dplyr"     "package:purrr"     "package:readr"    
     [7] "package:tidyr"     "package:tibble"    "package:ggplot2"  
    [10] "package:tidyverse" "tools:quarto"      "package:stats"    
    [13] "package:graphics"  "package:grDevices" "package:utils"    
    [16] "package:datasets"  "package:methods"   "Autoloads"        
    [19] "package:base"     
