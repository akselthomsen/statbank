
<!-- README.md is generated from README.Rmd. Please edit that file -->

# statbank

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/akselthomsen/statbank/branch/master/graph/badge.svg)](https://codecov.io/gh/akselthomsen/statbank?branch=master)
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
#> 
#> Attaching package: 'statbank'
#> The following object is masked from 'package:stats':
#> 
#>     filter
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
#> 1 846    2     100OV 5999   2020K2       0
#> 2 773    2     100OV 5999   2020K2       0
#> 3 840    2     100OV 5999   2020K2       0
#> 4 787    2     100OV 5999   2020K2       0
#> 5 820    2     100OV 5999   2020K2       0
#> 6 851    2     100OV 5999   2020K2       0
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
#>                 "665"
#>             ]
#>         },
#>         {
#>             "code": "KØN",
#>             "values": [
#>                 "2",
#>                 "TOT"
#>             ]
#>         },
#>         {
#>             "code": "ALDER",
#>             "values": [
#>                 "80-84",
#>                 "65-69",
#>                 "70-74"
#>             ]
#>         },
#>         {
#>             "code": "STATSB",
#>             "values": [
#>                 "5394"
#>             ]
#>         },
#>         {
#>             "code": "TID",
#>             "values": [
#>                 "2015K2",
#>                 "2015K1"
#>             ]
#>         }
#>     ]
#> }
#> 
#> # A tibble: 6 x 6
#>   OMRÅDE KØN   ALDER STATSB TID    INDHOLD
#>   <chr>  <chr> <chr> <chr>  <chr>    <dbl>
#> 1 665    2     80-84 5394   2015K2       0
#> 2 665    2     65-69 5394   2015K2       0
#> 3 665    2     70-74 5394   2015K2       0
#> 4 665    TOT   80-84 5394   2015K2       0
#> 5 665    TOT   65-69 5394   2015K2       0
#> 6 665    TOT   70-74 5394   2015K2       0
#> # A tibble: 0 x 6
#> # ... with 6 variables: OMRÅDE <chr>, KØN <chr>, ALDER <chr>, STATSB <chr>,
#> #   TID <chr>, INDHOLD <dbl>
```

``` r
tbl_dst(table_id = "FOLK1B", lang = "en") %>% 
  select(TID) %>% 
  filter(stringr::str_detect(TID, "K4")) %>% 
  collect()
#> # A tibble: 12 x 2
#>    TID    INDHOLD
#>    <chr>    <dbl>
#>  1 2008K4 5505995
#>  2 2009K4 5532531
#>  3 2010K4 5557709
#>  4 2011K4 5579204
#>  5 2012K4 5599665
#>  6 2013K4 5623501
#>  7 2014K4 5655750
#>  8 2015K4 5699220
#>  9 2016K4 5745526
#> 10 2017K4 5778570
#> 11 2018K4 5806015
#> 12 2019K4 5827463
```

``` r
x %>% 
  use_long_names()
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
