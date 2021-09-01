#!/bin/sh
cd sample-mvc
if ! [ -d .git ]; then
   git init -q;
fi;

if [ $# -eq 0 ]
then
  url=$(git config --get remote.origin.url)
  if [ -z "$url" ]
  then
    read -p "Enter your github repository url: " url
    git remote add origin --master main $url
  fi
 else
   url=$1
   git remote add origin --master main $url
fi

echo "Your repository is: $url"
git add .
git commit -m "sh commit"
echo "git commit"
git branch -M main
git push -f origin main
echo "done"
echo "Press enter to continue . . ."
read