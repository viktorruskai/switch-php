#!/bin/bash

if [[ $(command -v brew) == "" ]]; then
    echo -e "\033[1;31mYou need to install Homebrew!\033[0m"
    exit 1
fi

version="php@$1"

#Check for input
if ! [[ $1 =~ ^[0-9.]+$ ]]; then
   echo -e "\033[1;31mEnter correct version number.\033[0m"
   exit 1
fi

#Check if version is installed in computer
if [[ -z "$(brew ls --versions "${version}")" ]]; then
  echo -e "\033[1;31mThis version is not installed on your computer.\033[0m"
  exit 1;
fi

#List all php versions and unlink them
installed_php_versions=($(brew ls --versions | grep "php" | cut -d " " -f 1));

if ! [ ${#installed_php_versions[@]} -eq 0 ]; then
  echo -e "\033[1;33mUnlinking other php versions...\033[0m"

  for php_version in "${installed_php_versions[@]}"; do
    brew unlink "${php_version}"
  done

  if [ $? -eq 1 ]; then
    exit 1;
  fi
fi

echo -e "\033[1;33mLink wanted php version...\033[0m"
#Link user's php version  with --force parameter
brew link --force "${version}"

#Show `php -v`
php -v
