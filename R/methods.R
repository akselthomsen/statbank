
sample.dst <- function(x, size){
  y <- lapply(X = x, FUN = function(x) unique(sample(x, size = size, replace = TRUE)))
  attributes(y) <- attributes(x)
  return(y)
}

x

sample.dst(x = x, size = 2)
