#!/bin/bash
#!/bin/sh

ROOT=$(pwd)
RC=.bashrc
FILE=git_create.sh

cp ${ROOT}/${FILE} ${HOME}
# echo ${ROOT}/${FILE} ${HOME}

cd

mv git_create.sh .git_create.sh

FILE=.git_create.sh

CURRENTDIR=$(pwd)

PATH=${CURRENTDIR}

# echo $(pwd)
# echo $FILE
# echo $HOME

/bin/cat >> $RC <<EOF

alias git-create="./$FILE"

EOF

# $(source ~/.bashrc)
# $(. ~/.bashrc)
# # $(exec .bashrc)
