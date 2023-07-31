update_dcir_an1 <- function() {
  
 construct_query <- function(year) {
   cat("\nWe are testing if table", str_c("ER_PRS_F_", year), " exists... ")
   str_c("select distinct 1 as ONE from ER_PRS_F_", year, " where rownum <= 1") 
 }
 
 is_query_correct <- function(query) {
   rs <- tryCatch(
       ROracle::dbSendQuery(oracle_connection, query),
       error = function(e)  cat(e$message) 
     )
   (! is_null(rs))
 }
 
 year_table_exists <- function(year) {
   answer <- is_query_correct(construct_query(year))
   if(answer) cat("it exists.")
   answer
 }
   
 year <- 2012
 while(year_table_exists(year)) year <- year + 1
 
 pattern <- "\\(define(\\[DCIR_AN1\\], \\[\\)[[:digit:]]\\+"
 pattern <- "\\(define(\\[DCIR_AN1], \\[\\)[[:digit:]]\\+"
 replacement <- str_c("\\1", year, "0101")
 sed_operation <- str_c("sed -i 's|", pattern, "|", replacement, "|'")
 target_file <- "./sql/00_user_macros.m4"
 command <- str_c(sed_operation, " ", target_file )
 sh(command)
 cat("The variable DCIR_AN1 is now set with value", str_c(year, "0101"), "in ./sql/00_user_macros.m4")
}
