library(targets)

options(tidyverse.quiet = TRUE, timeout = 300)
tar_option_set(packages = c("tidyverse","sbtools","sf",'dataRetrieval',"nhdplusTools",'dplyr','readxl','readr','stringr','mapview','leaflet', 'httr', 'scico', 'openxlsx', 'rmapshaper', 'scales'))

source("1_fetch.R")
source("2_process.R")
source("3_visualize.R")

## Create dirs - most should already exist in repo  
dir.create('1_fetch/in', showWarnings = FALSE)
dir.create('1_fetch/out', showWarnings = FALSE)
dir.create('1_fetch/src', showWarnings = FALSE)
dir.create('2_process/src', showWarnings = FALSE)
dir.create('2_process/out', showWarnings = FALSE)
dir.create('3_visualize/src', showWarnings = FALSE)
dir.create('3_visualize/out', showWarnings = FALSE)
dir.create('1_fetch/in/nhdhr', showWarnings = FALSE)
dir.create('1_fetch/in/nhdhr_backup', showWarnings = FALSE)

# Return the complete list of targets
c(p1_targets_list, p2_targets_list, p3_targets_list)