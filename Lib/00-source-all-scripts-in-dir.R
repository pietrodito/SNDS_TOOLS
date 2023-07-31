source_all_scripts_in_dir <- function(dirpath) {
 source_if_R_file <- function(file) {
  if (tools::file_ext(file) == "R")
   source(file)
 }
 
 R_scripts <- list.files(dirpath, recursive = TRUE)
 R_paths <- sapply(R_scripts, function(s)
  paste0(dirpath, s))
 sapply(R_paths, source_if_R_file)
 invisible()
}
