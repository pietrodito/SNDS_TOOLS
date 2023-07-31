download_table <- function(table) {
  
  begin <- Sys.time()
  rs <- tryCatch(
      dbSendQuery(oracle_connection, str_c("select * from ", table)),
      error = function(e)  cat(e$message) 
    )
    duration <- difftime(Sys.time(), begin)
    cat("Execution time:", format(duration), "\n")
    f <- tibble::as_tibble(ROracle::fetch(rs))
    print(f) 
    return(f)
}