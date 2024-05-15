This is the BEEBS benchmark for the ESP32 (tested with ESP-IDF v5.0). The original benchmark can be found here: https://github.com/mageec/beebs.
This is not a proper port due to timing constraints.
The benchmark is used to measure the overhead of the FreeROTS kernel changes of the WindowGuardian project: .

# Generate CMakeLists.txt for main module

The CMakeLists.txt file for the main component is generatey by the `gen_cmake.py` script based on the subdirectories in the component.
Each subdirectory contains header and sourse files for a specific benchmark. More benchmarks can be added simply by adding another subdirectory and comply to the interface for BEEBS benchmarks.

# Run the benchmark

Use the `run.py` benchmark to run the script.
Due to the large number of benchmarks, there are options to narrow down the selction for benchmarks as well as only run it for a specific security configuration instead of all possible combinations.
All results are printed in a Markdown table format and can be collected in the table below.

## Currently broken benchmarks

* ctl, ctl-stack, ctl-string, ctl-vector
* matmult, matmult-float, matmult-int 
* miniz
* nettle-cast128
* select
* sglib-arrayheapsort, sglib-arrayquicksort, sglib-arraysort, sglib-dllist, sglib-listinsertsort
* trio, trio-snprintf, trio-sscanf

## Recommended parameters

The values can be passed for the `SEC_METHOD` macro (or use -m in `run.py`):
* 0: nothing changes, used as a reference benchmark
* 1: Re-encryption, registers a0-a3 are encrypted, cipertext is placed in upper half of stack and used for verification
* 2: Ciphering, registers a0, a2, a3, a4 are encrypted when written to stack and decrypted when loaded into registers 
* -1: Not a method but counts the number of window overflows executed during the benchmark

## Create a table

The result in the bottom can be used by `to_table.py` to create a table for Latex documents.
While the script takes no parameters it can easily be modified i.e. for a different output, differnt benchmarks to present or how the results should be sorted.

# Differences from the original WindowGuardian project
The project remains mainly unchanged aside from some adaptions to allow the different methods being compiled using a script and some small changes in `components/freertos/FreeRTOS-Kernel/portable/xtensa/aes_encryption.S` such as:
* Using of different load/store instructions to access ciphertext for Re-enencryption method to resolve potential edge cases where ciphertext is written to the ends of the extended stack
* Use of `memw` instructions when starting the AES hardware accelerator due to rare crashes

# Results
These are the results used for generating the table. There can be slight differences when executing the script yourself, depending on the benchmark.

| Benchmark | Modification | Result |
|---|---|---|
|aha-compress|-1| 201|
|aha-mont64|-1| 182|
|bs|-1| 0|
|bubblesort|-1| 1273|
|cnt|-1| 87|
|compress|-1| 86|
|cover|-1| 108|
|crc|-1| 30|
|crc32|-1| 547|
|cubic|-1| 6546|
|dijkstra|-1| 16316|
|dtoa|-1| 126|
|duff|-1| 14|
|edn|-1| 1008|
|expint|-1| 34|
|fac|-1| 45076|
|fasta|-1| 9514|
|fdct|-1| 26|
|fibcall|-1| 3|
|fir|-1| 3922|
|frac|-1| 1438|
|huffbench|-1| 5020|
|insertsort|-1| 12|
|janne_complex|-1| 3|
|jfdctint|-1| 38|
|lcdnum|-1| 2|
|levenshtein|-1| 1051|
|ludcmp|-1| 59|
|mergesort|-1| 12196|
|minver|-1| 48|
|nbody|-1| 33640|
|ndes|-1| 1164|
|nettle-aes|-1| 1016|
|nettle-arcfour|-1| 180|
|nettle-des|-1| 75|
|nettle-md5|-1| 16|
|nettle-sha256|-1| 144|
|newlib-exp|-1| 15|
|newlib-log|-1| 11|
|newlib-mod|-1| 3|
|newlib-sqrt|-1| 24|
|ns|-1| 0|
|nsichneu|-1| 119|
|picojpeg|-1| 76135|
|prime|-1| 165|
|qrduino|-1| 19123|
|qsort|-1| 16|
|qurt|-1| 165|
|recursion|-1| 20523|
|rijndael|-1| 13734|
|sglib-arraybinsearch|-1| 200|
|sglib-hashtable|-1| 335|
|sglib-listsort|-1| 348|
|sglib-queue|-1| 242|
|sglib-rbtree|-1| 480404|
|slre|-1| 78729|
|sqrt|-1| 12749|
|st|-1| 3757|
|statemate|-1| 29|
|stb_perlin|-1| 1997|
|stringsearch1|-1| 158|
|strstr|-1| 26|
|tarai|-1| 8|
|ud|-1| 49|
|whetstone|-1| 23090|
|wikisort|-1| 31000|
|aha-compress|0| 509847|
|aha-compress|1| 509971|
|aha-compress|2| 509946|
|aha-mont64|0| 451620|
|aha-mont64|1| 451743|
|aha-mont64|2| 451711|
|bs|0| 3725|
|bs|1| 3725|
|bs|2| 3725|
|bubblesort|0| 3188339|
|bubblesort|1| 3189198|
|bubblesort|2| 3188974|
|cnt|0| 189518|
|cnt|1| 189584|
|cnt|2| 189570|
|compress|0| 209114|
|compress|1| 209177|
|compress|2| 209161|
|cover|0| 267254|
|cover|1| 267327|
|cover|2| 267308|
|crc|0| 72501|
|crc|1| 72520|
|crc|2| 72515|
|crc32|0| 1260661|
|crc32|1| 1261186|
|crc32|2| 1260958|
|cubic|0| 11060804|
|cubic|1| 11065955|
|cubic|2| 11065376|
|dijkstra|0| 39190433|
|dijkstra|1| 39202118|
|dijkstra|2| 39198881|
|dtoa|0| 261357|
|dtoa|1| 261426|
|dtoa|2| 261413|
|duff|0| 43910|
|duff|1| 43917|
|duff|2| 43914|
|edn|0| 2552807|
|edn|1| 2553482|
|edn|2| 2553306|
|expint|0| 81642|
|expint|1| 81664|
|expint|2| 81658|
|fac|0| 46108|
|fac|1| 107014|
|fac|2| 91227|
|fasta|0| 22038504|
|fasta|1| 22045434|
|fasta|2| 22043682|
|fdct|0| 64431|
|fdct|1| 64447|
|fdct|2| 64443|
|fibcall|0| 8715|
|fibcall|1| 8718|
|fibcall|2| 8718|
|fir|0| 9801230|
|fir|1| 9803881|
|fir|2| 9803190|
|frac|0| 2959851|
|frac|1| 2960981|
|frac|2| 2960680|
|huffbench|0| 12305350|
|huffbench|1| 12308812|
|huffbench|2| 12307952|
|insertsort|0| 38207|
|insertsort|1| 38213|
|insertsort|2| 38211|
|janne_complex|0| 8335|
|janne_complex|1| 8338|
|janne_complex|2| 8338|
|jfdctint|0| 102746|
|jfdctint|1| 102767|
|jfdctint|2| 102759|
|lcdnum|0| 9269|
|lcdnum|1| 9272|
|lcdnum|2| 9270|
|levenshtein|0| 2603693|
|levenshtein|1| 2604427|
|levenshtein|2| 2604238|
|ludcmp|0| 145738|
|ludcmp|1| 145776|
|ludcmp|2| 145767|
|mergesort|0| 16554723|
|mergesort|1| 16566620|
|mergesort|2| 16563673|
|minver|0| 112032|
|minver|1| 112060|
|minver|2| 112054|
|nbody|0| 69915553|
|nbody|1| 69940083|
|nbody|2| 69937104|
|ndes|0| 2289214|
|ndes|1| 2290177|
|ndes|2| 2289934|
|nettle-aes|0| 2000953|
|nettle-aes|1| 2001782|
|nettle-aes|2| 2001564|
|nettle-arcfour|0| 447897|
|nettle-arcfour|1| 448018|
|nettle-arcfour|2| 447988|
|nettle-des|0| 146942|
|nettle-des|1| 147001|
|nettle-des|2| 146986|
|nettle-md5|0| 37957|
|nettle-md5|1| 37968|
|nettle-md5|2| 37963|
|nettle-sha256|0| 235356|
|nettle-sha256|1| 235486|
|nettle-sha256|2| 235448|
|newlib-exp|0| 34602|
|newlib-exp|1| 34609|
|newlib-exp|2| 34611|
|newlib-log|0| 28121|
|newlib-log|1| 28130|
|newlib-log|2| 28125|
|newlib-mod|0| 7467|
|newlib-mod|1| 7470|
|newlib-mod|2| 7468|
|newlib-sqrt|0| 57200|
|newlib-sqrt|1| 57216|
|newlib-sqrt|2| 57211|
|ns|0| 743|
|ns|1| 743|
|ns|2| 743|
|nsichneu|0| 393663|
|nsichneu|1| 393714|
|nsichneu|2| 393704|
|picojpeg|0| 39841125|
|picojpeg|1| 39932622|
|picojpeg|2| 39910591|
|prime|0| 398824|
|prime|1| 398944|
|prime|2| 398909|
|qrduino|0| 36998239|
|qrduino|1| 37014124|
|qrduino|2| 37009938|
|qsort|0| 36644|
|qsort|1| 36655|
|qsort|2| 36652|
|qurt|0| 281150|
|qurt|1| 281273|
|qurt|2| 281253|
|recursion|0| 81536|
|recursion|1| 109257|
|recursion|2| 102079|
|rijndael|0| 28934756|
|rijndael|1| 28945419|
|rijndael|2| 28942528|
|sglib-arraybinsearch|0| 661110|
|sglib-arraybinsearch|1| 661200|
|sglib-arraybinsearch|2| 661177|
|sglib-hashtable|0| 817813|
|sglib-hashtable|1| 818054|
|sglib-hashtable|2| 817982|
|sglib-listsort|0| 1110077|
|sglib-listsort|1| 1110238|
|sglib-listsort|2| 1110195|
|sglib-queue|0| 804341|
|sglib-queue|1| 804447|
|sglib-queue|2| 804420|
|sglib-rbtree|0| 2726342|
|sglib-rbtree|1| 3374934|
|sglib-rbtree|2| 3206926|
|slre|0| 1632120|
|slre|1| 1737991|
|slre|2| 1710571|
|sqrt|0| 26522281|
|sqrt|1| 26532319|
|sqrt|2| 26529755|
|st|0| 7546096|
|st|1| 7549072|
|st|2| 7548332|
|statemate|0| 79097|
|statemate|1| 79113|
|statemate|2| 79110|
|stb_perlin|0| 4510504|
|stb_perlin|1| 4511998|
|stb_perlin|2| 4511512|
|stringsearch1|0| 397554|
|stringsearch1|1| 397661|
|stringsearch1|2| 397634|
|strstr|0| 64321|
|strstr|1| 64338|
|strstr|2| 64333|
|tarai|0| 13746|
|tarai|1| 13755|
|tarai|2| 13751|
|ud|0| 131519|
|ud|1| 131553|
|ud|2| 131542|
|whetstone|0| 47119100|
|whetstone|1| 47136984|
|whetstone|2| 47132418|
|wikisort|0| 67665612|
|wikisort|1| 67689312|
|wikisort|2| 67683059|