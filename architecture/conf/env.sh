#!/bin/bash

# Generic Parameters
ENV_NAME="symfonydemo"
ENV_HOST="${ENV_NAME}.lxc"
ENV_SSH_PORT="22"
ENV_MODE="dev"
ENV_USER=""
ENV_FOLDER="/var/www/$ENV_NAME"
WEB_FOLDER="website"

# Local Parameters (for docker, because it can depend on the host OS)
LOCAL_FILE="./architecture/conf/env.local.sh"
if [[ ! -f "${LOCAL_FILE}" ]]; then
    echo "#!/bin/bash"                  >  ${LOCAL_FILE}
    echo ""                             >> ${LOCAL_FILE}
    echo "# Docker Parameters"          >> ${LOCAL_FILE}
    echo "ENV_DOCKER_IP=\"127.0.50.1\"" >> ${LOCAL_FILE}
    echo "ENV_DOCKER_PORT_START=\"0\""  >> ${LOCAL_FILE}
fi
source ${LOCAL_FILE}

# We must provide a Env Type
if [[ -z "${ENV_TYPE}" ]]; then
    echo "ERROR - You must provide an Environment Type"
    exit 1
fi

# If it is not "none" => load the env file
if [[ "${ENV_TYPE}" != "none" ]]; then
    ENV_FILE="./architecture/conf/env_${ENV_TYPE}.sh"
    if [[ ! -f "${ENV_FILE}" ]]; then
        echo "ERROR - The Environment File \"${ENV_FILE}\" does not exist"
        exit 1
    fi

    source ${ENV_FILE}

    # Build the VM folder automatically
    if [[ -z "${ENV_DO_NOT_GENERATE}" ]]; then
        rm -rf ./architecture/vm
        cp -r  ./architecture/conf/template/vm ./architecture/vm

        FILES=`find ./architecture/vm/ -type f`
        for FILE in ${FILES}
        do
            sed -i "s/{{ENV_NAME}}/${ENV_NAME}/g"           ${FILE}
            sed -i "s/{{ENV_USER}}/${ENV_USER}/g"           ${FILE}
            sed -i "s/{{ENV_DOCKER_IP}}/${ENV_DOCKER_IP}/g" ${FILE}
            sed -i "s/{{ENV_DOCKER_PORT_HTTP}}/$(($ENV_DOCKER_PORT_START+80))/g"      ${FILE}
            sed -i "s/{{ENV_DOCKER_PORT_SSH}}/$(($ENV_DOCKER_PORT_START+22))/g"       ${FILE}
            sed -i "s/{{ENV_DOCKER_PORT_MAILDEV}}/$(($ENV_DOCKER_PORT_START+1080))/g" ${FILE}
        done
    fi
fi
