#!/bin/bash

ROOT=$(pwd)
RC=.bashrc
FILE=git_create.sh

cp ${ROOT}/${FILE} ${HOME}

cd

mv git_create.sh .git_create.sh

FILE=.git_create.sh

CURRENTDIR=$(pwd)

PATH=${CURRENTDIR}

/bin/cat >> $RC <<EOF
alias git-create="./$FILE"
EOF

#not working for some reason
# $(source ~/.bashrc)
# $exec $bash
# $reload
