% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/delete_meta_variables.R
\name{delete_meta_variables}
\alias{delete_meta_variables}
\title{Delete meta variables}
\usage{
delete_meta_variables(df, exceptions = "gps|uuid|submission_time")
}
\arguments{
\item{df}{The KoboToolbox dataset}

\item{exceptions}{A regular expression to exclude variables from the selection}
}
\value{
The KoboToolbox dataset without the meta variables
}
\description{
Delete meta variables
}
\examples{
\dontrun{
survey_without_meta <- delete_meta_variables(df = survey)
}
}
