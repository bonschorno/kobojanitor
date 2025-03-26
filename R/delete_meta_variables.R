#' Delete meta variables
#'
#' @param df The KoboToolbox dataset
#' @param exceptions A regular expression to exclude variables from the selection
#'
#' @returns The KoboToolbox dataset without the meta variables
#' @export
#'
#' @examples
#' \dontrun{
#' survey_without_meta <- delete_meta_variables(df = survey)
#' }
delete_meta_variables <- function(df, exceptions = "gps|uuid|submission_time") {

  meta_variables_to_delete <- select_meta_variables(df, exceptions = exceptions)

  df <- df[, !(names(df) %in% meta_variables_to_delete)]

  return(df)

  }
