cp -r Path_dependent_files Tmp_path_dep_files

UPDATE_FILE_CMD=./R/Shell_helpers/update-header-and-path.sh
find ./Tmp_path_dep_files -type f -exec bash $UPDATE_FILE_CMD {} \;
  
cp -r Tmp_path_dep_files/* .
  
rm -rf Tmp_path_dep_files
  
function remove_header_in_place() {
  tail -n +7 $1 > tempfile.dsflj54239ads && mv tempfile.dsflj54239ads $1
}
  
remove_header_in_place ./Macros/load-macros.m4
remove_header_in_place ./Templates/template.sql
remove_header_in_place ./Skeleton_dir/sql/.glimpse_helper.sql