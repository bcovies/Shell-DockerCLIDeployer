#!/bin/bash

# basic variables
SCRIPT_COLLUMNS=$1
SCRIPT_MIDDLE_OF_SCREEN=$2
# all services variables
APP_NAME=$3

entry_screen() {
    echo -e "############################"
    echo -e "######  SCRIPT STATUS  #####"
    echo -e "############################"
}
nodes_screen() {
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo
    docker node ls
    for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "="; done
    echo
}
stack_screen() {
    echo -e "\tStack Name ---> $APP_NAME"
    docker node ls --format "{{.Hostname}}" | while read ENTRY_NODE; do
        for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "+"; done
        echo "Node Name: ${ENTRY_NODE}"
        for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "+"; done
        OUTPUT_LINES=$(DOCKER_HOST=${ENTRY_NODE} docker ps -a --no-trunc -f name=$APP_NAME | wc -l)
        if [[ $OUTPUT_LINES != 1 ]]; then
            for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "+"; done
            DOCKER_HOST=${ENTRY_NODE} docker ps -a --format "$(tput setaf 4)\nImage:\t{{.Image}}\nID:\t{{.ID}}\nName:\t{{.Names}}\nStatus:\t{{.Status}}\nPorts:\t{{.Ports}}\nState:\t{{.State}}\nNetworks:\t{{.Networks}}\nMounts:\t{{.Mounts}}\nLabels:\t{{.Labels}}\nSize:\t{{.Size}}\nRunningFor:\t{{.RunningFor}}\nCreatedAt:\t{{.CreatedAt}}\nCommand:\t{{.Command}}\nMount:\t{{.Mounts}}\nRunning:\t{{.RunningFor}}$(tput sgr0)" --no-trunc -f name=$APP_NAME
            for ((i = 0; i < $SCRIPT_COLLUMNS; i++)); do printf "+"; done
        fi
    done
}

entry_screen
nodes_screen
stack_screen
