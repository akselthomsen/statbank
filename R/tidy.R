#################

meta_data <- get_meta_data("FOLK1B")

#################

names(meta_data)

x <- meta_data[["variables"]][["values"]]
x <- lapply(x, function(x) x[["id"]])
names(x) <- meta_data[["variables"]][["id"]]

attr(x, "table_lang") <- attr(meta_data, "table_lang")
attr(x, "table_id") <- meta_data[["id"]]
attr(x, "table_text") <- meta_data[["text"]]
attr(x, "table_unit") <- meta_data[["unit"]]

attributes(x)

x

#################

get_data(x, s = 555)
