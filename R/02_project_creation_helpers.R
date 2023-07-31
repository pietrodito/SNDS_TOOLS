create_project <- function(project_name,
                           update = FALSE) {
  
 RStudio_dir <- skeleton_dir <- project_dir <- Rproj_file <-  NULL
  
 set_up_path_variables <- function() {
  RStudio_dir  <<- sh("cd ..; pwd", intern = TRUE)
  skeleton_dir <<- "Skeleton_dir"
  project_dir  <<- str_c(RStudio_dir, "/", project_name) 
  Rproj_file   <<- str_c(project_dir, "/", project_name, ".Rproj")
 }
 
 copy_skeleton_dir_to_new_project <- function() {
  if(dir.exists(project_dir) && ! update)
   stop("Le répertoire projet existe déjà.")
  else
    if ( ! update) dir.create(project_dir)
  file_vector <- list.files(skeleton_dir, all.files = TRUE)[-(1:2)]
  path_vector <- str_c(skeleton_dir, "/", file_vector)
  file.copy(path_vector, project_dir, recursive = TRUE)
  file.copy("./Templates/template.Rproj", Rproj_file)
 } 
 
 main <- function() {
   set_up_path_variables()
   copy_skeleton_dir_to_new_project()
   if(! update) rstudioapi::openProject(Rproj_file)
   invisible()
 }
 
 main()
}
