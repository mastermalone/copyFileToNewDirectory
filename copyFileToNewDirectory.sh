#!/bin/bash
csv_file_name=$1

# This script is useful for us lazy bums who do not want to manually copy and paste a bunch of files and rname the extention
# over from one place to another.
# The .csv file must have a listing of where the file is coming from and where it is going to
# Example .csv row:
#   ____________________A______________________________________ __________________________________________B____________________________________________________________
#   |web2/jsp/template/directives/add-deliverable-revision.jsp | web2/frontend-web/angoolar_components/deliverables/templates/directives/add-deliverable-revision.html|
#   -------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Useage:  ./copyFileToNewDirectory.sh some-cool.csv
function read_csv () {
  echo "working $csv_file_name";

  #Ignore the header
  exec < $csv_file_name;
  read header;

  #loop through the csv file
   if [[ -f $csv_file_name ]];
   then
    # Loop through the .csv file and create variables for the columns you need
    while IFS="," read -r origin destination
    do
      # If the directories do not exist, create them
      if [[ "ls "$(dirname "$destination")"; pwd)/ >& /dev/null" ]];
      then
        # Create a new directory from the string obtained via the 'destination' variable
        new_directory="$(dirname "$destination")";
        # Create the new directories within the path listed in the vaiable above and copy over the files
        mkdir -p "$new_directory"/ && cp $origin "$new_directory"/;

        echo "Copying: $origin to $new_directory/";
        (cd $new_directory && convertExtentionToHtml);

      else
        cp $origin "$new_directory"/;
        echo "Copying: $origin to $new_directory/";
        (cd $new_directory && convertExtentionToHtml);
      fi
    done
   fi
}

# More laziness that converts the jsp to html so you don't have to
function convertExtentionToHtml () {
  for f in *.jsp;
  do
    mv -- "$f" "${f%.jsp}.html";
  done
}

read_csv