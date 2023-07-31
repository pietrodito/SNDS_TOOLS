preview_table <- function(table_name) {
  
  template_path <- tempfile_path <- NULL
    
  copy_template_to_temp <- function() {
    template_path <<- "./sql/.glimpse_helper.sql"
    tempfile_path <<- str_c("./sql/.tempfile", ceiling(1e6*runif(1)), ".sql")
    sh(str_c("cp ", template_path, " ", tempfile_path))
  }
  
  update_table_name_in_temp_file <- function() {
    command <- str_c("sed -i 's/<table-to-glimpse>/", table_name, "/' ",
                     tempfile_path)
    sh(command)
  }
  
  remove_temp_file <- function() sh(str_c("rm -f ", tempfile_path))
    
  copy_template_to_temp()
  update_table_name_in_temp_file()
  run_sql_file(tempfile_path, verbose = FALSE)
  remove_temp_file()
  line <- str_c(c(rep("_", 80), "\n"), collapse = "")
  cat(line)
  cat("Preview of table: ", table_name, "\n")
  print(list_results[[1]])
  cat(line)
  print(list_results[[2]])
  cat(line)
  glimpse(list_results[[2]])
  cat(line)
}