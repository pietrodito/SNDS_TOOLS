l <- function(prefixe) {
  prefixe <- quo_name(enquo(prefixe))
  list_tables(prefixe)
}
p <- function(table) { 
  table <- quo_name(enquo(table))
  preview_table(table)
}
dl <- function(table) { 
  table <- quo_name(enquo(table))
  download_table(table)
}
dr <- function(table) { 
  table <- quo_name(enquo(table))
  drop_table(table)
}