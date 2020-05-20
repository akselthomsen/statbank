test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

x <- tbl_dst(table_id = "FOLK1B", lang = "en")

str(x)

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

x %>%
  sample_n(50) %>%
  use_bulk_download() %>%
  collect()

x

x %>%
  use_long_names() %>%
  select(CITIZENSHIP,TIME) %>%
  filter(CITIZENSHIP == "5100")

x %>%
  use_long_names(FALSE) %>%
  filter(STATSB == "0000")

x %>%
  use_long_names() %>%
  use_labels() %>%
  filter(REGION == "Frederiksberg") %>%
  select(REGION,TIME) %>%
  filter(TIME > "2016Q1") %>%
  collect()
