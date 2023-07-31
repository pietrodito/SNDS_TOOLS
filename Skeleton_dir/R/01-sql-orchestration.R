source("./R/00-setup-new-session.R")
setup_connection()

if(sys.nframe() == 0)  create_sql_file("01-xxxxxxxxxxx")
