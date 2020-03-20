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

  attr(x, "collect_rename") <- FALSE

  class(x) <- c("tbl_dst",class(x))

  return(x)
}

############################ extra manipulation



############################ s3methods

#' @export

collect.tbl_dst <- function(x, bulk = TRUE, ...){

  stopifnot(is.logical(bulk))

  y <- x %>%
    get_data(bulk = bulk) %>%
    read_dst_csv(x) %>%
    tibble::as_tibble()

  if(attr(x, "collect_rename")){
    names(y) <- toupper(c(attr(x, "var_text"), attr(x, "table_unit")))
  }

  return(y)
}

#' @export

show_query.tbl_dst <- function(x, prettify = TRUE, ...){

  stopifnot(is.logical(prettify))

  query <- create_data_query(x, bulk = TRUE)

  if (prettify){
    query <- jsonlite::prettify(query)
  }

  cat("JSON")
  cat("\n")
  cat(query)
  cat("\n")

  return(invisible(x))
}

#' @export

print.tbl_dst <- function(x, n = 6L, ...){

  stopifnot(n %% 1 == 0)

  x %>%
    head(n = n) %>%
    collect(bulk = FALSE) %>%
    print()

  return(invisible(x))
}

#' @export

head.tbl_dst <- function(x, n = 6L, ...){

  stopifnot(n %% 1 == 0)

  x[[1]] <- head(x[[1]],n)
  n_comb <- length(x[[1]])

  for (i in seq_along(x)[-1]){
    x[[i]] <- head(x[[i]], max(n %/% n_comb + as.numeric(n_comb < n),1))
    n_comb <- n_comb * length(x[[i]])
  }

  return(x)
}

#' @export

tail.tbl_dst <- function(x, n = 6L, ...){

  stopifnot(n %% 1 == 0)

  a <- attributes(x)

  x <- rev(x)

  x[[1]] <- tail(x[[1]],n)
  n_comb <- length(x[[1]])

  for (i in seq_along(x)[-1]){
    x[[i]] <- tail(x[[i]], max(n %/% n_comb + as.numeric(n_comb < n),1))
    n_comb <- n_comb * length(x[[i]])
  }

  x <- rev(x)
  attributes(x) <- a

  return(x)
}

############### to be improved

#' @export

sample_n.tbl_dst <- function(tbl, size, ...){

  stopifnot(size %% 1 == 0)

  n_comb_max <- prod(sapply(X = tbl, FUN = length))

  if (size >= n_comb_max){
    x <- tbl
  } else {

    x <- lapply(X = tbl, FUN = function(x) sample(x = x, size = 1))
    attributes(x) <- attributes(tbl)

    n_comb <- 1
    while(n_comb < size){
      i <- sample(x = seq_along(x), size = 1)
      j <- sample(x = seq_along(tbl[[i]]), size = 1)

      x[[i]] <- unique(c(x[[i]], tbl[[i]][[j]]))
      n_comb <- prod(sapply(X = x, FUN = length))
    }

  }

  return(x)
}
