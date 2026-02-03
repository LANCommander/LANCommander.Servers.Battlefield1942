#Requires -Modules Logging
#Requires -Modules Hooks

Invoke-Hook "PreInstallBattlefield1942"

Write-Log -Message "Installing Battlefield 1942 v1.6.19 dedicated server"

if (-not (Test-Path -Path "${Env:SERVER_DIR}/bf1942_lnxded.static")) {
    Write-Log "Could not find Battlefield 1942 server in ${Env:SERVER_DIR}, proceeding with installation."

    $downloadUrl = $Env:BF1942_SERVER_URL

    curl -L --output /tmp/bf1942.zip "$downloadUrl"

    unzip /tmp/bf1942.zip -d $Env:SERVER_DIR

    chmod +x "${Env:SERVER_DIR}/bf1942_lnxded.static"
} else {
    Write-Log "Battlefield 1942 dedicated server already installed in ${Env:SERVER_DIR}, skipping installation."
}

if (-not (Test-Path -Path "${Env:SERVER_DIR}/bf1942_lnxded")) {
    Copy-Item "${Env:SERVER_DIR}/bf1942_lnxded.static" "${Env:SERVER_DIR}/bf1942_lnxded"
    chmod +x "${Env:SERVER_DIR}/bf1942_lnxded"
}

Write-Log -Message "Battlefield 1942 dedicated server installation complete."

Invoke-Hook "PostInstallBattlefield1942"

Set-Location $Env:SERVER_ROOT