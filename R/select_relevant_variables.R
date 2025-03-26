#' Select relevant variables from your survey
#'
#' @param questionnaire The "survey" sheet of your KoboToolbox survey
#' @param variable_pattern A regular expression pattern to match the variable types you want to select
#'
#' @returns A character vector of the names of the variables that match the pattern
#' @export
#' @importFrom rlang .data
#'
#' @examples
#' \dontrun{
#' relevant_survey_variables <- select_relevant_variables(questionnaire = kobo_questionnaire)
#' }
select_relevant_variables <- function(questionnaire, variable_pattern = "^start$|^end$|today|select_one|select_multiple|integer|decimal|text") {

  relevant_variables <- questionnaire |>
    dplyr::filter(stringr::str_detect(string = .data$type, pattern = variable_pattern)) |>
    dplyr::select(.data$name) |>
    dplyr::pull()

  return(relevant_variables)
}
