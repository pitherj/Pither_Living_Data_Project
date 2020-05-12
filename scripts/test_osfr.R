# This script tests the functionality of the `osfr` package

require(osfr)
require(usethis)

# if you wish to access private OSF projects,  you must acquire
# an API token from: https://osf.io/settings/tokens

# This API token is saved as a variable in the .Renviron file.
# To do this:
# Load the `usethis` library, then implement its
# `edit_r_environ` command thus:

# edit_r_environ(scope = "user")

# then add the token (without quotes) after:
# OSF_PAT=

# now you simply paste the URL in the argument to retrieve
# info about your project
osf_auth()
# explore the project and its files
ld.project <- osf_retrieve_node("https://osf.io/uwzx5/")
osf_ls_files(ld.project)

# can also use pipe approach
osf_retrieve_node("https://osf.io/uwzx5/") %>%
  osf_ls_files()

# create a test directory
osf_mkdir(ld.project, path = "test_osfr")
osf_mkdir(ld.project, path = "Tutorial_material")

# remove directory *NOTE* this permanently removes
# and there is a "check" argument that i've disabled here
# first examine the tibble that includes the project info:
ld.project.files <- osf_ls_files(ld.project)
ld.project.files

# then refer to the appropriate row in the tibble to remove
osf_rm(ld.project.files[2,], check = F)

# now let's try uploading this R script to a new directory
osf_mkdir(ld.project, path = "Test_osfr")
ld.project.files <- osf_ls_files(ld.project)
ld.project.files
osf_upload(ld.project.files[3,], path = "test_osfr.R", conflicts = "overwrite")
