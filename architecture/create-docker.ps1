# Windows PowerShell Script
$ErrorActionPreference = "Stop"

# Go to current location
$CURRENT_FOLDER=(Get-Location)
Set-Location (Split-Path $MyInvocation.Line -Parent)
Set-Location ../

# Parameters Dockers
$ENV_TYPE="docker"
$ENV_DOCKER_PORT_START=0
$ENV_DOCKER_IP="127.0.10.3"

# Parameters Generic
$ENV_NAME="symfonydemo"
$ENV_HOST="$ENV_NAME.lxc"
$ENV_IP="$ENV_DOCKER_IP"
$ENV_SSH_PORT=(22 + $ENV_DOCKER_PORT_START)
$ENV_MODE="dev"
$ENV_CODE="dev"
$ENV_USER="delivery"
$ENV_FOLDER="/var/www/$ENV_NAME"
$WEB_FOLDER="website"

# Parameters SSH
If (Test-Path ~/.ssh/id_ed25519.pub) {
    $SSH_PUB=(Get-Content ~/.ssh/id_ed25519.pub)
} else {
    $SSH_PUB=(Get-Content ~/.ssh/id_rsa.pub)
}

# Replace Function
function ReplacePattern($FILE, $FROM, $TO)
{
    Get-Content $FILE | ForEach-Object { $_ -replace "$FROM","$TO" } | Set-Content -Path "$FILE.tmp"
    Remove-Item $FILE
    Move-Item "$FILE.tmp" $FILE
}

# Prepare the VM files
Write-Output "DOCKER - Prepare Files"
If (Test-Path ./architecture/vm) {
    Remove-Item -Recurse -Force ./architecture/vm
}
Copy-Item -Recurse ./architecture/conf/template/vm ./architecture/vm
Get-ChildItem ./architecture/vm/ -File -Recurse | ForEach-Object {
    $FILE=$_.FullName
    ReplacePattern $FILE "{{ENV_NAME}}"                  $ENV_NAME
    ReplacePattern $FILE "{{ENV_USER}}"                  $ENV_USER
    ReplacePattern $FILE "{{ENV_DOCKER_IP}}"             $ENV_DOCKER_IP
    ReplacePattern $FILE "{{ENV_DOCKER_PORT_HTTP}}"      ($ENV_DOCKER_PORT_START + 80)
    ReplacePattern $FILE "{{ENV_DOCKER_PORT_HTTPS}}"     ($ENV_DOCKER_PORT_START + 443)
    ReplacePattern $FILE "{{ENV_DOCKER_PORT_SSH}}"       ($ENV_DOCKER_PORT_START + 22)
    ReplacePattern $FILE "{{ENV_DOCKER_PORT_MAILDEV}}"   ($ENV_DOCKER_PORT_START + 1080)
}
Remove-Item -Recurse -Force ./architecture/vm/docker/start.sh
Copy-Item -Recurse ./architecture/conf/template/vm/docker/start.sh ./architecture/vm/docker/start.sh

# Create Container
Write-Output "DOCKER - Create"
cd ./architecture/vm
docker-compose down -v
docker-compose build --build-arg ssh_pub_key="$SSH_PUB" $ENV_NAME
docker-compose up -d
if ($lastexitcode -ne 0) {
    Set-Location $CURRENT_FOLDER
    throw ("Error " + $lastexitcode)
}
cd ../..

Write-Output "DOCKER - Clean"
If (Test-Path ./$WEB_FOLDER/var) {
    Remove-Item -Recurse -Force ./$WEB_FOLDER/var
}

Write-Output "DOCKER - Prepare All"

ssh root@$ENV_HOST -p $ENV_SSH_PORT $ENV_FOLDER/architecture/scripts/prepare-all.sh "$ENV_TYPE"

Write-Output "DOCKER - Finished"

# Restore the current location
Set-Location $CURRENT_FOLDER
