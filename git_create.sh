#!/bin/sh

USERNAME=$(git config user.name)
TOKEN=$(git config user.token)
REPONAME=""
DESCRIPTION=""
PRIVATE=""
NARGS=$#
FLAG=$1

if [ $NARGS != 1 ] && [ $NARGS != 4 ];then
	echo Wrong use of git create, try -h for help
	exit 1
fi

if [ $FLAG = "-h" ];then
	echo git create is dependent on a working git config
	echo Synyax for git create:"\n"
	echo git create [-flag] [repo name] [description] [private] "\n"
	echo -flag:"\n"-n "->" create a new git repository 
	exit 1
fi

if [ $FLAG = "-n" ];then
	if [ $NARGS != 4 ];then
		echo missing arguments
		exit 1
	fi

	echo Gathering information...

	if [ -z $USERNAME ];then
		echo Missing git config name, enter github user name:
		read USERNAME
	fi
	echo Github username : $USERNAME

	if [ -z $TOKEN ];then
		echo Token not found "\n"proceeding...
	fi

	REPONAME=$2
	echo Repository name : $REPONAME
	DESCRIPTION=$3
	echo Description : $DESCRIPTION
	PRIVATE=$4
	echo Private : $PRIVATE
fi
LINK=https://github.com/${USERNAME}/${REPONAME}.git
curl -u ${USERNAME}:${TOKEN} https://api.github.com/user/repos -d "{\"name\":\"${REPONAME}\", \"description\":\"${DESCRIPTION}\", \"private\":\"${PRIVATE}\"}"
git clone ${LINK}
cd $2
echo "# test" >> README.md
git init
git add README.md
git commit -m "first commit"
git remote add origin ${LINK}
git push -u origin master


