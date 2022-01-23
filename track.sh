#!/bin/bash

#comment on the task: i can't seem to figure out why we: 
#a) are required to change the bash environment
#b) save those changes to .bashrc

if [ -z $LOGFILE ]; then
    if [ -z "$(grep LOGFILE < ~/.bashrc)" ]; then #though we could have just as well done if grep LOGFILE < ~/.bashrc;
        echo "export LOGFILE=$HOME/.local/share/.timer_logfile" >> ~/.bashrc
        echo "added export to .bashrc"
    fi
    #why isn't this sourcing when running in subprocess, surely I should be able
    #to refresh ~/.bashrc exports in a subprocess if I want to?
    source ~/.bashrc 
fi

if [ ! -f $LOGFILE ]; then
    touch $LOGFILE
    echo "created $LOGFILE"
fi

fromLastLineGet() {
    tail -1 $LOGFILE | cut -f $1 -d " "
}

track() {
    status=$(fromLastLineGet 1) 
    case $1 in
        start) 
            if [[ $status != "END" && $status != "" ]]; then
                echo "Timer alrady running"
            else 
                echo "START $(date)" >> $LOGFILE
                echo "LABEL ${2:-none}" >> $LOGFILE
            fi
            ;;
        stop)
            if [ $status != "END" ]; then
                echo "END $(date)" >> $LOGFILE
            else 
                echo "Timer not started yet"
            fi
            ;;
        status)
            if [ $status == "END" ]; then
                echo "Currently not tracking any tasks"
            else
                echo "Currently tracking task \" $(LOGlastline 2) \" "
            fi
            ;;
        log)
            unset timelog startdate enddate label
            while read -r line
            do
                token=$(<<<$line cut -f1 -d " ")
                data=$(<<<$line cut -f2-  -d " ")

                [[ -z $startdate && $token == "START" ]] && startdate=$data
                [[ -z $label && $token == "LABEL" ]] && label=$data
                [[ -z $enddate && $token == "END" ]] && enddate=$data

                if [[ ! -z "$startdate" && ! -z "$enddate" && ! -z "$label" ]]; then 
                    deltaseconds=$(( $(date +%s -d "$enddate") - $(date +%s -d "$startdate") ))
                    #line below yoinked from https://stackoverflow.com/a/28451379/10659239
                    timediff=$(printf '%dh:%dm:%ds\n' $((deltaseconds/3600)) $((deltaseconds%3600/60)) $((deltaseconds%60))) 
                    timelog+="Task Label: \" $label \", Time: $timediff"$'\n'
                    unset startdate enddate label
                fi
            done < $LOGFILE
            echo "$timelog"
            ;;
        *)
            echo "Invalid command"
            ;;
    esac
}






