#!/bin/bash

root=$(pwd)
rcfile=.bashrc
file=git_create.sh

cp ${root}/${file} ${HOME}

cd

mv git_create.sh .git_create.sh

file=.git_create.sh

currentdir=$(pwd)

a=${currentdir}

if ! (grep "alias git-create="\"${currentdir}/$file"" ${rcfile} >/dev/null); then
echo adding alias in bashrc...
cat >> $rcfile <<EOF
alias git-create="${currentdir}/${file}"
EOF

fi

#not working for some reason
# source ~/.bashrc
# exec $bash
# . ~/.bashrc
cd $root
bash
