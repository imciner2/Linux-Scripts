BEGIN {
  FS="\t"
  children[1]=0;
  children[2]=0;
  children[3]=0;
  children[4]=0;
  cnt=0;
  lastLevel=0;
}
{
  # By default, no count
  cnt=0;

  if (lastLevel == 0)
  {
    # If the lastlevel is 0, this is the first parse
    lastLevel=$1;
    children[$1]=0;
  }

  # Update the children counter
  children[$1]=children[$1]+1;

  
  if ($1 != lastLevel)
  {
    # If the level changes, then we need to print a count
    cnt=children[$1+1];
    children[$1+1]=0;
  }

  # Update the last level
  lastLevel=$1;

  # Print out the line into the file
  print "[/Page ", $3 , " /Count ", cnt, " /View [/XYZ null null null] /Title (", $2, ") /OUT pdfmark";
}
END {
}
