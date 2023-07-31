setup_connection <- function()  {
  drv <- DBI::dbDriver("Oracle")
  oracle_connection <<- ROracle::dbConnect(drv, dbname = "IPIAMPR2.WORLD")
}

run_sql_file <- function(sql_file) {
  
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
                    stringr::str_split(
                      readr::read_file(sql_file),
                      "\n/", simplify = TRUE))
                ), V1 = stringr::str_trim(V1)
              ), stringr::str_length(V1) > 0
            ), V1)
        )) -> list_needs_numbering
    
    names(list_needs_numbering) <-
      stringr::str_c("Query #", seq_along(list_needs_numbering), ":")
    list_needs_numbering
  }
  
  main <- function() {
    tmp_sql_file <- stringr::str_c(sql_file, ".temp")
    apply_m4_to_file <- function() {
      system(stringr::str_c("m4 ", sql_file, " > ", tmp_sql_file))
    }; apply_m4_to_file()
    queries <- parse_sql_queries(tmp_sql_file)
    system(stringr::str_c("rm ", tmp_sql_file))
    rss <- purrr::map2(queries, names(queries), ~ treat_query(.x, .y))
    query_results <- purrr::compact(rss)
    if (length(query_results) > 0) {
      names(query_results) <- stringr::str_c("Result #",
                                    seq_along(query_results))
      print(query_results)
    } else {
      cat("No result \n")
    }
    invisible(query_results)
  }
  assign("list_results", main(), envir = .GlobalEnv)
}

launch_sql_job <- function(sql_file) {
  temp_string <- floor(runif(1)*10000000)
  temp_path <- str_c(".temp/tempfile.", temp_string,".R")
  system(
    str_c("sed 's:<path-to-file>:", sql_file,
          ":' <hard-coded-path>/Lib/script_helpers/launch-sql-jobs-script.R > ",
          temp_path ))
  rstudioapi::jobRunScript(
    path = temp_path,
    name = sql_file,
    importEnv = TRUE,
    exportEnv = "R_GlobalEnv")
}