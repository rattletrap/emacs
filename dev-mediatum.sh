#!/bin/bash
WORK_DIR=$HOME/Development/mediatum
MEDIATUM_CONFIG=$HOME/mediatum-config/mediatum.conf
GPL=$HOME/bin/GPLv3.txt
#NIX_BIN='nix-shell --packages "/home/ar/Development/mediatum/backend.nix" --run '
POSTGRES="pg_ctl -D $HOME/postgresql-config" # Inner quotes for eval shell-builtin
## python bin/mediatum.py

############################################################
# Help                                                     #
############################################################
Help()
{
    # Display Help
    echo
    echo -ne "\a"
    echo -e "Starts processes with nix-shell in the mediatum environment:"
    echo "${WORK_DIR}"
    echo
    echo "Runs the postgresql-server with:"
    echo -e "cd ${WORK_DIR} &&\\"
    echo "nix-shell --run \"${POSTGRES} start\""
    echo
    echo "Syntax: ${0} [-g|h]"
    echo "Syntax: ${0} [start|stop|pycharm|emacs]"
    echo
    echo "options:"
    echo "g     Print the GPL license notification and exit."
    echo "h     Print this Help and exit."
    #echo "v     Verbose mode."
    #echo "V     Print software version and exit."
    echo
    echo "commands:"
    echo "start    Starts the postgresql-server only."
    echo "stop     Stops the postgresql-server."
    echo "pycharm  Starts the postgresql-server and pycharm in mediatum environment."
    echo "emacs    Starts the postgresql-server and emacs in mediatum environment."
    echo "code     Starts the postgresql-server and (VS) code in mediatum environment."
    echo
}

############################################################
# Start / Stop                                             #
############################################################
function Start()
{
    # cd $WORK_DIR
    # start the database
    eval "cd ${WORK_DIR} && nix-shell --run \"${POSTGRES} start\""
    # start the editor
    if [ "$1" = "pycharm" ]; then
	eval "nix-shell --run pycharm-community"
    elif [ "$1" = "emacs" ]; then
	eval "nix-shell --run emacs"
    elif [ "$1" = "code" ]; then
        eval "nix-shell --run code"
    fi
    # Verify postgres is running
    echo $(ps -ef | grep -E [p]ostgresql)
}

function Stop()
{
    cd $WORK_DIR
    # start the database
    eval "nix-shell --run \"${POSTGRES} stop\""
    eval "killall code"
    eval "killall python"
    echo $(ps -ef | grep -E [p]ostgresql)
}
############################################################
############################################################
# Main program                                             #
############################################################
############################################################
############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":hgnvV:" option; do
    case $option in
	h) # display Help
            Help
            exit;;
	g) # Print GPL
	    echo -ne "\a"
	    echo -e $(cat $GPL)
	    exit;;
	n) # Enter a name
	    Name=$OPTARG
            echo "Hello $Name!";;
	\?) # Invalid option
            echo -ne "Error: Invalid option: "
	    echo -e $option
            exit;;
    esac
done

if [ "${1}" = "start" ]; then
    Start #Shell function
elif [ "${1}" = "stop" ]; then
    Stop #Shell function
elif [ "${1}" = "pycharm" ]; then
    Start pycharm #function argument
elif [ "${1}" = "emacs" ]; then
    Start emacs #function argument
elif [ "${1}" = "code" ]; then
    Start code #function argument
else
    echo -ne "\a" #Bell if there is no argument
    echo "No correct argument found."
    echo "$1"
fi
