#!/bin/bash
echo "xml to string time test for small files"
init()
{ 
    for file in $(find ./* -type f |ls -Sr *.xml)  
    do
	encodedxml=${file: 0:-4}
	newxml=${file: 0:-4}

	echo "${file}"

	echo "Encode"
	/usr/bin/time -o libxml2_encode.txt -a -f "%C, %e, %M"  ../libxml2/xml2string ${file} ${encodedxml}.plain 100

            # Sleep 2 Seconds to allow energy consumption to settle
	sleep 2
	echo "Decode"

	/usr/bin/time -o libxml2_decode.txt -a -f "%C, %e, %M"  ../libxml2/xml2string ${encodedxml}.plain ${newxml}.new.xml 100

   	original_size=$(stat -c%s "$file")
	compressed_size=$(stat -c%s "$encodedxml.plain")
	ratio=$(echo "scale=3; ${compressed_size}/${original_size}" | bc)
	percentage=$(echo "scale=3; (${compressed_size}/${original_size})*100" | bc)
	echo "${compressed_size}, ${original_size}, CR:, ${ratio}, ${percentage}% $file">>libxml2_size.txt
 
        # Sleep 2 Seconds to allow energy consumption to settle
	sleep 2
    done
} 
rm *.plain # clean up any left over files
rm *.new.xml
init
rm *.plain
rm *.new.xml
