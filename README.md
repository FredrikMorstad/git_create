# git_create

A script to create a git repository from the terminal  

To setup the file with alias run the setup file. This will bind the git_create script to git-create  

Syntax: git-create [-flag] [-required] [-optional]  
	Flag -n:  
		-n or --new to create a empty repository with README  
	Required:  
		-name or --repo_name is required for creating a new repository  
	Optional:  
		-d or --description is optional, and it will be the repository name by default  
		-priv or --private will make the repository private(by default false)  
		-ssh or --SSH wil change the repository URL, and the URL are https by default  
	Example:  
		git-create -n -name -d example example -priv -ssh  
		
Flag -h for help

