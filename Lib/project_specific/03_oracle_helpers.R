list_tables <- function(prefixe = "") {
  fetch_result <- fetch(dbSendQuery(oracle_connection, str_c("
                                 select table_name
                                 from user_tables
                                 where table_name like '", prefixe, "' || '%'
                                 order by table_name asc")))
  
  tables <- fetch_result$TABLE_NAME
  
  cat("\n=========================================================")
  cat("\n            ----     TABLES ORAUSER     ----             ")
  cat("\n=========================================================\n")
  
  cat(tables %>% str_c(collapse = "\n"))
}

drop_table <- function(prefixe, confirm = TRUE) {
  
  fetch_result <- fetch(dbSendQuery(oracle_connection, str_c("
                                 select table_name
                                 from user_tables
                                 where table_name like '", prefixe, "' || '%'
                                 order by table_name asc")))
  tables <- fetch_result$TABLE_NAME
  
  if(confirm) {
    cat(tables %>% str_c(collapse = "\n"))
    cat("\n", "=========================================================")
    cat("\n", "!!! ---- Voulez-vous effacer toutes ces tables ? ---- !!!")
    cat("\n", "=========================================================")
    answer <<- readline("O/N ?")
  } else {
    answer <- "O"
  }
  
  if(answer == "O") {
    
    walk(tables, function(table) {
    tryCatch(
     dbSendQuery(oracle_connection, str_c("drop table ", table)),
     error = function(e)  cat(e$message)
    )
      
    })
  }
  
}

drop_all_orauser_tables <- function() {
  drop_table("")
}
