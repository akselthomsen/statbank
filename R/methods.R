

sample.tbl_dst <- function(x, size){
  y <- lapply(X = x, FUN = function(x) unique(sample(x, size = size, replace = TRUE)))
  attributes(y) <- attributes(x)
  return(y)
}

show_query.tbl_dst <- function(x, prettify = TRUE){

  query <- create_query(x, bulk = TRUE)

  if (prettify){
    query <- jsonlite::prettify(query)
  }

  cat(query)
  cat("\n")

  return(invisible(x))
}

print.tbl_dst <- function(x, n = 6){

  x <- sample.tbl_dst(x = x, size = n)

  d <- get_data(x = x, bulk = FALSE)

  print(d)

  return(invisible(x))

}
