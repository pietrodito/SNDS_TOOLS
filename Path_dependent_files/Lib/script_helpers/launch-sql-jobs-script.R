source("<hard-coded-path>/Lib/common/01_minimal_packages.R")
setup_connection()
setwd("..")
run_sql_file("<path-to-file>")

list_results <- list_results