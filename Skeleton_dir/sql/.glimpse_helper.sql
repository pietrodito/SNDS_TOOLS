include(sql/00_user_macros.m4)
include(/sasdata/prd/users/42a001092210899/sasuser/RStudio_projects/_SNDS_TOOLS/Macros/load-macros.m4)

select count(*)
from <table-to-glimpse>
/

export_first(10, <table-to-glimpse>)