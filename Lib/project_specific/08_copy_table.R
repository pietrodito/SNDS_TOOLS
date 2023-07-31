copy_table <- function(source_table, copy_table) {
  
  st <- quo_name(enquo(source_table))
  ct <- quo_name(enquo(copy_table))
  
 tryCatch(
  dbSendQuery(oracle_connection, str_c("drop table ", ct)),
  error = function(e)  cat(e$message)
 )
  
 tryCatch(
  dbSendQuery(oracle_connection, str_c("create table ", ct, 
                                       " as select * from ", st)),
  error = function(e)  cat(e$message)
 )
}