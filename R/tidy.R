
tbl_dst <- function(table_id, lang = "en"){

  stopifnot(is.character(table_id) && length(table_id) == 1)
  stopifnot(is.character(lang) && length(lang) == 1 && lang %in% c("da","en"))

  meta_data <- get_meta_data(table_id = table_id, lang = lang)

  x <- meta_data[["variables"]][["values"]]
  x <- lapply(x, function(x) x[["id"]])
  names(x) <- meta_data[["variables"]][["id"]]

  attr(x, "table_lang") <- lang
  attr(x, "table_id") <- meta_data[["id"]]
  attr(x, "table_text") <- meta_data[["text"]]
  attr(x, "table_unit") <- meta_data[["unit"]]

  class(x) <- "tbl_dst"

  return(x)
}
