sh <- function(command = NULL,
               current_dir = getwd(),
               complete_path = FALSE,
               intern = FALSE) {
 if (!is.null(command))
  system(command, intern = intern)
 else {
  short_name <- function(dir)
   str_extract(dir, "[^/]*$")
  
  format_prompt <- function() {
   if (complete_path)
    path <- current_dir
   else
    path <- short_name(current_dir)
   str_c(path, " $ ")
  }
  
  parent_dir <- function(dir) {
   if (dir == "/")
    return("/")
   else
    str_replace(dir, "/[^/]*$", "")
  }
  
  treat_cd_case <- function(r) {
   current_dir <<- system(str_c("cd ", current_dir, " && ",
                                r , " && pwd"), intern = T)
   system(str_c("cd ", current_dir, " && ls"))
  }
  
  while (TRUE) {
   r <- readline(format_prompt())
   if (r == "exit")
    return(invisible())
   if (str_starts(r, "cd "))
    treat_cd_case(r)
   else
    system(str_c("cd ", current_dir, " && ", r))
  }
 }
}
