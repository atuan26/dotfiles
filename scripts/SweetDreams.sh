#!/bin/bash

x=1

while [ $x -le 1 ]

do

        echo "Sleeping" | tee -a  /home/tuanna/SweetDreams.log

        sleep 10

        echo "Waking" | tee -a  /home/tuanna/SweetDreams.log

        x=$(( $x + 1 ))

done
