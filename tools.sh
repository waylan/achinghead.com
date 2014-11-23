#!/bin/bash

ProgName=$(basename $0)

sub_help(){
    echo "Usage: $ProgName <subcommand> [options]\n"
    echo "Subcommands:"
    echo "    deploy   Deploy changes to gh-pages branch"
    echo "    generate Generate site with changes made"
    echo "    new      Create a new empty post"
    echo "    setupenv Setup working environment"
    echo "    serve    Serve site locally for testing"
    echo ""
    #echo "For help with each subcommand run:"
    #echo "$ProgName <subcommand> -h|--help"
    #echo ""
}

sub_setupenv(){
    # Setup working environment
    if [ $1 ]; then
        # Use the env name provided in arg 1
        EnvName=$1
    else
        # No env name provided, use default
        EnvName="growl"
    fi
    if [ -d $WORKON_HOME/$EnvName ]; then
        echo "Environment '$EnvName' already exists." >&2
        echo "Run 'workon $EnvName' to use it." >&2
        exit 1
    else
        # set up a new env
        . virtualenvwrapper.sh
        mkvirtualenv -r requirements.txt $EnvName
        exit $?
    fi
}

sub_deploy(){
    # Deploy changes/additions to gh-pages branch
    while true; do
        read -p "Have all changes been commited to both _posts and _deploy? (yes/no): " yn
        case $yn in
            [Yy]* )
                git subtree split --branch gh-pages --prefix _deploy/
                exit $?
                ;;
            [Nn]* )
                echo "Please commit your changes first."
                exit
                ;;
            * )
                echo "Please answer yes or no."
                ;;
        esac
    done
}

sub_generate(){
    # Generate site with changes made.
    ./growl.py .
}

sub_serve(){
    # Serve site locally for testing and open browser
    ./growl.py --serve=8080 _deploy
    #& sleep 5 && gnome-open "http://localhost:8080"
}

sub_new(){
    # Create new post from template
    if [ $1 ]; then
        # Use the file name provided in arg 1
        FileName=$1
    else
        # No file name provided, prompt user
        read -p "Please provide a file name: " FileName
    fi
    Date=$(date "+%Y-%m-%d")
    PPath="_posts/$Date-$FileName.md"
    echo "Creating new post at '$PPath'..."
    cat > $PPath << EOF
---
layout: post
title: ""
author: Waylan Limberg
categories: ""
summary: "Enter summary here..."
---

Enter body here...
EOF
}

# Parse args and call subcommand
subcommand=$1
case $subcommand in
    "" | "-h" | "--help")
        sub_help
        ;;
    *)
        shift
        sub_${subcommand} $@
        if [ $? = 127 ]; then
            echo "Error: '$subcommand' is not a known subcommand." >&2
            echo "       Run '$ProgName --help' for a list of known subcommands." >&2
            exit 1
        fi
        ;;
esac
