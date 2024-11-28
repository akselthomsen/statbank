
#' Test
#' @param name description
#' @param lang ass
#' @export

tbl_dst <- S7::new_class(
  name = "tbl_dst",
  properties = list(
    table_id = S7::new_property(
      class = S7::class_character,
      validator = \(value) validate_table_id(value)
      ),
    lang = S7::new_property(
      class = S7::class_character,
      validator = \(value) validate_lang(value),
      default = "en"
      ),
    metadata = S7::new_property(
      class = S7::class_list,
      getter = \(self) get_metadata(self@table_id, self@lang)
      )
  )
)

#' @noRd
validate_table_id <- function(value) {
  if (length(value) > 1) {
    return(cli::format_inline("Has to be of length {.val 1}"))
  }
  tables <- get_tables("en")[["id"]] |>
    toupper()
  if (!toupper(value) %in% tables) {
    return(cli::format_inline("Table {.val {value}} does not exist"))
  }
}

#' @noRd
validate_lang <- function(value) {
  lang <- c("en", "da")
  if (length(value) > 1) {
    return(cli::format_inline("Has to be of length {.val 1}"))
  }
  if (!value %in% lang) {
    return(cli::format_inline("Has to be one of {.val {lang}}"))
  }
}

