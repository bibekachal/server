#!/bin/bash
#Two parameters will always be there so there is no check, and one will be username and another will be the password
#Add the user into the system creating the home directory as well (-m); this also creates the users's group with the name of the username

#Script to add user

read -p 'Write username: ' username
#read -sp 'Write password: ' password

useradd $username -p -m
passwd $username



