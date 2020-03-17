
get_meta_data <- function(table, lang = "en"){

  stopifnot(lang %in% c("da","en"))

  opt = list(table = table, lang = lang, format = "JSON")

  result <- httr::POST(url = "https://api.statbank.dk/v1/tableinfo",
                       body = opt,
                       encode = "json",
                       format = "json")

  httr::stop_for_status(result)

  meta <- httr::content(result) %>%
    jsonlite::fromJSON()

  attr(meta, "table_lang") <- lang

  return(meta)
}

#################

get_data <- function(x, format = "BULK"){

  v <- vector(mode = "list", length = length(x))
  for (i in seq_along(v)){
    v[[i]] <- list(
      "code" = names(x)[[i]],
      "values" = x[[i]]
    )
  }

  opt <- list(table = attr(x,"table_id"),
              lang = attr(x,"table_lang"),
              format = format,
              delimiter = "Semicolon",
              ValuePresentation = "Code",
              variables = v)

  result <- httr::POST(url = "https://api.statbank.dk/v1/data",
                       body = opt,
                       encode = "json",
                       format = "BULK")

  httr::stop_for_status(result)

  out <- httr::content(result, as = "text") %>%
    read.csv2(text = ., stringsAsFactors = FALSE) %>%
    dplyr::as_tibble()

  return(out)
}
