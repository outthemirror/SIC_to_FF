library(tidyverse)

all_FF_numbers <- function(){
  # helper function to print all FF industries
  print(c(5, 10, 12, 17, 30, 38, 48, 49))
}

SIC_to_FF<- function(FF_number = 48){
  # FF_number = 5, 10, 12, 17, 30, 38, 48, 49, 
  download.file("http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/Industry_Definitions.zip", 'FF.zip') 
  unzip('FF.zip')
  
  res <- read_delim(paste0('Siccodes', FF_number, '.txt'), delim = "/n ", col_names = 'SIC') %>%
    mutate(ind = case_when(!str_detect(SIC, '\\d{4}-\\d{4}') ~ SIC, T ~ NA_character_)) %>%
    fill(ind, .direction = 'down') %>%
    mutate(ind_number = as.integer(str_extract(ind, '\\d+\\s')), ind = str_remove(ind, '\\d+\\s'), 
           ind_short = str_trim(str_extract(ind, '[A-z]+\\s')), ind_desp = str_trim(str_remove(ind, '[A-z]+\\s'))) %>%
    select(-ind) %>%
    filter(str_detect(SIC, '\\d{4}-\\d{4}') |((ind_short=='Other') & (sum(ind_short=='Other') ==1))) %>%
    mutate(SIC_codes = str_extract(SIC, '\\d{4}-\\d{4}'), SIC_detail = str_trim(str_extract(SIC, '\\s[A-z]+.*'))) %>%
    separate(SIC_codes, into = c('SIC_start', 'SIC_end'), sep = '-') %>%
    mutate(SIC_start = as.integer(SIC_start), SIC_end = as.integer(SIC_end)) %>%
    select(-SIC)
   
  file.remove(c('FF.zip' ), dir(pattern = 'Siccodes\\d{1,2}.txt'))
  return(res)
}
