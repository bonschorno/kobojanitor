#' Select meta variables
#'
#' @param df The KoboToolbox dataset
#' @param exceptions A regular expression to exclude variables from the selection
#'
#' @returns A character vector with the names of the meta variables
#' @export
#'
#' @examples
#' \dontrun{
#' meta_variables <- select_meta_variables(df = survey, exceptions = "uuid|submission_time")
#' }
select_meta_variables <- function(df, exceptions = "gps|uuid|submission_time") {
  meta_variables <- df |>
    dplyr::select(dplyr::starts_with("_"), -dplyr::matches(exceptions)) |>
    names()

  return(meta_variables)
}
