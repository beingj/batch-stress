#!/bin/bash
rm -rf /root/.ssh
mkdir -p /root/.ssh
chmod 700 /root/.ssh
cd /root/.ssh
rm -rf ./*

# hit return for any prompts
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cd /root/.ssh
cp id_rsa.pub authorized_keys
echo "StrictHostKeyChecking=no" >config
