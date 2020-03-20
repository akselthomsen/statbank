
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
#> # A tibble: 6 x 6
#>   OMRÅDE KØN   ALDER STATSB TID    INDHOLD
#>   <chr>  <chr> <chr> <chr>  <chr>    <dbl>
#> 1 000    TOT   IALT  0000   2008K1 5475791
#> 2 084    TOT   IALT  0000   2008K1 1645825
#> 3 101    TOT   IALT  0000   2008K1  509861
#> 4 147    TOT   IALT  0000   2008K1   93444
#> 5 155    TOT   IALT  0000   2008K1   13261
#> 6 185    TOT   IALT  0000   2008K1   40016

x %>% head()
#> # A tibble: 6 x 6
#>   OMRÅDE KØN   ALDER STATSB TID    INDHOLD
#>   <chr>  <chr> <chr> <chr>  <chr>    <dbl>
#> 1 000    TOT   IALT  0000   2008K1 5475791
#> 2 084    TOT   IALT  0000   2008K1 1645825
#> 3 101    TOT   IALT  0000   2008K1  509861
#> 4 147    TOT   IALT  0000   2008K1   93444
#> 5 155    TOT   IALT  0000   2008K1   13261
#> 6 185    TOT   IALT  0000   2008K1   40016
x %>% tail()
#> # A tibble: 6 x 6
#>   OMRÅDE KØN   ALDER STATSB TID    INDHOLD
#>   <chr>  <chr> <chr> <chr>  <chr>    <dbl>
#> 1 851    2     100OV 5999   2018K4       0
#> 2 851    2     100OV 5999   2019K1       0
#> 3 851    2     100OV 5999   2019K2       0
#> 4 851    2     100OV 5999   2019K3       0
#> 5 851    2     100OV 5999   2019K4       0
#> 6 851    2     100OV 5999   2020K1       0

x %>%
  sample_n(8) %>%
  show_query() %>%
  collect(bulk = FALSE)
#> JSON
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
#>                 "336"
#>             ]
#>         },
#>         {
#>             "code": "KØN",
#>             "values": [
#>                 "TOT",
#>                 "1"
#>             ]
#>         },
#>         {
#>             "code": "ALDER",
#>             "values": [
#>                 "40-44",
#>                 "0-4"
#>             ]
#>         },
#>         {
#>             "code": "STATSB",
#>             "values": [
#>                 "5130",
#>                 "5129"
#>             ]
#>         },
#>         {
#>             "code": "TID",
#>             "values": [
#>                 "2011K2"
#>             ]
#>         }
#>     ]
#> }
#> # A tibble: 8 x 6
#>   OMRÅDE KØN   ALDER STATSB TID    INDHOLD
#>   <chr>  <chr> <chr> <chr>  <chr>    <dbl>
#> 1 336    TOT   40-44 5130   2011K2       0
#> 2 336    TOT   40-44 5129   2011K2       0
#> 3 336    TOT   0-4   5130   2011K2       0
#> 4 336    TOT   0-4   5129   2011K2       0
#> 5 336    1     40-44 5130   2011K2       0
#> 6 336    1     40-44 5129   2011K2       0
#> 7 336    1     0-4   5130   2011K2       0
#> 8 336    1     0-4   5129   2011K2       0
```
