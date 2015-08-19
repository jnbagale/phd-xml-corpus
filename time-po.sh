#!/bin/bash
echo "PO Compression time test small files"
init()
{ 
    for file in $(find ./* -type f |ls -Sr *.xml)
    do
	schema=${file: 0:-4}
	pofile=${file: 0:-4}
	newxml=${file: 0:-4}

	echo "$file"	
	echo "Encode"

	/usr/bin/time -o po_encode.txt -a -f "%C, %e, %M" ../packedobjects/encode_function.sh $schema $file $pofile
# packedobjects --schema $schema.xsd --in $file  --out $pofile.po --loop 100

	# Sleep  Seconds to allow energy consumption to settle
	sleep 2
	
	echo "Decode"
#	/usr/bin/time -o po_decode.txt -a -f "%C, %e, %M" ../packedobjects/decode_function.sh $schema $pofile $newxml
# packedobjects --schema $schema.xsd --in $pofile.po  --out $newxml.new.xml --loop 100

	original_size=$(stat -c%s "$file")
	compressed_size=$(stat -c%s "$pofile.po")
	ratio=$(echo "scale=3; ${compressed_size}/${original_size}" | bc)
	percentage=$(echo "scale=3; (${compressed_size}/${original_size})*100" | bc)
	echo "${compressed_size}, ${original_size}, CR:, ${ratio}, ${percentage}% $file">>po_size.txt
  
  # Sleep 2 Seconds to allow energy consumption to settle
	sleep 2
    done 
}
rm *.po # clean up any left over files
rm *.new.xml
init
rm *.po
rm *.new.xml
