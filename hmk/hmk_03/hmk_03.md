Homework 3
================
Murray Stokes

In order to use tidyverse functions, I must first load the package using
library(“package name”)

``` r
library(tidyverse)
```

# Data input/output

I created an Excel sheet containing the brand, color, and price of
drills. I then converted this sheet to a .csv file so that it can be
analyzed in RStudio.

Using the read_csv function and assigning it to the object “drills” I
can further investigate and manipulate this object.

``` r
drills <- read_csv("hmk_03_sheet.csv", 
                   show_col_types = FALSE, 
                   col_names = c("brand", "color", "price") )
```

Because I did not specify the column types, an error appears telling me
that column types are unspecified, I include the argument
“show_col_types = FALSE” to quiet this message.

I also used “col_names” to pass a character vector to use as my column
names.

# Investigating the properties of data frames

I use the str() function to view the data frame. This function is part
of base R.

str() gives me all information I could possibly need from the targeted
data frame

``` r
str(drills)
```

    spec_tbl_df [3 × 3] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
     $ brand: chr [1:3] "Dewalt" "Milwaukee" "Black and Decker"
     $ color: chr [1:3] "Yellow" "Red" "Orange"
     $ price: num [1:3] 100 90 70
     - attr(*, "spec")=
      .. cols(
      ..   brand = col_character(),
      ..   color = col_character(),
      ..   price = col_double()
      .. )
     - attr(*, "problems")=<externalptr> 

glimpse() is a tidyverse function, gives me a short and descriptive view
into my data frame. At my current level of understanding, I feel that
glimpse() is more useful as it tells me column names, data types, and
the information within the data frame itself. str() also provides this
information, but it seems clearer using glimpse()

``` r
glimpse(drills)
```

    Rows: 3
    Columns: 3
    $ brand <chr> "Dewalt", "Milwaukee", "Black and Decker"
    $ color <chr> "Yellow", "Red", "Orange"
    $ price <dbl> 100, 90, 70

# Manipulating data frames

I want to know the sales tax of each drill, so I multiply the values
within the Price column by 0.1, to create a new column “Tax”

``` r
drills$tax <- (drills$price * 0.1)
```

I could go further with this by adding the values of Tax to Price in a
new column called, “Final_cost”

``` r
drills$final_cost <- (drills$price + drills$tax)
```

# Working on columns

I will now calculate the mean final cost of the drills.

``` r
mean(drills$final_cost)
```

    [1] 95.33333

# Accessing elements of data frames

“drills\[1\]” displays all information within the first column of the
data frame, the column name, and data type.

``` r
drills[1]
```

    # A tibble: 3 × 1
      brand           
      <chr>           
    1 Dewalt          
    2 Milwaukee       
    3 Black and Decker

“drills\[\[1\]\]” only displays the information within each cell

``` r
drills[[1]]
```

    [1] "Dewalt"           "Milwaukee"        "Black and Decker"

“drills\$color” displays the information within the column named “color”

``` r
drills$color
```

    [1] "Yellow" "Red"    "Orange"

“drills\[1, 1\]” displays the information within the first column and
first row. (Like coordinates)

``` r
drills[1, 1]
```

    # A tibble: 1 × 1
      brand 
      <chr> 
    1 Dewalt

“drills\[ , 1\]” displays the information within the first column (not
limited by a specific row)

``` r
drills[ , 1]
```

    # A tibble: 3 × 1
      brand           
      <chr>           
    1 Dewalt          
    2 Milwaukee       
    3 Black and Decker

“drills\[1, \]” displays the information within the first row (not
limited by a specific column designation)

``` r
drills[1, ]
```

    # A tibble: 1 × 5
      brand  color  price   tax final_cost
      <chr>  <chr>  <dbl> <dbl>      <dbl>
    1 Dewalt Yellow   100    10        110

# Optional challenge

Explain in what ways accessing elements of lists are like accessing
columns of data frames, and given that, how it shows that data frames
are a type of list.

I am first creating a list of dog breeds, their weight, and if they like
bones

``` r
dog_list <- list( breed = c("Collie", "Lab", "ChowChow"),
                  weight = c(50, 90, 140),
                  likes_bones = c(TRUE, TRUE, FALSE))
```

I verify that this is indeed a list by using the class() function

``` r
class(dog_list)
```

    [1] "list"

Using the str() function, I show what is contained within the list

``` r
str(dog_list)
```

    List of 3
     $ breed      : chr [1:3] "Collie" "Lab" "ChowChow"
     $ weight     : num [1:3] 50 90 140
     $ likes_bones: logi [1:3] TRUE TRUE FALSE

I then display what is contained within the first object of the list,
breed.

Using the class function I can determine the type of data within the
list object, in this case, characters

``` r
dog_list[1]
```

    $breed
    [1] "Collie"   "Lab"      "ChowChow"

``` r
class(dog_list[[1]])
```

    [1] "character"

Using the doubled brace, (same syntax in accessing data frames) I can
call the information within the second list object, weight, and then use
class() to determine the data type, numeric.

``` r
dog_list[[2]]
```

    [1]  50  90 140

``` r
class(dog_list[[2]])
```

    [1] "numeric"

Because I assigned names to the list objects I can access them directly,
again, similarly to data frames

``` r
dog_list[1]
```

    $breed
    [1] "Collie"   "Lab"      "ChowChow"

``` r
# Using the list object name

dog_list$breed
```

    [1] "Collie"   "Lab"      "ChowChow"
