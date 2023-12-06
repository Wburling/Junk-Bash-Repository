#!/bin/bash

# Author Wyatt Burlingame

# echo 'Hello' > test1
# echo 'Hello' > test2
# echo 'Hi there' > test3
# mkdir junk
# cp -r test* junk/

if [ ! -d "$HOME/.junk" ]; then
    mkdir "$HOME/.junk"
    echo "Created a new .junk directory!"
fi

file="$1"
recover="$2"

# This is to recover the file if it has been junked
if [ "$file" == "-r" ]; then
    # This recovers all files if nothing is specified
    if [ -z "$recover" ]; then
        cp $HOME/.junk/* $PWD
        exit 1
    fi
    if [ -e "$recover" ]; then
        echo file already exist...
        echo Would you like to overide? Y/n
        read answer
        if [ $answer == 'y' ] || [ $answer == 'Y' ]; then
            cp "$HOME/.junk/$recover" "$PWD"
            exit 1
        else
            exit 1
        fi

    else
        cp "$HOME/.junk/$recover" "$PWD"
        exit 1
    fi
fi
# This is if you want to empty the junk folder.
if [ "$file" == "-e" ]; then
    rm $HOME/.junk/*
    exit 1
fi
# This is to see what files are in junk
if [ "$file" == "-l" ]; then
    ls "$HOME/.junk"
    exit 1
fi
# This is if you want to junk a file
if [ -a "$file" ]; then
    # mv "$file" "$PWD/.junk"

    destination="$HOME/.junk/$file"
    count=1

    while [ -e "$destination" ]; do
        # This is if the content is the same then overide
        if cmp -s $file $destination; then
            mv "$file" "$destination"
            exit 1
        fi
        # this adds the version to the file if they dont have the same content.
        destination="$HOME/.junk/$file.$count"
        count=$((count + 1))
    done

    mv "$file" "$destination"
fi
