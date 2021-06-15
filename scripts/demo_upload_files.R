## 
## This script uploads files from the "scripts" directory to the
## corresponding "scripts" directory on OSF > change the directory
## name as desired

## This script will be called by a "crontab" daily routine; 
## see instructions in "using_cronR.Rmd"

## It assumes the API token is already set up; 
## see the "4_osf_demo.R" script for instructions on that;
##
## Unfortunately due to a bug on OSF, we need to do this in two
## steps: first upload the files to the root storage location in
## the OSF project destination, THEN move those files into the
## appropriate folder at that location
##

library(osfr)  # load osfr library

## Enter your local working directory path
workdir <- "/myworkdir/"
## now get the list of files in that directory
## to simplify, we list all the files in that directory
files.to.upload <- list.files(workdir)

## NOTE: to upload additional files from a different directory and into a 
## different location on OSF, then it is simplest to copy this script from line 21
## (the definition of the working directory path) down to line 57, the end
## of the last for loop.  Replace file/path names accordingly.

## Here replace the URL address with your own URL address
## for the destination OSF project or component where you
## want the files to go
url_my_osf_proj <- "https://osf.io/XXXXX/"  # establish desired OSF project / component
my.project <- osf_retrieve_node(url_my_osf_proj) # creates tibble of location
my.project.files <- osf_ls_files(my.project)  # create tibble of files

# my.project.files    # this shows the tibble  

# Loop through files to be uploaded to root storage on OSF project
# OSF will replace files of same name IF they have changed
for (i in 1:length(files.to.upload)) {
  osf_upload(my.project, 
             path =  paste(workdir, files.to.upload[i], sep = ""), 
             conflicts = "overwrite") # overwrite if changed
}

# update the file list for the root storage location on OSF
my.project.files <- osf_ls_files(my.project)

# Now loop through each file that was uploaded, and move each file to the scripts directory
for (i in 1:length(files.to.upload)) {
  osf_mv(my.project.files[match(files.to.upload[i], my.project.files$name), ], 
         # if your directory is called something other than "scripts", replace accordingly here
         my.project.files[match("scripts", my.project.files$name), ], 
             overwrite = TRUE)
  my.project.files <- osf_ls_files(my.project) #update file list each iteration
}
# now quit R session
quit(save = "no")
