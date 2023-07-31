setup_connection <- function()  {
  cat("Connecting to ORACLE...\n")
  drv <- DBI::dbDriver("Oracle")
  oracle_connection <<- ROracle::dbConnect(drv, dbname = "IPIAMPR2.WORLD")
  cat("Connected!\n")
}

run_sql_file <- function(sql_file, verbose = TRUE) {
  
  if (! verbose) {
    stdout <- vector('character')
    con    <- textConnection('stdout', 'wr', local = TRUE)
    sink(con)
  }
  
  ## Cosmetic helpers -----------------------------------------------------------
  line_of_char <- function(char, length = 81) {
    cat(stringr::str_c(
      stringr::str_c(rep(char, length), collapse = ""), "\n")) }
  
  line <- function() line_of_char("_")
  
  dashed_line <- function() line_of_char("-")
  
  underline_3_digits_group <- function(nb) {
    nbs <- str_split(nb, "") %>% unlist
    idx <- which(trunc((seq_along(nbs) - length(nbs)) / 3) %% 2 == 1)
    nbs[idx] <- crayon::underline(nbs[idx])
    cat(stringr::str_c(nbs, collapse = ""))  }
  
  ## ----------------------------------------------------------------------------
  
  send_query <- function(query) {
    begin <- Sys.time()
    rs <- tryCatch(
      ROracle::dbSendQuery(oracle_connection, query),
      error = function(e)  cat(e$message) 
    )
    duration <- difftime(Sys.time(), begin)
    cat("Execution time:", format(duration), "\n")
    if(is.null(rs)) { cat("-- FAILED --\n"); line(); return() }
    info <- ROracle::dbGetInfo(rs)
    if(info$completed) {
      cat("-- COMPLETED --\n")
      underline_3_digits_group(info$rowsAffected); cat(" rows affected.\n")
    } 
    else {
      cat("-- RETURNED VALUE --\n")
      f <- tibble::as_tibble(ROracle::fetch(rs))
      print(f) 
      return(f)
    }
  }
  
  present_query <- function(title, query) {
    cat(title); cat("\n"); dashed_line()
    cat(query); cat("\n"); dashed_line()
  }
    
  treat_query <- function(query, title) {
    cat("\n")
    cat("\n")
    line()
    present_query(title, query)
    rs <- send_query(query)
    line()
    return(rs)
  }
  
  parse_sql_queries <- function(sql_file) {
    
    suppressWarnings(
        as.list(
          dplyr::pull(
            dplyr::filter(
              dplyr::mutate(
                tibble::as_tibble(
                  t(
                    stringr::str_split(readr::read_file(sql_file),
                                       "\n/", simplify = TRUE))
                ), V1 = stringr::str_trim(V1)
              ), stringr::str_length(V1) > 0
            ), V1)
        )) -> list_needs_numbering
    
    names(list_needs_numbering) <-
      stringr::str_c("Query #", seq_along(list_needs_numbering), ":")
    list_needs_numbering
  }
  
  secure_flush_for_insertions <- function() {
    
    tryCatch(
     fetch_result <- fetch(dbSendQuery(oracle_connection, str_c("
                                    drop table FLUSH_INSERTIONS"))),
     error = function(e) return()
    )
  }
  
  main <- function() {
    tmp_sql_file <- stringr::str_c(sql_file, ".temp")
    apply_m4_to_file <- function() {
      sh(stringr::str_c("m4 ", sql_file, " > ", tmp_sql_file))
    }; apply_m4_to_file()
    queries <- parse_sql_queries(tmp_sql_file)
    file.remove( tmp_sql_file)
    rss <- purrr::map2(queries, names(queries), ~ treat_query(.x, .y))
    secure_flush_for_insertions()
    query_results <- purrr::compact(rss)
    if (length(query_results) > 0) {
      names(query_results) <- stringr::str_c("Result #",
                                    seq_along(query_results))
      cat("---------------------------------------\n")
      cat("|                        _ _          |\n")
      cat("|    _ __ ___  ___ _   _| | |_ ___    |\n")
      cat("|   | '__/ _ \\/ __| | | | | __/ __|   |\n")
      cat("|   | | |  __/\\__ \\ |_| | | |_\\__ \\   |\n")
      cat("|   |_|  \\___||___/\\__,_|_|\\__|___/   |\n")
      cat("|                                     |\n")
      cat("---------------------------------------\n")
      print(query_results)
      cat("-------------------------------------\n")
      cat(str_c("There are ", length(query_results), " result(s).\n"))
      cat("All results have been imported to variable `list_results`.")
    } else {
      cat("No result \n")
    }
    invisible(query_results)
  }
  assign("list_results", main(), envir = .GlobalEnv)
  
  if (! verbose) {
    sink()
    close(con)
  }
}

launch_sql_job <- function(sql_file) {
  temp_string <- floor(runif(1)*10000000)
  temp_path <- str_c(".temp/tempfile.", temp_string,".R")
  sh(
    str_c("sed 's:<path-to-file>:", sql_file,
          ":' <hard-coded-path>/Lib/script_helpers/launch-sql-jobs-script.R > ",
          temp_path ))
  rstudioapi::jobRunScript(
    path = temp_path,
    name = sql_file,
    importEnv = TRUE,
    exportEnv = "R_GlobalEnv")
}