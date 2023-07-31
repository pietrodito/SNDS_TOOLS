## Synchronisation fuseaux (sinon décalage horaire)
Sys.setenv(TZ='UTC')
Sys.setenv(ORA_SDTZ='UTC')

source("<hard-coded-path>/Lib/00-source-all-scripts-in-dir.R")
source_all_scripts_in_dir("<hard-coded-path>/Lib/common/")
source_all_scripts_in_dir("<hard-coded-path>/Lib/project_specific/")
