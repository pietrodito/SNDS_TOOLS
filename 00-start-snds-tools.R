do.call(function() {
 source("./Lib/00-source-all-scripts-in-dir.R")
 
 source_all_scripts_in_dir("./Lib/common/")
 source_all_scripts_in_dir("./R/")
}, list())

