export_project_to_txt <- function() {
  system(paste0("sh <hard-coded-path>/Lib/shell_helpers/export-project-to-txt.sh"))
}

import_project_from_txt <- function(fichier) {
  system(paste0("sh <hard-coded-path>/Lib/shell_helpers/import-project-from-txt.sh ", fichier))  
}
