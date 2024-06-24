packages <- c("tidyr", "dplyr", "magrittr", "purrr", "ggplot2", 
               "lubridate", "plyr",
              "sp") 
invisible(lapply(packages, require, character.only = TRUE ))