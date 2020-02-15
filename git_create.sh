#!/bin/sh

USERNAME=$(git config user.username)
NAME=$(git config user.name)
TOKEN=$(git config user.token)
REPONAME=""
DESCRIPTION=""
NARGS=$#
FLAG=$1
URL="HTTPS"
var=:

if [ $NARGS != 1 ] && [ $NARGS != 5 ] && [ $NARGS != 4 ];then
	echo Wrong use of git create, try -h for help
	exit 1
fi

if [ $FLAG = "-h" ];then
	echo git create is dependent on a working git config
	echo Syntax for git create:"\n"
	echo git create [-flag] [repo name] [description] [public"(y/n)"] [ssh "(optional)"]"\n"
	echo -flag:"\n"-n "->" create a new git repository 
	exit 1
fi

if [ $FLAG = "-n" ];then
	if [ $NARGS != 4 ] && [ $NARGS != 5 ];then
		echo missing arguments
		exit 1
	fi

	echo Gathering information...

	if [ -z "$USERNAME" ] && [ -z "$NAME" ];then
		echo Missing git config name, enter github user name:
		read USERNAME
	fi

	if [ ! -z "$USERNAME" ] && [ ! -z "$NAME" ];then
		echo Found two names in the gitconfig which is the github userename: 
		echo $USERNAME"(1)" $NAME"(2)"
		read option
		while true; do
    		case $option in
        		[1]* ) break;;
        		[2]* ) USERNAME=$NAME break;;
				* ) echo "Please choose option 1 or 2 "; read option; continue;
    		esac
		done

	fi

	if [ -z "$USERNAME" ];then
		USERNAME=$NAME
	fi

	REPONAME=$2
	VERIFY=$(git ls-remote https://github.com/${USERNAME}/${REPONAME}.git 2> /dev/null)
	echo $verify

	if [ ! -z "$VERIFY" ];then
		echo This repository name is taken
		exit 1
	fi

	echo Github username : $USERNAME

	if [  -z $TOKEN ];then
		echo Token not found "\n"proceeding...
		var=""
	fi

	yn=$4
	while true; do
    	case $yn in
        	[Yy]* ) yn="true" break;;
        	[Nn]* ) yn="false" break;;
			* ) echo "Please answer if you want public repo. (y/n)"; read yn; continue;
    	esac
	done

	if [ $NARGS = 5 ]; then
		URL=$5
		while true; do
			case $URL in
				SSH|ssh ) URL="SSH" break;;
				HTTPS|https ) URL="HTTPS" break;;
				* ) echo "Please answer which URL you want (ssh/https)"; read URL; continue;
			esac
		done	
			
	fi

	echo Repository name : $REPONAME
	DESCRIPTION=$3
	echo Description : $DESCRIPTION
	PUBLIC=$yn
	echo Public : $PUBLIC
	echo URL : $URL
fi

LINK=https://github.com/${USERNAME}/${REPONAME}.git
curl -u ${USERNAME}${var}${TOKEN} https://api.github.com/user/repos -d "{\"name\":\"${REPONAME}\", \"description\":\"${DESCRIPTION}\", \"public\":\"${PUBLIC}\"}"
git clone ${LINK}
cd $2
echo "# ${DESCRIPTION}" >> README.md
git init
git add README.md
git commit -m "first commit"
git remote add origin ${LINK}
git push -u origin master

if [ $URL = "SSH" ] || [ $URL = "ssh" ]; then
	git remote set-url origin git@github.com:${USERNAME}/${REPONAME}
fi

