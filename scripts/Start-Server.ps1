Import-Module /scripts/Server-Tools/Server-Tools.psm1 -Force
$serverLauncherPath=(Join-Path '/app/server/icarus/Icarus/Binaries/Win64/' 'IcarusServer-Win64-Shipping.exe')

Start-Sleep 10 # Delay initial startup to give the updater time to start
$copyConfigs = $true

While (RunServer)
{
  If (-Not (UpdateRunning))
  {
    if (Test-Path $serverLauncherPath)
    {
      $args=""
      
      # We only want to copy the configs the first time the container starts
      if ($copyConfigs)
      {
        Copy-Configs
        Configure-Server
        $copyConfigs = $false
      }
      & wine $serverLauncherPath -Log -UserDir="/app/saves" -SteamServerName="${$env:SERVER_PROCESS_NAME}" -PORT="${$env:SERVER_PORT}" -QueryPort="${$env:QUERY_PORT}" -JoinPassword="${$env:SERVER_PASSWORD}" $args
    } # if (Test-Path $serverLauncherPath)
  }
  else
  {
    Start-Sleep 5
  } # If (-Not (UpdateRunning)
} # While (RunServer)