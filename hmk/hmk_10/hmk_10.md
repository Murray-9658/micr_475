Homework 10: Decisions and loops
================
Murray Stokes

``` r
library(tidyverse)
```

# Decisions

Write a function that accepts the current time as a parameter and prints
“Good morning”, “Good afternoon”, or “Good evening” depending on the
time. It is fine for the time to be in numeric format (e.g., `2317` for
11:17 pm). Bonus points if the function accepts time objects (see the
`lubridate` package).

``` r
what.greeting <- function(x) {
  if(x >= 0 & x < 1200) {
    print("Good morning")
  } else if(x >= 1200 & x < 1700) {
    print("Good afternoon")
  }  else if (x >= 1700 & x < 2400) {
    print("Good evening")
  } else {
    print("Please make sure to enter time in 24-hr syntax ie. 1350. If you would like to input values other than time in the 24-hr format, don't.")
  }
}
```

``` r
what.greeting(1300)
```

    [1] "Good afternoon"

A few questions to consider:

-   What is a logical name for this function? What is a logical name for
    the parameter it accepts?

    Function name: `what.greeting`

    Accepted Parameter: `24hr_time`

-   The purpose of this function is to print a message to the console,
    so its primary purpose is a **side effect**. However, all functions
    must return something. What would be a logical value for this
    function to return?

    A logical value returned by this function would be either `TRUE` or
    `FALSE` which indicate whether the time has been returned as the
    appropriate greeting. `False` would be if the function was unable to
    return the proper greeting.

-   Should the function have default behavior in case the user does not
    pass an argument?

    Yes, I included a fallback message to tell the user to supply the
    time parameter in the 24hr format. This is accomplished using a
    final `else` statement.

-   What would you like to happen if this function is passed the wrong
    data type (e.g., a negative number)?

    Using the aforementioned final `else` statement I made sure that
    inputs not in the 24hr clock format will result in a message
    indicating what the user should do.

    ``` r
    what.greeting(-1400)
    ```

        [1] "Please make sure to enter time in 24-hr syntax ie. 1350. If you would like to input values other than time in the 24-hr format, don't."

# Loops

-   Write a `for` loops that calculates the mean of each column of
    mtcars

    ``` r
    # I preset the length of the output vector using `ncol` to determine the number of columns.

    mean_of_each_mtcars_column <- vector("double", ncol(mtcars))  

    # I use `seq_along` to prevent zero length vectors
    for (i in seq_along(mtcars)) {            
      mean_of_each_mtcars_column[[i]] <- mean(mtcars[[i]])      
    }
    ```

-   Write a function (using a for loop) that calculates the mean of all
    numeric columns of *any* data frame. This function should be able to
    accept data frames with non-numeric columns.

    ``` r
    diamonds <- diamonds

    mean_of_numeric_columns <- function(df) {

    # selecting for numeric columns from the df  
    df_filt <- select(df, is.numeric)

    mean_of_col <- vector("double", ncol(df_filt))  
    for (i in seq_along(df_filt)) {
      mean_of_col[[i]] <- mean(df_filt[[i]])
    } 
    mean_of_col
    }

    mean_of_numeric_columns(diamonds)
    ```

        Warning: Predicate functions must be wrapped in `where()`.

          # Bad
          data %>% select(is.numeric)

          # Good
          data %>% select(where(is.numeric))

        ℹ Please update your code.
        This message is displayed once per session.

        [1]    0.7979397   61.7494049   57.4571839 3932.7997219    5.7311572
        [6]    5.7345260    3.5387338

## Why not loops

In R, we generally encourage people to use vectorized functions instead
of `for` loops. According to [your
textbook](https://r4ds.had.co.nz/iteration.html), what is better about
vectorized functions?

Vectorized functions are better because they reduce duplication of code
(and thus its length) which reduces proneness of errors. A key advantage
of vectorized functions is the ability to generalize your code to work,
so you are spending less time rewriting code to fit for certain data
frames.