#' Transform Kobo's XML codes to its corresponding labels
#'
#' @param df The KoboToolbox dataset
#' @param dictionary The dictionary ("choices" sheet of your KoboToolbox questionnaire) that maps the XML codes to the labels
#' @param exceptions The columns that should not be transformed (usually the multiple_select columns)
#'
#' @returns The KoboToolbox dataset with the XML codes transformed to the labels
#' @export
#'
#' @examples
#' \dontrun{
#' survey_with_labels <- transform_xml_to_label(survey,
#' dictionary = kobo_choices,
#' exceptions = c("type_food", "water_source"))
#' }
transform_xml_to_label <- function(df, dictionary, exceptions) {

  names_vec <- names(df)

  names_vec_updated <- names_vec[! names_vec %in% exceptions]

  for (col in names_vec_updated) {

    if (is.character(df[[col]])) {

      matched_indices <- match(df[[col]], dictionary$identifier)

      new_values <- dictionary$label[matched_indices]

      df[[col]] <- ifelse(is.na(new_values), df[[col]], new_values)
    }
  }
  return(df)
}
