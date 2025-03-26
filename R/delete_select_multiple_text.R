#' Delete select_multiple column text
#'
#' @param df The KoboToolbox dataset
#' @param questionnaire The "survey" sheet of your KoboToolbox survey
#'
#' @returns The KoboToolbox dataset without the select_multiple columns
#' @export
#' @importFrom rlang .data
#'
#' @examples
#' \dontrun{
#' survey_without_select_multiple <- delete_select_multiple_text(survey,
#' questionnaire = kobo_questionnaire)
#' }
delete_select_multiple_text <- function(df, questionnaire){

  select_multiple_names <- questionnaire |>
    dplyr::filter(grepl("select_multiple", .data$type)) |>
    dplyr::pull(.data$name)

  final_df <- df |>
    dplyr::select(-dplyr::all_of(select_multiple_names))

  return(final_df)

}
