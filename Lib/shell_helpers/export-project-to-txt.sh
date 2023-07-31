CURRENT_DIR=${PWD##*/}        
CURRENT_DIR=${CURRENT_DIR:-/} # to correct for the case where PWD=/

zip \
 -r project-export.zip . \
 -x ./data_NOT_EXPORTED/**\* ./.Rproj.user/**\* ./.Rhistory .git/**\* .temp/**\* @
base64 project-export.zip > project-export.txt
rm -f project-export.zip
mv project-export.txt ~/sasdata1/download/$CURRENT_DIR.txt