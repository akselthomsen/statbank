test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

x <- tbl_dst(table_id = "FOLK1B", lang = "en")

class(x)

x

# sloop::s3_dispatch(sample_n(x))
# sloop::s3_dispatch(print(x))

x %>%
  sample_n(8) %>%
  show_query() %>%
  collect()
