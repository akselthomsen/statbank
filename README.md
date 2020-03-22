
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
# install.packages("remotes")
remotes::install_github("akselthomsen/statbank")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(statbank)
## basic example code

x <- tbl_dst(table_id = "FOLK1B", lang = "en")

class(x)
#> [1] "tbl_dst" "list"
```

``` r
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
```

``` r
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
```

``` r
x %>%
  sample_n(8) %>%
  show_query() %>%
  print() %>% 
  use_bulk_download()
#> <JSON>
#> {
#>     "table": "FOLK1B",
#>     "lang": "en",
#>     "format": "CSV",
#>     "delimiter": "Semicolon",
#>     "ValuePresentation": "Code",
#>     "variables": [
#>         {
#>             "code": "OMRÅDE",
#>             "values": [
#>                 "420",
#>                 "440"
#>             ]
#>         },
#>         {
#>             "code": "KØN",
#>             "values": [
#>                 "1"
#>             ]
#>         },
#>         {
#>             "code": "ALDER",
#>             "values": [
#>                 "90-94",
#>                 "10-14"
#>             ]
#>         },
#>         {
#>             "code": "STATSB",
#>             "values": [
#>                 "5356"
#>             ]
#>         },
#>         {
#>             "code": "TID",
#>             "values": [
#>                 "2009K1",
#>                 "2014K4"
#>             ]
#>         }
#>     ]
#> }
#> 
#> # A tibble: 6 x 6
#>   OMRÅDE KØN   ALDER STATSB TID    INDHOLD
#>   <chr>  <chr> <chr> <chr>  <chr>    <dbl>
#> 1 420    1     90-94 5356   2009K1       0
#> 2 420    1     90-94 5356   2014K4       0
#> 3 420    1     10-14 5356   2009K1       0
#> 4 420    1     10-14 5356   2014K4       0
#> 5 440    1     90-94 5356   2009K1       0
#> 6 440    1     90-94 5356   2014K4       0
#> # A tibble: 0 x 6
#> # ... with 6 variables: OMRÅDE <chr>, KØN <chr>, ALDER <chr>, STATSB <chr>,
#> #   TID <chr>, INDHOLD <dbl>
```

``` r
x %>% 
  use_names()
#> # A tibble: 6 x 6
#>   REGION SEX   AGE   CITIZENSHIP TIME    NUMBER
#>   <chr>  <chr> <chr> <chr>       <chr>    <dbl>
#> 1 000    TOT   IALT  0000        2008K1 5475791
#> 2 084    TOT   IALT  0000        2008K1 1645825
#> 3 101    TOT   IALT  0000        2008K1  509861
#> 4 147    TOT   IALT  0000        2008K1   93444
#> 5 155    TOT   IALT  0000        2008K1   13261
#> 6 185    TOT   IALT  0000        2008K1   40016
```
