#!/bin/bash
#
#

create_directory(){
     mkdir demo
}


if ! create_directory; then
    echo "the code is being exited as the directory already exists"
    exit 1
fi

echo "the code is working because this first time running it"


