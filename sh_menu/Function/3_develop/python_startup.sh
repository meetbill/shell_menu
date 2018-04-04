#########################################################################
# File Name: pythonstartup.sh
# Author: 遇见王斌
# mail: meetbill@163.com
# Created Time: 2016-11-25 16:10:04
#########################################################################
#!/bin/bash

echo "import readline, rlcompleter" > ~/.pythonstartup.py
echo 'readline.parse_and_bind("tab: complete")' >> ~/.pythonstartup.py


if [[ -e ~/.bashrc ]]
then
    CK_BASH=`grep "PYTHONSTARTUP" ~/.bashrc | wc -l`
    if [[ "w${CK_BASH}" = "w0" ]]
    then
        echo " " >> ~/.bashrc
        echo "export PYTHONSTARTUP=~/.pythonstartup.py" >> ~/.bashrc
    fi 
else
    echo "export PYTHONSTARTUP=~/.pythonstartup.py" >> ~/.bashrc
fi
. ~/.bashrc

echo ":)"
