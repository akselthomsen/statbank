#' Connect to table from statbank.dk
#'
#' \code{tbl_dst} gather all relevant metadata for the chosen table and returns an object,
#' that can be easily manipulated with known dplyr verbs.
#'
#' Verbs currently supported.....
#'
#' @param table_id [character] Name of table from statbank.dk
#' @param lang [character] Desired language of output. Possibilites are danish ("da") and english ("en").
#' Default is "en.
#' @return a [tbl_dst] object.
#' @examples
#'
#' \dontrun{
#' sum("a")
#' }
#' @exportClass tbl_dst
#' @export

tbl_dst <- function(table_id, lang = "en"){

  stopifnot(is.character(table_id) && length(table_id) == 1)
  stopifnot(is.character(lang) && length(lang) == 1 && lang %in% c("da","en"))

  meta_data <- get_meta_data(table_id = table_id, lang = lang)

  x <- meta_data[["variables"]][["values"]]
  x <- lapply(x, function(x) x[["id"]])
  names(x) <- toupper(meta_data[["variables"]][["id"]])

  attr(x, "table_lang") <- lang
  attr(x, "table_id") <- meta_data[["id"]]
  attr(x, "table_text") <- meta_data[["text"]]
  attr(x, "table_unit") <- meta_data[["unit"]]

  attr(x, "var_text") <- meta_data[["variables"]][["text"]]
  attr(x, "var_time") <- meta_data[["variables"]][["time"]]

  class(x) <- c("tbl_dst",class(x))

  return(x)
}

############################ done

#' @export

collect.tbl_dst <- function(x, bulk = TRUE, ...){

  stopifnot(is.logical(bulk))

  y <- x %>%
    get_data(bulk = bulk) %>%
    read_dst_csv(x) %>%
    tibble::as_tibble()

  return(y)
}

#' @export

show_query.tbl_dst <- function(x, prettify = TRUE, ...){

  stopifnot(is.logical(prettify))

  query <- create_data_query(x, bulk = TRUE)

  if (prettify){
    query <- jsonlite::prettify(query)
  }

  cat(query)
  cat("\n")

  return(invisible(x))
}

#' @export

print.tbl_dst <- function(x, n = 6L, ...){

  stopifnot(n %% 1 == 0)

  x %>%
    sample_n(size = n) %>%
    collect(bulk = FALSE) %>%
    print()

  return(invisible(x))
}

############### to be improved

#' @export

sample_n.tbl_dst <- function(tbl, size, ...){

  stopifnot(size %% 1 == 0)

  y <- lapply(X = tbl, FUN = function(x) unique(sample(x, size = size, replace = TRUE)))
  attributes(y) <- attributes(tbl)

  return(y)
}

#' @export

head.tbl_dst <- function(x, n = 6L, ...){

}

#' @export

tail.tbl_dst <- function(x, n = 6L, ...){}
