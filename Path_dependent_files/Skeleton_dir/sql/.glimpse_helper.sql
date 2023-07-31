include(sql/00_user_macros.m4)
include(<hard-coded-path>/Macros/load-macros.m4)

select count(*)
from <table-to-glimpse>
/

export_first(10, <table-to-glimpse>)