#!/bin/bash
#


read -p "enter new $username: " username

echo "you entered a new $username"

sudo useradd -m $username

echo "new user is added as $username"
