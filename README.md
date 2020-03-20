
<!-- README.md is generated from README.Rmd. Please edit that file -->

# statbank

<!-- badges: start -->

<!-- badges: end -->

The goal of statbank is to …

## Installation

You can install the released version of statbank from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("statbank")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("akselthomsen/statbank")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(statbank)
## basic example code

x <- tbl_dst(table_id = "FOLK1B", lang = "en")

class(x)
#> [1] "tbl_dst" "list"

x
#> # A tibble: 1,800 x 6
#>    OMRÅDE KØN   ALDER STATSB TID    INDHOLD
#>    <chr>  <chr> <chr> <chr>  <chr>    <dbl>
#>  1 479    1     5-9   5348   2011K3       0
#>  2 479    1     5-9   5348   2012K3       0
#>  3 479    1     5-9   5348   2016K1       0
#>  4 479    1     5-9   5348   2017K3       0
#>  5 479    1     5-9   5348   2018K4       0
#>  6 479    1     5-9   5111   2011K3       0
#>  7 479    1     5-9   5111   2012K3       0
#>  8 479    1     5-9   5111   2016K1       0
#>  9 479    1     5-9   5111   2017K3       0
#> 10 479    1     5-9   5111   2018K4       0
#> # ... with 1,790 more rows

x %>%
  sample_n(8) %>%
  show_query() %>%
  collect()
#> {
#>     "table": "FOLK1B",
#>     "lang": "en",
#>     "format": "BULK",
#>     "delimiter": "Semicolon",
#>     "ValuePresentation": "Code",
#>     "variables": [
#>         {
#>             "code": "OMRÅDE",
#>             "values": [
#>                 "376",
#>                 "083",
#>                 "661",
#>                 "390",
#>                 "746",
#>                 "492",
#>                 "163"
#>             ]
#>         },
#>         {
#>             "code": "KØN",
#>             "values": [
#>                 "TOT",
#>                 "2"
#>             ]
#>         },
#>         {
#>             "code": "ALDER",
#>             "values": [
#>                 "95-99",
#>                 "25-29",
#>                 "70-74",
#>                 "40-44",
#>                 "45-49",
#>                 "100OV"
#>             ]
#>         },
#>         {
#>             "code": "STATSB",
#>             "values": [
#>                 "5759",
#>                 "5462",
#>                 "5319",
#>                 "5204",
#>                 "5322",
#>                 "5434",
#>                 "5215",
#>                 "5716"
#>             ]
#>         },
#>         {
#>             "code": "TID",
#>             "values": [
#>                 "2018K4",
#>                 "2015K2",
#>                 "2019K4",
#>                 "2013K3",
#>                 "2009K1",
#>                 "2010K2",
#>                 "2011K3"
#>             ]
#>         }
#>     ]
#> }
#> # A tibble: 255 x 6
#>    OMRÅDE KØN   ALDER STATSB TID    INDHOLD
#>    <chr>  <chr> <chr> <chr>  <chr>    <dbl>
#>  1 083    2     25-29 5434   2009K1       4
#>  2 083    2     40-44 5434   2009K1       3
#>  3 083    2     40-44 5716   2009K1       1
#>  4 083    2     45-49 5434   2009K1       3
#>  5 083    TOT   25-29 5322   2009K1       2
#>  6 083    TOT   25-29 5434   2009K1      11
#>  7 083    TOT   25-29 5716   2009K1       1
#>  8 083    TOT   25-29 5759   2009K1       1
#>  9 083    TOT   40-44 5434   2009K1       7
#> 10 083    TOT   40-44 5716   2009K1       1
#> # ... with 245 more rows
```
