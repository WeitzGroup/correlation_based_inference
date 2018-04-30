#!/bin/bash
# Run SparCC on all data files in the input folder

# parent directory of the SparCC scripts:
dir0=../../../software/sparcc/

dir1=input/
dir2=output/
filenames=$( ls $dir1 )

for filename in $filenames
do

  python $dir0"SparCC.py" $dir1$filename -c $dir2$filename

done
