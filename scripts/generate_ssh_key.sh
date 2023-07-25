#!/bin/bash
OUTPUT_FOLDER=ssh
SSH_KEY=id_rsa
SSH_PUB=id_rsa.pub
echo "Output will be found at -> $PWD/$OUTPUT_FOLDER"
mkdir -p $OUTPUT_FOLDER

if [ -f "$OUTPUT_FOLDER/$SSH_KEY" ]; then
    echo "SSH key exists, skipping generate SSH key"
else
    echo "===== Generate SSH key pair"
    ssh-keygen -t rsa -b 4096 -C devops@selex.vn -f $OUTPUT_FOLDER/$SSH_KEY

    echo "===== Generated!"
fi
