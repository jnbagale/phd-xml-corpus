#!/bin/bash
echo "exi processor time test for small files"
init()
{ 
for file in $(find ./* -type f |ls -Sr *.xml) 
do
	encodedxml=${file: 0:-4}
	newxml=${file: 0:-4}
	xsdfile=${file: 0:-4}

	echo "${file}"
	echo "Encode"
	/usr/bin/time -o exi_compact_encode.txt -a -f "%C, %e, %M"  ../ExiProcessor/encode_function_compact.sh ${file} ${encodedxml} ${xsdfile}

        # Sleep 2 Seconds to allow energy consumption to settle
	sleep 2

	echo "Decode"

	/usr/bin/time -o exi_compact_decode.txt -a -f "%C, %e, %M"  ../ExiProcessor/decode_function_compact.sh ${encodedxml} ${newxml} ${xsdfile}

	original_size=$(stat -c%s "$file")
	compressed_size=$(stat -c%s "$encodedxml.exi")
	ratio=$(echo "scale=3; ${compressed_size}/${original_size}" | bc)
	percentage=$(echo "scale=3; (${compressed_size}/${original_size})*100" | bc)
	echo "${compressed_size}, ${original_size}, CR:, ${ratio}, ${percentage}% $file">>exi_compact_size.txt
	
       # Sleep 2 Seconds to allow energy consumption to settle
	sleep 2
done 
} 
rm *.exi # clean up any left over files
rm *.new.xml
init
rm *.exi
rm *.new.xml
