include(sql/00_user_macros.m4)
include(<hard-coded-path>/Macros/load-macros.m4)

create_table()
select
from
/

-- You need to keep this drop command when you insert lines 
-- into a table otherwise the table could stay unaccessible
drop table FLUSH_INSERTIONS
/