
read_dst_csv <- function(text, x){

  d <- switch(attr(x, "table_lang"),
              "en" = ".",
              "da" = ",")

  cc <- c(rep("character", 5),"numeric")

  out <- data.table::fread(text = text,
                    encoding = "UTF-8", sep = ";", dec = d,
                    colClasses = cc)

  return(out)
}
