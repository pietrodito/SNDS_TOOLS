update_tools <- function() {
  export_project_to_txt()
  current_project_path <- getwd()
  project_name <- str_extract(current_project_path, "[^/]*$")
  system("mv ./R/01-sql-orchestration.R ./R/01-sql-orchestration.bak")
  setwd("<hard-coded-path>")
  source("00-start-snds-tools.R")
  create_project(project_name, update = TRUE)
  rm(list = ls(envir = .GlobalEnv), envir = .GlobalEnv)
  setwd(current_project_path)
  system("mv ./R/01-sql-orchestration.bak ./R/01-sql-orchestration.R ")
  source("R/00-setup-new-session.R")
}