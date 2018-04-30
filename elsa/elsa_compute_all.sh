#!/bin/bash
# Run lsa_compute on all data files in the input folder
# For larger networks (NV=50, NS=2500) compute time ~ 1 hr each

# parent directory of the LSA scripts:
dir0=../../../software/elsa/

dir1=input/
dir2=output/
filenames=$( ls $dir1 )

for filename in $filenames
do
  # number of host + virus variables
  NV=$( wc -l $dir1$filename )
  NV=$( echo $NV | cut -d' ' -f 1 )
  NV=$(( NV-1 ))

  # number of sampled timepoints
  NS=$( wc -w $dir1$filename )
  NS=$( echo $NS | cut -d' ' -f 1)
  NS=$(( NS/(NV+1)-1 ))

  python $dir0"lsa/lsa_compute.py" -b 0 -x 1 -r 1 -s $NS $dir1$filename $dir2$filename

done
