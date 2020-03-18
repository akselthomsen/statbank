test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

x <- tbl_dst(table_id = "FOLK1B", lang = "en")

class(x)

x

(y <- sample.tbl_dst(x, 2))

x <- y

x %>%
  get_data(bulk = FALSE)

x %>%
  get_data(bulk = TRUE)

x %>%
  show_query.tbl_dst(prettify = T) %>%
  get_data()

y <- print.tbl_dst(x)

df <- x %>%
  get_data()
