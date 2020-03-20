test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

x <- tbl_dst(table_id = "FOLK1B", lang = "en")

attributes(x)

class(x)

x

x %>%
  head(6) %>%
  collect() %>%
  class()

head(x,200)

x %>%
  head(500) %>%
  collect(bulk = F)

x %>%
  tail(6) %>%
  show_query() %>%
  collect(bulk = F)

x %>%
  tail(2000) %>%
  collect(bulk = F)

x %>%
  sample_n(300) %>%
  collect(bulk = F)

attr(x,"collect_rename") <- TRUE
