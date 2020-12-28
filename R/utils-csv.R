
read_dst_csv <- function(text, x) {
  d <- switch(attr(x, "table_lang"),
    "en" = ".",
    "da" = ","
  )

  cc <- c(rep("character", length(x)), "numeric")

  out <- data.table::fread(
    text = text,
    na.strings = "..",
    encoding = "UTF-8", sep = ";", dec = d,
    colClasses = cc
  )

  return(out)
}
