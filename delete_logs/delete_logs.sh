#!/bin/ksh
################################################################################
#                                                                              #
# Name      : delete_logs.sh                                                   #
#                                                                              #
# Purpose   : This script will delete logs or directories when they have more  #
#             than a quantity of days without be modified, this value is       #
#             specified in config file.                                        # 
#                                                                              #
# Parameters: CONFIG_FILE                                                      #
#                                                                              #
#                                                                              #
################################################################################

#### Rotate logs files
Rotate_logs(){
    if [ -f $LOG ]; then
       mv $LOG $LOG`date +'%Y%m%d%H%M%S'`
    fi
}

Drop_logs(){

   PATH_LOG="$1*"
    if [ $3 = "f" ]; then
         find $PATH_LOG -prune -mtime $2 -type $3 -exec ls -ltrh {} \; >> $LOG
    else
         find $PATH_LOG -prune -mtime $2 -type $3 >> $LOG
    fi

    find $PATH_LOG -prune -mtime $2 -type $3 -exec rm -r {} \;
}

######## Loading the config file ###########
    if [ -f $1 ]; then
        . $1
        LOG=$DIR_LOGS$LOG_NAME
    else
        echo "ERROR:   Configuration file $1 doesn't exist..."
        exit
    fi

######## Loading the file with the list of path ###########
    if [ ! -f $PATH_LIST ]; then
        echo "ERROR:  File $2 donesn't exist..." >> $LOG
        exit
    fi


    Rotate_logs

    echo "LIST OF FILES AND DIRECTORIES DELETED" >> $LOG 
    echo "----------------------------------------------------------------------------------------" >> $LOG

    for line in `cat $PATH_LIST | grep -v "#"` 
    do
        path=`echo $line | awk -F "|" '{ print $1 }'`
        days=`echo $line | awk -F "|" '{ print $2 }'`
        type=`echo $line | awk -F "|" '{ print $3 }'`

        if [ -d $path ]; then
             Quantity=`ls -l $path | grep -v total | wc -l`
             if [ $Quantity -gt 1 ]; then
                  Drop_logs $path $days $type  
             fi 
        else
             echo "********** The path $path doesn't exist, please fix it" >> $LOG 
        fi
 
    done
