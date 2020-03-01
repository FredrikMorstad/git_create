#!/bin/bash


root=$(pwd)
rcfile=.bashrc
file=git_create.sh

bash_setup(){
	cp ${root}/bin/${file} ${HOME}

	cd

	echo Moving file to the home directory..;echo

	mv git_create.sh .git_create.sh

	file=.git_create.sh

	currentdir=$(pwd)

	if ! (grep "alias git-create="\"${currentdir}/$file"" ${rcfile} >/dev/null); then
		echo adding alias in bashrc...;echo

cat >> $rcfile <<EOF
	alias git-create="${currentdir}/${file}"
EOF
fi
	echo Looks like you already have a git-create alias;echo

	cd $root
	echo Reloading the bash files
	bash
	exit
}
shell_type="$SHELL"

if [ $shell_type = "/bin/bash" ];then
	bash_setup
else
	echo This script only supports bash	
fi
