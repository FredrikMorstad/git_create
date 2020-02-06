#!/bin/sh

ROOT=$(pwd)
RC=.bashrc
FILE=git_create.sh

cp ${ROOT}/${FILE} ${HOME}
echo ${ROOT}/${FILE} ${HOME}

cd
CURRENTDIR=$(pwd)

# find . -maxdepth 1 -name $RC

PATH=${CURRENTDIR}/${FILE}

echo $(pwd)
echo $FILE

/bin/cat >> $RC <<EOF

alias git-create="./$FILE"

EOF
