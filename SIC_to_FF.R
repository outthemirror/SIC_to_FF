library(tidyverse)

# Download the data from Ken French Website
link <- "http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/Industry_Definitions.zip"
file <- tempfile() 
download.file(link, file) 
file_unzipped <- unzip(file)

#update ff_export with industry and SIC information
update_ff_export <- function(ind_number, ind_abbrev, ind_desc, SIC_code_low, SIC_code_high, SIC_desc){
  tibble(ind_number = ind_number, ind_abbrev = ind_abbrev, ind_desc = ind_desc,
         SIC_code_low = SIC_code_low, SIC_code_high = SIC_code_high, SIC_desc = SIC_desc)
}

#The main function to covert SIC to FF industry classification.
SIC_to_FF <- function(ff_file){
  ff_ind <- read_delim(ff_file, delim = "/n ", col_names = F)
  ff_export <- tibble()
  for (i in 1:nrow(ff_ind)){
    data_point = ff_ind$X1[i]
    n_match <- str_count(data_point, "\\d{1,4}")
    if (n_match == 1) {#Extract industry id, addreviation, description.
      temp <- str_split(data_point, "\\s{2,}")
      ind_desc <- temp[[1]][2]
      ind_number_abbrev <- temp[[1]][1]
      ind_number <-as.integer(str_extract(ind_number_abbrev, "\\d+\\s"))
      ind_abbrev <-str_extract(ind_number_abbrev, "[A-Z]+.*$")
      if (ind_abbrev == "Other" & i ==nrow(ff_ind)){#Deal with "Other" classification without SIC codes such as FF5
        ff_export <- bind_rows(ff_export, update_ff_export(ind_number, ind_abbrev, ind_desc, 
                                                           NA, NA, NA))
      }
     
    }
    if (n_match == 2) { #Extract SIC information.
      SIC_codes <- str_extract(data_point, "\\d{4}-\\d{4}")
      SIC_code_low <- as.integer(unlist(str_split(SIC_codes, "-"))[1])
      SIC_code_high <-as.integer(unlist(str_split(SIC_codes, "-"))[2])
      SIC_desc <- str_extract(data_point, "[A-Z]+.*$")
      ff_export <- bind_rows(ff_export, update_ff_export(ind_number, ind_abbrev, ind_desc,
                           SIC_code_low, SIC_code_high, SIC_desc))
    }
  }
  FF_number = str_extract(ff_file, "\\d{1,2}") #number of industries
  write_csv(ff_export,  str_c("SIC_to_FF", FF_number, ".csv"))
}

#Loop over downloaded files
walk(file_unzipped, SIC_to_FF)