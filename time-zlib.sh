#!/bin/bash
echo "zlib time test for small files"
init()
{ 
    for file in $(find ./* -type f |ls -Sr *.xml)  
    do
	encodedxml=${file: 0:-4}
	newxml=${file: 0:-4}

	echo "${file}"

	echo "Encode"
	/usr/bin/time -o zlib_encode.txt -a -f "%C, %e, %M"  ../zpipe/encode_function.sh ${file} ${encodedxml}

        # Sleep 2 Seconds to allow energy consumption to settle
	sleep 2
	echo "Decode"

	/usr/bin/time -o zlib_decode.txt -a -f "%C, %e, %M"  ../zpipe/decode_function.sh ${encodedxml} ${newxml}
  
	original_size=$(stat -c%s "$file")
	compressed_size=$(stat -c%s "$encodedxml.zlib")
	ratio=$(echo "scale=3; ${compressed_size}/${original_size}" | bc)
	percentage=$(echo "scale=3; (${compressed_size}/${original_size})*100" | bc)
	echo "${compressed_size}, ${original_size}, CR:, ${ratio}, ${percentage}% $file">>zlib_size.txt
       
        # Sleep 2 Seconds to allow energy consumption to settle
	sleep 2
    done
} 
rm *.zlib # clean up any left over files
rm *.new.xml
init
rm *.zlib
rm *.new.xml
