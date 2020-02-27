#!/bin/sh

username=$(git config user.username)
name=$(git config user.name)
token=$(git config user.token)
reponame=""
description=""
nargs=$#
flag=$1
url="HTTPS"
var=:
ans=""
new_repo=""
public="true"
desc=""
n=0

usage(){
printf "
Syntax: git-create [-flag] [-required] [-optional] 

Flag -n:
	-n or --new to create a empty repository with README
Required:
	-name or --repo_name is required for creating a new repository
Optional:
	-d or --description is optional, and it will be the repository name by default 

	-priv or --private will make the repository private (by default false)

	-ssh or --SSH wil change the repository URL, and the URL are https by default
		
Flag -h for help

"
	exit 1
}
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

create_repo(){

	echo Description : $description
	echo Repository name : $reponame
	echo Public : $public
	echo url : $url

	LINK=https://github.com/${username}/${reponame}.git
	curl -u ${username}${var}${token} https://api.github.com/user/repos -d "{\"name\":\"${reponame}\", \"description\":\"${description}\", \"public\":\"${public}\"}"


	submod=""

	if [ -d .git ]; then
	echo You are currently inside a git repository, do you want to add this folder as a submodule?"(y/n)"
	recive_answer "Yy" "Nn" "y" "" "Please answer yes(y) or no(n)"
	submod=$ans

	fi
	git clone ${LINK}
	cd $reponame
	echo "# ${description}" >> README.md
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

	if [ $url = "SSH" ] || [ $url = "ssh" ]; then
		git remote set-url origin git@github.com:${username}/${reponame}
	fi
}

verify(){

	if [ -z "$username" ] && [ -z "$name" ];then
		echo Missing git config name, enter github user name:
		read username
	fi

	if [ ! -z "$username" ] && [ ! -z "$name" ];then
		echo Found two names in the gitconfig which is the github userename: 
		echo $username"(1)" $name"(2)"

		recive_answer 1 2 "$username" "$name" "Please choose option 1 or 2"
		username=$ans
	fi

	if [ -z "$username" ];then
		username=$name
	fi


	name_taken=$(git ls-remote https://github.com/${username}/${reponame}.git 2> /dev/null)

	if [ ! -z "$name_taken" ];then
		echo This repository name is taken
		exit 1
	fi

	if [  -z $token ];then
		echo Token not found "\n"proceeding...
		var=""
	fi
	create_repo
}

parse_description(){
	exit=0
	while [ "$1" != "" ]; do
		case $1 in 
			-name | --repo_name) exit=1 break;;

			-priv | --private) exit=1 break;;

			-ssh | --SSH) exit=1 break;;

			-h | --help ) exit=1 break;;

			* ) desc="$desc $1";;
		esac
		shift
		n=$((n+1))
	done

	if [ $exit = 0 ]; then
		usage
	fi
}

if [ $nargs = 0 ]; then
	usage
fi

while [ "$1" != "" ]; do
	case $1 in
		-n | --new) new_repo=1 ;;

		-name | --repo_name) shift; reponame=$1;;

		-d | --description) shift; parse_description $@; description=$desc; shift $n;;

		-priv | --private) public="false";;

		-ssh | --SSH) url="ssh";;
		
		-h | --help ) usage;;

		* ) usage;;

	esac
	shift
done


if [ $new_repo = 1 ] && [  ! -z "$reponame" ]; then
	if [ -z "$description" ]; then
		description=$reponame
	fi
	verify
fi
