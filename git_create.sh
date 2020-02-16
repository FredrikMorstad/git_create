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
ans=""

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

# need to update the read value into the right value after the function call not pass ans value means to read input
recive_answer(){
	option1=$1
	option2=$2
	action1=$3
	action2=$4
	error_msg=$5
	ans=$6

	if [ -z "$ans" ];then
		read ans
	fi

	while true; do
		case $ans in 
			[$option1]* ) ans="$action1" break;;
			[$option2]* ) ans="$action2" break;;
			*) echo $error_msg; read ans; continue;
		esac
	done
}
 


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

		recive_answer 1 2 "$USERNAME" "$NAME" "Please choose option 1 or 2"
		USERNAME=$ans
	fi

	if [ -z "$USERNAME" ];then
		USERNAME=$NAME
	fi

	REPONAME=$2
	VERIFY=$(git ls-remote https://github.com/${USERNAME}/${REPONAME}.git 2> /dev/null)

	if [ ! -z "$VERIFY" ];then
		echo This repository name is taken
		exit 1
	fi

	echo Github username : $USERNAME

	if [  -z $TOKEN ];then
		echo Token not found "\n"proceeding...
		var=""
	fi

	ans=$4
	recive_answer "Yy" "Nn" "true" "false" "Please answer if you want public repository." "$ans"
	PUBLIC=$ans

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
	echo Public : $PUBLIC
	echo URL : $URL
fi

LINK=https://github.com/${USERNAME}/${REPONAME}.git
curl -u ${USERNAME}${var}${TOKEN} https://api.github.com/user/repos -d "{\"name\":\"${REPONAME}\", \"description\":\"${DESCRIPTION}\", \"public\":\"${PUBLIC}\"}"


submod=""

if [ -d .git ]; then
	echo You are currently inside a git repository, do you want to add this folder as a submodule?"(y/n)"
	recive_answer "Yy" "Nn" "y" "" "Please answer yes(y) or no(n)"
	submod=$ans
fi
git clone ${LINK}
cd $2
echo "# ${DESCRIPTION}" >> README.md
git init
git add README.md
git commit -m "first commit"
git remote add origin ${LINK}
git push -u origin master

if [ ! -z "$submod" ]; then
	echo adding submodule...
	cd ..
	git submodule add ${LINK}
	git add *
	git commit -m "submodule created"
	git push
fi

if [ $URL = "SSH" ] || [ $URL = "ssh" ]; then
	git remote set-url origin git@github.com:${USERNAME}/${REPONAME}
fi



