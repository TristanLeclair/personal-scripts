#!/bin/bash

Description="Description: Script to create a directory structure for a new data science project"

usage() {
	echo $Description
	echo "Usage: $0 [-f project_name]"
	exit 0
}

if [[ ($@ == "--help") || $@ == "-h" ]]; then
	usage
fi

# Validate that first argument is passed
if [[ -z $1 ]]; then
	usage
else
	project_name=$1
fi

main() {

	echo "Creating directory structure..."

	mkdirs

	echo "Creating README.md..."

	create_files

	echo "Setting up python environment..."

	{
		README
		python_setup
	} >/dev/null 2>&1 &

	echo "Setting up git"

	gitignore
	git_init

	echo "Setting up gitignore..."
	echo "Setting up git..."
}

mkdirs() {
	mkdir $project_name
	cd $project_name
	mkdir -p {data,notebooks,src,scripts}
	mkdir -p data/{interim,processed,raw}
}

create_files() {
	touch requirements.txt
}

README() {
	git clone https://gist.github.com/TristanLeclair/c460062e8ccd2e528912f016db350595 tmp_readme
	mv tmp_readme/python_datascience_README.md README.md
	rm -rf tmp_readme
}

python_setup() {
	# check if conda is installed
	# if conda is installed, create conda environment
	# else create venv
	# install requirements.txt
	conda create --prefix ./venv
	conda activate ./venv
	conda install -r requirements.txt
}

gitignore() {
	echo "Creating .gitignore"
	echo '"Project specific ignores' >.gitignore
	echo 'data/raw/' >>.gitignore

	extensions="python,jupyer_notebook,visualstudiocode"
	if ! [ -x "$(command -v gi)" ]; then
		curl -sLw \"\\\n\" https://www.toptal.com/developers/gitignore/api/$extensions >>.gitignore
	else
		gi $extensions >>.gitignore
	fi
}

git_init() {
	git init
	sleep 2
	git add .
	git commit -m "Initial commit"
}

# {
main
# } > /dev/null 2>&1
