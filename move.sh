#!/bin/bash

#set bash option to move 'dot' files (e.g. .filename) --> But maybe not the best idea (. and .. files also moved?)
#shopt -s dotglob

usage="Usage: ./move.sh [-t .file_type] source_dir/ target_dir/ "
ending=*
while getopts "t:" arg; do
    case $arg in 
        t) ending=${OPTARG};;
        *) echo $usage;;
    esac
done
#shift n removes n strings from positional parameters list 
shift $(($OPTIND-1)) #so if getopts not triggered (i.e $OPTIND = 1, unmoved by getopts) then no shift

source=$1
dest=$2

if [ $# -lt 2 ]; then 
    echo "Wrong number of arguments (at least 2 required)"
    exit 1
fi

if [ ! -d "$source" ]; then
    echo "Source directory doesn't exist" 
    exit 1
fi

if [ ! -d "$dest" ]; then
    echo "Destination directory doesn't exist, would you like to create it? (y/n/time) "\
         "If 'time' then the target_dir becomes the current date"
    read x
    case $x in 
        y)      mkdir $dest;;
        n)      exit 0;;
        time)   dest=$(date +'%Y-%m-%d-%H-%M')
                mkdir $dest;;
        *)      echo >2& "Unknown option." #[?]
                exit 1;;
    esac
fi 

mv ${source}/*${ending} ${dest}  