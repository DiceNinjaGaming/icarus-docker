Import-Module /scripts/Server-Tools/Server-Tools.psm1 -Force -WarningAction SilentlyContinue
$serverLauncherPath=(Join-Path '/app/server/Icarus/Binaries/Win64/' 'IcarusServer-Win64-Shipping.exe')

Start-Sleep 10 # Delay initial startup to give the updater time to start
$copyConfigs = $true
$showUpdateMessage = $true
# $steamGroup = $env:GROUP_ID
# $steamUser = $env:USER_ID

Write-Output "--------------------------------------------"
Write-Output "Starting server"
Write-Output "${Get-Date}"
Write-Output "--------------------------------------------"

While (RunServer)
{
  If (-Not (UpdateRunning))
  {
    $showUpdateMessage = $true
    Write-Output "No updates are running, moving to next step"
    if (Test-Path $serverLauncherPath)
    {
      $serverArgs=""

      # Setting User ID
      # groupmod -g "${$steamGroup}" steam
      # usermod -u "${$steamUser}" -g "${$steamGroup}" steam
      
      # We only want to copy the configs the first time the container starts
      if ($copyConfigs)
      {
        Write-Output "Copying config files"
        Copy-Configs
        Configure-Server
        $copyConfigs = $false
      }

      # Write-Output "Initializing xvfb"
      # Xvfb :0 -screen 0 1024x768x16 &> /app/logs/xvfb.log  &

      Write-Output "--------------------------------------------"
      Write-Output "Initializing WINE"
      # sudo -u steam wineboot --init #> /dev/null 2>&1
      sudo wineboot --init #> /dev/null 2>&1
      # chown -R "${$steamUser}":"${$steamGroup}" /app/wine

      Write-Output "--------------------------------------------"
      Write-Output "Starting server with the following arguments:"
      Write-Output "Server Name: $env:SERVER_NAME"
      Write-Output "Port: $env:SERVER_PORT"
      Write-Output "Query Port: $env:QUERY_PORT"
      Write-Output "Additional Arguments (if any): $serverArgs"

      # sudo -u steam wine $serverLauncherPath -Log -UserDir="/app/saves" -SteamServerName="${$env:SERVER_NAME}" -PORT="${$env:SERVER_PORT}" -QueryPort="${$env:QUERY_PORT}" -JoinPassword="${$env:SERVER_PASSWORD}" $serverArgs
      # wine $serverLauncherPath -Log -UserDir="/app/saves" -SteamServerName="$env:SERVER_NAME" -PORT="$env:SERVER_PORT" -QueryPort="$env:QUERY_PORT" -JoinPassword="$env:SERVER_PASSWORD" $serverArgs
      wine $serverLauncherPath -Log -UserDir="/app/saves" $serverArgs
    } # if (Test-Path $serverLauncherPath)
    else
    {
      Write-Output "Unable to locate server executable: ${$serverLauncherPath}"
      StopServer
    }
  }
  else
  {
    if ($showUpdateMessage)
    {
      Write-Output "Update is currently running, will wait to start server until that completes"
      $showUpdateMessage = $false # Only show once
    }
    Start-Sleep 5
  } # If (-Not (UpdateRunning)
} # While (RunServer)