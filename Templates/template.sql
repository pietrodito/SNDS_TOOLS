include(sql/00_user_macros.m4)
include(/sasdata/prd/users/42a001092210899/sasuser/RStudio_projects/_SNDS_TOOLS/Macros/load-macros.m4)

create_table()
select
from
/

-- You need to keep this drop command when you insert lines 
-- into a table otherwise the table could stay unaccessible
drop table FLUSH_INSERTIONS
/