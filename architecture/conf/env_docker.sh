#!/bin/bash

ENV_TYPE="docker"
ENV_USER="delivery"

ENV_IP="${ENV_DOCKER_IP}"
ENV_SSH_PORT="$(($ENV_DOCKER_PORT_START+22))"
