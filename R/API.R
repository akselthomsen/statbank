
create_meta_query <- function(table_id, lang){

  opt = list("table" = table_id, "lang" = lang, "format" = "JSON")

  json <- jsonlite::toJSON(opt, auto_unbox = TRUE)

  return(json)
}

get_meta_data <- function(table_id, lang){

  query <- create_meta_query(table_id = table_id, lang = lang)

  result <- httr::POST(url = "https://api.statbank.dk/v1/tableinfo",
                       body = query,
                       encode = "raw",
                       httr::content_type_json())

  httr::stop_for_status(result)

  meta <- httr::content(result) %>%
    jsonlite::fromJSON()

  return(meta)
}

create_data_query <- function(x, bulk){

  v <- vector(mode = "list", length = length(x))
  for (i in seq_along(v)){
    v[[i]] <- list(
      "code" = names(x)[[i]],
      "values" = I(x[[i]])
    )
  }

  if (bulk){
    f <- "BULK"
  } else {
    f <- "CSV"
  }

  opt <- list("table" = attr(x,"table_id"),
              "lang" = attr(x,"table_lang"),
              "format" = f,
              "delimiter" = "Semicolon",
              "ValuePresentation" = "Code",
              "variables" = v)

  json <- jsonlite::toJSON(opt, auto_unbox = TRUE)

  return(json)
}

get_data <- function(x, bulk){

  query <- create_data_query(x = x, bulk = bulk)

  result <- httr::POST(url = "https://api.statbank.dk/v1/data",
                       body = query,
                       encode = "raw",
                       httr::content_type_json())

  httr::stop_for_status(result)

  out <- httr::content(result, as = "text")

  return(out)
}
