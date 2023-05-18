#!/bin/bash
#Two parameters will always be there so there is no check, and one will be username and another will be the password
#Add the user into the system creating the home directory as well (-m); this also creates the users's group with the name of the username

#Script to add user

read -p 'Write username: ' username
#read -sp 'Write password: ' password

echo

useradd $username -p -m
passwd $username

#Apend apache to the newly created user's group so that it has the write access to the user's directory
#Do not forget to apend the user to the existing group (-a), and (-G); note the uppercase G here
usermod -a -G $username apache

exit 0
