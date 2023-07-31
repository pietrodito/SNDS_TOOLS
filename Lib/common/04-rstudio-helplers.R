e <- function(file) file.edit(file)

save_result <- function(i, name) {
  save_path <- str_c("./data_NOT_EXPORTED/", name, ".rds")
  saveRDS(list_results[[i]], save_path)
  print(list_results[[i]])
  cat(str_c("... saved in file ", save_path))
}

load_result <- function(name) {
  save_path <- str_c("./data_NOT_EXPORTED/", name, ".rds")
  readRDS(save_path)
}
