
# kobojanitor

<!-- badges: start -->

<!-- badges: end -->

The goal of kobojanitor is to make data cleaning downloaded from
[KoboToolbox](https://eu.kobotoolbox.org) easier. It provides functions
to select relevant/delete irrelevant meta data, select relevant variable
types (e.g., `multiple_select` or `decimal`), rename `multiple_select`
variables, and transform the XML codes for answer options to their
corresponding labels to make working with the data easier.

## Installation

You can install the development version of kobojanitor from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("bonschorno/kobojanitor")
```

## Examples

The data I’m fetching directly from the API is the raw data associated
with
[mwfertiliserpilot](%22https://github.com/Global-Health-Engineering/mwfertiliserpilot%22).
While the raw data itself isn’t published here because it contains
sensitive information, you can fetch the questionnaire fetched from the
repository’s documents folder. The questionnaire is then used to 1)
select relevant variables (from the “survey” sheet) and to transform the
XML codes to their corresponding labels (based on the “choices” sheet).

``` r
library(robotoolbox)
library(httr)
library(tidyverse)
library(kobojanitor)

# load raw Kobo data with robotoolbox's kobo_data function
raw_data <- kobo_data(x = "aWtRoDGQCbMFZ9nzQ5BFw7",
                      select_multiple_sep = "/")

# retrieve the questionnaire from the mwfertiliserpilot repository
response <- GET("https://github.com/Global-Health-Engineering/mwfertiliserpilot/raw/refs/heads/main/documents/fertilizer-management-pilot.xlsx")
temp_file <- tempfile(fileext = ".xlsx")
writeBin(content(response, "raw"), temp_file)


kobo_questionnaire <- readxl::read_excel(temp_file)

kobo_answer_options <- readxl::read_excel(temp_file, sheet = "choices") |> 
  filter(list_name != "enumerator") |>
  select(identifier = name,
         label = `label::English (en)`) |>
  drop_na() |>
  mutate(label = ifelse(label == "Other (specify)", "Other", label)) |>
  distinct(label, .keep_all = TRUE)
```

As of now, the package provides the following functions:

``` r
ls("package:kobojanitor")
#> [1] "delete_meta_variables"       "delete_select_multiple_text"
#> [3] "rename_multiple_select"      "select_meta_variables"      
#> [5] "select_relevant_variables"   "transform_xml_to_label"
```

### Select meta variables

``` r
meta_variables <- select_meta_variables(raw_data)

print(meta_variables)
#> [1] "_id"                "__version__"        "_xform_id_string"  
#> [4] "_status"            "_validation_status" "_submitted_by"     
#> [7] "_attachments"
```

### Select relevant variables by specifing their type (e.g., “integer”)

``` r
select_relevant_variables(questionnaire = kobo_questionnaire, variable_pattern = "integer|select_multiple")
#>  [1] "farmer_age"                    "own_livestock_animals"        
#>  [3] "price_bags_npk_nonsubsidized"  "price_bags_npk_subsidized"    
#>  [5] "price_bags_urea_nonsubsidized" "price_bags_urea_subsidized"   
#>  [7] "ratio_fertilizer_mix_npk"      "ratio_fertilizer_mix_urea"    
#>  [9] "ratio_fertilizer_mix_t1_npk"   "ratio_fertilizer_mix_t1_urea" 
#> [11] "ratio_fertilizer_mix_t2_npk"   "ratio_fertilizer_mix_t2_urea" 
#> [13] "wtp_scoop"                     "price_scoop"
```

## Pipeline

A nice feature of `kobojanitor` is that it allows you to chain functions
together to create a pipeline.

``` r
clean_data <- raw_data |> 
  delete_select_multiple_text(questionnaire = kobo_questionnaire) |> 
  rename_multiple_select(variable_name = "own_livestock_animals", group_separator = "/", replacement = ".") |> 
  transform_xml_to_label(dictionary = kobo_answer_options, exceptions = "own_livestock_animals")
#> The following multiple_select variables have been deleted: own_livestock_animals
```

``` r
# multiple select variables have been renamed
clean_data |> 
  select(contains("own_livestock_animals")) |> 
  names()
#> [1] "own_livestock_animals.cows"     "own_livestock_animals.chickens"
#> [3] "own_livestock_animals.pigs"     "own_livestock_animals.goats"   
#> [5] "own_livestock_animals.sheep"    "own_livestock_animals.other"
```

``` r
# before: XML codes
unique(as.vector(raw_data$tool_topdressing_fertilizer))
#> [1] "bottle_lining"    "bottle_no_lining" "other"            "teaspoon"        
#> [5] "hands"            "fertilizer_scoop" NA
```

``` r
# after: labels
unique(clean_data$tool_topdressing_fertilizer)
#> [1] "Metal bottle top with the lining (e.g., Fanta, Coca Cola, etc.)"   
#> [2] "Metal bottle top without the lining (e.g., Fanta, Coca Cola, etc.)"
#> [3] "Other"                                                             
#> [4] "Teaspoon"                                                          
#> [5] "Hands"                                                             
#> [6] "Recommended fertilizer cup (cup #5)"                               
#> [7] NA
```
