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
#' @export

tbl_dst <- function(table_id, lang = "en") {
  stopifnot(is.character(table_id) && length(table_id) == 1)
  stopifnot(is.character(lang) && length(lang) == 1 && lang %in% c("da", "en"))

  meta_data <- create_meta_query(table_id = table_id, lang = lang) %>%
    get_query(func = "tableinfo") %>%
    jsonlite::fromJSON()

  x <- meta_data[["variables"]][["values"]]
  names(x) <- toupper(meta_data[["variables"]][["id"]])

  attr(x, "table_lang") <- lang
  attr(x, "table_id") <- meta_data[["id"]]
  attr(x, "table_text") <- meta_data[["text"]]
  attr(x, "table_unit") <- meta_data[["unit"]]

  attr(x, "var_text") <- toupper(meta_data[["variables"]][["text"]])
  attr(x, "var_time") <- toupper(meta_data[["variables"]][["time"]])
  attr(x, "var_elimination") <- meta_data[["variables"]][["elimination"]]

  attr(x, "collect_bulk") <- FALSE

  attr(x, "collect_rename") <- FALSE
  attr(x, "collect_recode") <- FALSE

  attr(x, "collect_head") <- FALSE
  attr(x, "collect_tail") <- FALSE
  attr(x, "collect_sample") <- FALSE

  class(x) <- c("tbl_dst", class(x))

  return(x)
}

############################ internal

#' is.tbl_dst
#'
#' \code{is.tbl_dst} renames to pretty names
#'
#' @param x [tbl_dst] output.
#' @return [logical] TRUE/FALSE.
#' @examples
#'
#' \dontrun{
#' use_names(x)
#' }
#'
is.tbl_dst <- function(x) {
  return(class(x)[[1]] == "tbl_dst")
}

############################ extra manipulation

#' Rename
#'
#' \code{use_long_names} renames to pretty names
#'
#' @param x [tbl_dst] output.
#' @param value [logical] TRUE/FALSE
#' @return a [tbl_dst] object.
#' @examples
#'
#' \dontrun{
#' use_names(x)
#' }
#' @export

use_long_names <- function(x, value = TRUE) {
  stopifnot(is.tbl_dst(x))
  stopifnot(is.logical(value))

  attr(x, "collect_rename") <- value

  return(x)
}

#' Encode with labels
#'
#' \code{use_names} renames to pretty names
#'
#' @param x [tbl_dst] output.
#' @param value [logical] TRUE/FALSE
#' @return a [tbl_dst] object.
#' @export

use_labels <- function(x, value = TRUE) {
  stopifnot(is.tbl_dst(x))
  stopifnot(is.logical(value))

  attr(x, "collect_recode") <- value

  return(x)
}

#' Bulk download
#'
#' \code{use_names} renames to pretty names
#'
#' @param x [tbl_dst] output.
#' @param bulk [logical] output.
#' @return a [tbl_dst] object.
#' @export

use_bulk_download <- function(x, bulk = TRUE) {
  stopifnot(is.tbl_dst(x))
  stopifnot(is.logical(bulk))

  attr(x, "collect_bulk") <- bulk

  return(x)
}

############################ s3methods - dplyr

#' @export

collect.tbl_dst <- function(x, ...) {
  df <- x %>%
    create_data_query() %>%
    get_query(func = "data") %>%
    read_dst_csv(x) %>%
    tibble::as_tibble()

  if (attr(x, "collect_recode")) {
    for (i in seq_along(x)) {
      df[[i]] <- x[[i]][["text"]][match(df[[i]], x[[i]][["id"]])]
    }
  }
  if (attr(x, "collect_rename")) {
    names(df) <- toupper(c(attr(x, "var_text"), attr(x, "table_unit")))
  }
  if (attr(x, "collect_head")) {
    df <- head(df, n = attr(x, "collect_head"))
  }
  if (attr(x, "collect_tail")) {
    df <- tail(df, n = attr(x, "collect_tail"))
  }
  if (attr(x, "collect_sample") & attr(x, "collect_sample") < nrow(df)) {
    df <- dplyr::sample_n(df, size = attr(x, "collect_sample"))
  }

  return(df)
}

#' @export

show_query.tbl_dst <- function(x, prettify = TRUE, ...) {
  stopifnot(is.logical(prettify))

  query <- create_data_query(x)

  if (prettify) {
    query <- jsonlite::prettify(query)
  }

  cat("<JSON>")
  cat("\n")
  cat(query)
  cat("\n")

  return(invisible(x))
}

#' @export

select.tbl_dst <- function(.data, ...) {
  a <- attributes(.data)

  names_used <- a[["names"]]
  if (a[["collect_rename"]]) {
    names_used <- a[["var_text"]]
  }

  df <- data.frame(matrix(nrow = 0, ncol = length(.data)))
  names(df) <- names_used

  df <- dplyr::select(df, ...)
  v <- match(names(df), names_used)

  if (any(!a[["var_elimination"]][-v])) {
    ve <- which(!a[["var_elimination"]][-v])
    e <- paste("Variable(s)", paste(names_used[-v][ve], collapse = ", "), "can not be deselected")
    stop(e)
  }

  a[["names"]] <- a[["names"]][v]
  a[["var_text"]] <- a[["var_text"]][v]
  a[["var_time"]] <- a[["var_time"]][v]
  a[["var_elimination"]] <- a[["var_elimination"]][v]

  out <- .data[v]
  attributes(out) <- a

  return(out)
}

#' @export

filter.tbl_dst <- function(.data, ...) {
  dots <- rlang::enquos(...)

  names_used <- names(.data)
  if (attr(.data, "collect_rename")) {
    names_used <- attr(.data, "var_text")
  }

  v1 <- lapply(X = dots, FUN = all.vars) %>%
    lapply(intersect, y = names_used)

  if(any(unlist(lapply(v1, length)) != 1)){
    stop("Each filter can only use one variable from the API")
  }

  v1 <- unlist(v1)

  v2 <- match(v1, names_used)

  filter_var <- ifelse(attr(.data, "collect_recode"), "text", "id")

  for (i in seq_along(dots)) {
    .data[[v2[[i]]]] <- .data[[v2[[i]]]] %>%
      dplyr::mutate(!!v1[[i]] := .data[[filter_var]]) %>%
      dplyr::filter(!!rlang::quo_squash(dots[[i]])) %>%
      dplyr::select(-!!v1[[i]])
  }

  return(.data)
}

#' @export

sample_n.tbl_dst <- function(tbl, size, ...) {
  stopifnot(size %% 1 == 0)

  n_comb_max <- prod(sapply(X = tbl, FUN = nrow))

  if (size >= n_comb_max) {
    x <- tbl
  } else {
    x <- lapply(X = tbl, FUN = function(x) dplyr::sample_n(tbl = x, size = 1))
    attributes(x) <- attributes(tbl)

    n_comb <- 1
    while (n_comb < size) {
      i <- sample(x = seq_along(tbl), size = 1)

      x[[i]] <- dplyr::bind_rows(
        x[[i]],
        dplyr::sample_n(tbl = tbl[[i]], size = 1)
      ) %>%
        dplyr::distinct()

      n_comb <- prod(sapply(X = x, FUN = nrow))
    }
  }

  attr(x, "collect_sample") <- size

  return(x)
}

############################ s3methods - base/utils

#' @export

print.tbl_dst <- function(x, n = 6L, ...) {
  stopifnot(n %% 1 == 0)

  x %>%
    head(n = n) %>%
    collect() %>%
    print()

  return(invisible(x))
}

#' @export

head.tbl_dst <- function(x, n = 6L, ...) {
  stopifnot(n %% 1 == 0)

  x[[1]] <- head(x[[1]], n)
  n_comb <- nrow(x[[1]])

  for (i in seq_along(x)[-1]) {
    x[[i]] <- head(x[[i]], max(n %/% n_comb + as.numeric(n_comb < n), 1))
    n_comb <- n_comb * nrow(x[[i]])
  }

  attr(x, "collect_head") <- n

  return(x)
}

#' @export

tail.tbl_dst <- function(x, n = 6L, ...) {
  stopifnot(n %% 1 == 0)

  x[[1]] <- tail(x[[1]], n)
  n_comb <- nrow(x[[1]])

  for (i in seq_along(x)[-1]) {
    x[[i]] <- tail(x[[i]], max(n %/% n_comb + as.numeric(n_comb < n), 1))
    n_comb <- n_comb * nrow(x[[i]])
  }

  attr(x, "collect_tail") <- n

  return(x)
}
