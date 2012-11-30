#!/bin/bash

ProgName=$(basename $0)

sub_help(){
    echo "Usage: $ProgName <subcommand> [options]\n"
    echo "Subcommands:"
    echo "    deploy   Deploy changes to gh-pages branch"
    echo "    setupenv Setup working environment"
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
    echo "Running deploy..."
    git subtree split --branch gh-pages --prefix _deploy/
    exit $?
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
