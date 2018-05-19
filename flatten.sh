# need to do a little bit of work to take the list of files from
#  find . -type f
# and then turn it into an array
# seems like it ought to be easier, but this handles spaces in filenames
files=()
while IFS= read -r -d $'\0'; do
    files+=("$REPLY")
done < <(find . -type f -print0)
printf '%s\n' "${files[@]}"

echo "------------------"
# file=${files[0]}

for file in "${files[@]}"; do
  #echo "$file"  # ./Arlington, VA, August 15, 2017/IMG-222.jpg
  DIR=$(echo $file | sed -En 's/..(.*)\/.*/\1/p') # Arlington, VA, August 15, 2017
  # echo "DIR=${DIR}"
  FILENAME=$(echo $file | sed -En 's/.*\/(.*)$/\1/p')  # IMG-222.jpg
  DATE=$(echo $DIR | grep -Eo "\w+ \d+, \d\d+$")  # August 15, 2017
  SHORT_DATE=$(date -j -f "%b %d, %Y" "$DATE" +%y%m%d) # 170815
  DIR_DESCRIPTION=$(echo $DIR | sed -En 's/(.*), (.* [0-9]+, [0-9]+)$/\1/p') # Arlington, VA
  NEW_DIR="${SHORT_DATE}_${DIR_DESCRIPTION}" # 170815_Arlington, VA
  NEW_FILENAME="${NEW_DIR}_${FILENAME}"
  cp "${file}" "./new/${NEW_FILENAME}"
done

echo "done!  to see your files type: ls new"
