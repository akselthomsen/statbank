
create_meta_query <- function(table_id, lang){

  opt = list("table" = table_id, "lang" = lang, "format" = "JSON")

  json <- jsonlite::toJSON(opt, auto_unbox = TRUE)

  return(json)
}

create_data_query <- function(x){

  v <- vector(mode = "list", length = length(x))
  for (i in seq_along(v)){
    v[[i]] <- list(
      "code" = jsonlite::unbox(names(x)[[i]]),
      "values" = x[[i]][[1]]
    )
  }

  if (attr(x, "collect_bulk")){
    f <- "BULK"
  } else {
    f <- "CSV"
  }

  opt <- list("table" = jsonlite::unbox(attr(x,"table_id")),
              "lang" = jsonlite::unbox(attr(x,"table_lang")),
              "format" = jsonlite::unbox(f),
              "delimiter" = jsonlite::unbox("Semicolon"),
              "ValuePresentation" = jsonlite::unbox("Code"),
              "variables" = v)

  json <- jsonlite::toJSON(opt, auto_unbox = FALSE)

  return(json)
}

get_query <- function(query,func){

  u <- paste0("https://api.statbank.dk/v1/",func)

  result <- httr::POST(url = u,
                       body = query,
                       encode = "raw",
                       httr::content_type_json())

  httr::stop_for_status(result)

  out <- httr::content(result, as = "text")

  return(out)
}
