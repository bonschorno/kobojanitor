#' Rename multiple_select columns
#'
#' @param df The KoboToolbox dataset
#' @param variable_name The name of the variable that has multiple_select columns
#' @param group_separator The character (usually, "/" or "_") that separates the answer option and the group name
#' @param replacement The character that will replace the group_separator
#'
#' @returns The KoboToolbox dataset with the multiple_select answer options of the corresponding variable renamed
#' @export
#'
#' @examples
#' \dontrun{
#' survey <- rename_multiple_select(survey,
#' variable_name = "type_food",
#' group_separator = "/",
#' replacement = ".")
#' }
rename_multiple_select <- function(df, variable_name, group_separator = "/", replacement = "."){

  cols_of_interest <- grep(paste0(variable_name, group_separator), colnames(df), value = TRUE)
  new_colnames <- sub(group_separator, ".", cols_of_interest, perl = TRUE)
  colnames(df)[colnames(df) %in% cols_of_interest] <- new_colnames
  return(df)
}
