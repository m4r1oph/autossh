#!/bin/bash
wcontador=0
while [ $wcontador -le 10 ]
    do
        if [[ $wcontador -le 1 ]]
            then
                tput setaf $wcontador; echo "$(cat ./Titulo/Titulo1.txt)"
            elif [[ $wcontador -le 2 ]]
                then
                    tput setaf $wcontador; echo "$(cat ./Titulo/Titulo2.txt)"
            elif [[ $wcontador -le 4 ]]
                then
                    tput setaf $wcontador; echo "$(cat ./Titulo/Titulo3.txt)"
            elif [[ $wcontador -le 6 ]]
                then
                    tput setaf $wcontador; echo "$(cat ./Titulo/Titulo2.txt)"
            elif [[ $wcontador -le 8 ]]
                then
                    tput setaf $wcontador; echo "$(cat ./Titulo/Titulo1.txt)"
            elif [[ $wcontador -le 10 ]]
                then
                    tput setaf $wcontador; echo "$(cat ./Titulo/Titulo2.txt)"         
        fi   
        sleep 0.1
        clear
        wcontador=$(($wcontador+1))
    done
tput setaf $wcontador; echo "$(cat ./Titulo/Titulo3.txt)"
tput sgr0