create_sql_file <- function(name) {
  short_path_file_to_create <- str_c("./sql/", name, ".sql")
  file_to_create <- str_c(getwd(), "/", short_path_file_to_create)
   if(file.copy("<hard-coded-path>/Templates/template.sql", file_to_create)) {
     message(str_c("File ./sql/", name, ".sql created."))
     rstudioapi::documentSave()
     text_to_insert <-  str_c(
       "if(sys.nframe() == 0) file.edit(\"", short_path_file_to_create, "\") \n",
       "run_sql_file(\"", short_path_file_to_create, "\")\n\n",
       "if(sys.nframe() == 0) create_sql_file(\"99-abc\")" )
     line_to_replace <-
       sh(
         "grep -n create_sql_file ./R/01-sql-orchestration.R | cut -d ':' -f 1 | head -n 1",
         intern = T) %>% as.numeric()
     rstudioapi::insertText(
       location = rstudioapi::document_range(
         rstudioapi::document_position(line_to_replace, 1),
         rstudioapi::document_position(line_to_replace + 1, 1)),
       text_to_insert)
     rstudioapi::documentSave()
     file.edit(file_to_create)
   }
  else
    if (file.exists(file_to_create))
      warning(str_c("File ./sql/", name, ".sql already exists."))
    else 
      warning(str_c("File ./sql/", name, ".sql could not be created."))
}
