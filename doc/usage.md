# Usage

## Dev Environment

| Site | Url | Comment |
|------|-----|---------|
| Web     | https://symfonydemo.lxc/     | Personal account must be used for log-in | 
| MailDev | http://symfonydemo.lxc:1080/ |  |

You can use LXC, LXD, or Docker technology.

### LXC

```bash
# Create the dev env
./architecture/create-lxc.sh

# Remove the dev env
./architecture/remove-lxc.sh
```

### LXD

```bash
# Create the dev env
./architecture/create-lxd.sh

# Remove the dev env
./architecture/remove-lxd.sh
```

### Docker

```bash
# Create the dev env
./architecture/create-docker.sh

# Start the dev env
./architecture/start-docker.sh

# Remove the dev env
./architecture/remove-docker.sh
```

If needed, you can create the file `architecture/conf/env.local.sh` and put the following content (for MacOS for example):

```bash
#!/bin/bash

# Docker Parameters
ENV_DOCKER_IP="127.0.0.1"
ENV_DOCKER_PORT_START="20000"
```

On windows, use the following script to create the env:

```bash
./architecture/create-docker.ps1
```

Then, use `docker-compose` in the `./architecture/vm/` folder to up, down, start, stop your container.
