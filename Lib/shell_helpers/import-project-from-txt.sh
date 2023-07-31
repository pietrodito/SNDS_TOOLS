FILE_WITHOUT_EXTENSION=`echo $1 | sed 's/\.txt$//'`
FILE_NAME=`basename $FILE_WITHOUT_EXTENSION`
DEST_DIR=../_IMPORT_PROJECTS/$FILE_NAME

xxd -r $1 > import-project.zip
mkdir -p $DEST_DIR
mv import-project.zip $DEST_DIR
cd $DEST_DIR
unzip import-project.zip
rm import-project.zip