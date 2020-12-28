
context("statbank")

x <- tbl_dst(table_id = "FOLK1B", lang = "en")

test_that(
  "simple methods",
  {
    expect_output(
      expect_invisible(
        print(x)
      )
    )
    expect_output(
      x %>%
        tail(6) %>%
        show_query()
    )
  }
)


test_that(
  "collect",
  {
    expect_true(
      x %>%
        head(6) %>%
        collect() %>%
        is.data.frame()
    )
    expect_visible(
      x %>%
        sample_n(50) %>%
        use_bulk_download() %>%
        collect()
    )
    expect_visible(
      x %>%
        tail(1) %>%
        collect()
    )
    expect_visible(
      x %>%
        head(10) %>%
        sample_n(1000) %>%
        collect()
    )
  }
)

test_that(
  "attributes",
  {
    expect_equal(
      x %>%
        class(),
      x %>%
        use_long_names() %>%
        select(CITIZENSHIP, TIME) %>%
        filter(CITIZENSHIP == "5100") %>%
        class()
    )
    expect_equal(
      x %>%
        attributes(),
      x %>%
        filter(STATSB == "0000") %>%
        attributes()
    )
  }
)

test_that(
  "manipulation",
  {
    expect_visible(
      x %>%
        filter(STATSB == "0000") %>%
        use_long_names() %>%
        use_labels() %>%
        filter(AGE == "Total") %>%
        use_labels(FALSE) %>%
        use_long_names(FALSE) %>%
        use_bulk_download() %>%
        sample_n(1000) %>%
        use_long_names() %>%
        collect()
    )
    expect_visible(
      x %>%
        use_long_names() %>%
        use_labels() %>%
        filter(REGION == "Frederiksberg") %>%
        select(REGION, TIME) %>%
        filter(TIME > "2016Q1") %>%
        collect()
    )
    expect_error(
      x %>%
        select(STATSB)
    )
    expect_error(
      x %>%
        select(-TID)
    )
  }
)
