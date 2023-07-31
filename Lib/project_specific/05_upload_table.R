upload_from_csv <- function(csv_file, table_name, csv2 = FALSE) {
  
 table_name <- quo_name(enquo(table_name))
   
 tmp_sql_file <- str_c("./.temp/tempfile.", floor(runif(1)*1000000), ".sql")
 df <- declare_vars <- NULL
 
 read_file_and_columns_size <- function() {
  if(csv2) {
    suppressMessages(df <<- read_csv2(csv_file)) 
  } else {
    suppressMessages(df <<- read_csv(csv_file)) 
  }
  max_length <- map(df, ~ max(str_length(.), na.rm = TRUE))
  declare_vars <<- str_c(names(df), " varchar (", max_length, ")",
                         collapse = ",\n")
 }
 
 replace_NA_by_NULL <- function() {
   df <<- replace(df, is.na(df), 'NULL')
 }
 
 replace_quotes_by_underscores <- function() {
   (
     df
     %>% mutate(across(.fns = ~ str_replace_all(., "'", "")))
   ) ->> df
 }
 
 create_table <- function() {
  drop_table(table_name, confirm = FALSE)
  create_table_string <- str_c("create table ", table_name,
                               " (\n", declare_vars, ")\n/\n")
  write_file(create_table_string, tmp_sql_file)
 }
  
 insert_lines <- function() {
   
   slice_thickness <- 1000
   N <- nrow(df)
   number_of_slice <- ceiling(N / slice_thickness) - 1
   
   walk(0:number_of_slice, function(nb_of_t) {
     
     slice <- slice(df, 1:slice_thickness + nb_of_t*slice_thickness)
     (
       slice
       %>% mutate(into = str_c("into ", table_name, " values "), .before = 1)
       %>% mutate(values = reduce(.[2:ncol(.)], str_c, sep = "','"))
       %>% mutate(out = str_c(into, "('" ,values, "')"))
       %>% pull(out)
       %>% str_c(collapse = "\n")
     ) -> lines_to_insert
     insert_into_string <- str_c("insert all \n",
                               lines_to_insert, "\n")
     write_file(insert_into_string, tmp_sql_file, append = TRUE)
     write_file("select * from dual \n/\n", tmp_sql_file, append = TRUE)
   })
 }
 
 read_file_and_columns_size()
 replace_NA_by_NULL()
 replace_quotes_by_underscores()
 create_table()
 insert_lines()
 run_sql_file(tmp_sql_file)
 file.remove(tmp_sql_file)
}

upload_from_csv2 <- function(csv_file, table_name) {
 upload_from_csv(csv_file, table_name, csv2 = TRUE)
}

  
  