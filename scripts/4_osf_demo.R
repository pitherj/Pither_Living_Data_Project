#####   Demonstration -- using the osfr package     #####
#####   Living Data Project -- Reproducibility      #####
#####   Last updated: 06 October 2020               #####
#####-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#####

## COMMENT:
## this script tests the functionality of the `osfr` package

# initial set-up ----------------------------------------------------------

## check working directory
getwd()


## install and call required packages
pkgs <- c("osfr", "usethis")
lapply(pkgs, library, character.only = TRUE)
rm(pkgs)


# accessing private OSF projects ------------------------------------------

# if you wish to access private OSF projects,  you must acquire
# an API token from: https://osf.io/settings/tokens
# This API token is saved as a variable in the .Renviron file.
# To do this:
# Load the `usethis` library, then implement its
# `edit_r_environ` command thus:
usethis::edit_r_environ(scope = "user")

# then add the token (without quotes) after:
# OSF_PAT=  

## YOU WILL NEED TO RESTART R FOR YOUR TOKEN TO BE RECOGNIZED

# now you simply paste the URL in the argument to retrieve
# info about your project  
osf_auth()

url_osf_proj <- "YOUR_OSF_OWN_URL" # such as "https://osf.io/*****"

# you can explore the project and its files
ld.project <- osf_retrieve_node(url_osf_proj)
osf_ls_files(ld.project)

# you can also use piping approach
osf_retrieve_node(url_osf_proj) %>%
  osf_ls_files()

# create a test directory
osf_mkdir(ld.project, path = "test_osfr")

# refresh the OSF web page to make sure the folder was created
# remove directory *NOTE* this permanently removes
# and there is a "check" argument that we've disabled here
# first examine the tibble that includes the project info:

ld.project.files <- osf_ls_files(ld.project)
ld.project.files

row_of_folder <- # place the row number corresponding to the folder you want to remove

# then refer to the appropriate row in the tibble to remove
osf_rm(ld.project.files[row_of_folder,], check = FALSE)

# now let's try uploading this R script to a new directory
osf_mkdir(ld.project, path = "Test_osfr")
ld.project.files <- osf_ls_files(ld.project)
ld.project.files
osf_upload(ld.project.files[row_of_folder,], path = "YOUR_OWN_PATH/4_osf_demo.R", 
           conflicts = "overwrite")

## -- ## -- ## -- ## -- ## END OF SCRIPT ## -- ## -- ## -- ## -- ##