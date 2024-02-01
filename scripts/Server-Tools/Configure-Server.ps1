$configFolder = '/app/saves/Saved/Config/WindowsServer/'

function Configure-Server
{
    if (-not (Test-Path $configFolder))
    {
        Write-Output "Config folder doesn't exist, creating it now"
        New-Item $configFolder -ItemType Directory
    }
  $engineIniFile = Join-Path $configFolder "Engine.ini"
  if (-Not (Test-Path $engineIniFile))
  {
    Write-Output "Engine.ini doesn't exist, creating it now"
    New-Item $engineIniFile
    "[OnlineSubsystemSteam]" | Out-File $engineIniFile
    "AsyncTaskTimeout=$env:STEAM_ASYNC_TIMEOUT" | Out-File $engineIniFile -Append
  }
  else 
  {
    Write-Output "Updating Steam Async settings"
    sed -i "/AsyncTaskTimeout=/c\AsyncTaskTimeout=$env:STEAM_ASYNC_TIMEOUT" $engineIniFile
  }

  $serverSettingsFile = Join-Path $configFolder "ServerSettings.ini"

  if (-Not (Test-Path $serverSettingsFile))
  {
    Write-Output "Server settings file doesn't exist, creating it now"
    New-Item $serverSettingsFile
  }
  if (-Not ((Get-Content $serverSettingsFile) -match '[/Script/Icarus.DedicatedServerSettings]'))
  {
    Write-Output "Server settings file does not include DedicatedServerSettings section, creating it now"

    "[/Script/Icarus.DedicatedServerSettings]" | Out-File $serverSettingsFile -Append
    "SessionName=$env:SERVER_NAME" | Out-File $serverSettingsFile -Append
    "JoinPassword=$env:SERVER_PASSWORD" | Out-File $serverSettingsFile -Append
    "MaxPlayers=$env:MAX_PLAYERS" | Out-File $serverSettingsFile -Append
    "AdminPassword=$env:ADMIN_PASSWORD" | Out-File $serverSettingsFile -Append
    "ShutdownIfNotJoinedFor=$env:SHUTDOWN_IF_NOT_JOINED_FOR" | Out-File $serverSettingsFile -Append
    "ShutdownIfEmptyFor=$env:SHUTDOWN_IF_EMPTY_FOR" | Out-File $serverSettingsFile -Append
    "AllowNonAdminsToLaunchProspects=$env:ALLOW_NON_ADMINS_LAUNCH" | Out-File $serverSettingsFile -Append
    "AllowNonAdminsToDeleteProspects=$ALLOW_NON_ADMINS_DELETE" | Out-File $serverSettingsFile -Append
    "LoadProspect=$env:LOAD_PROSPECT" | Out-File $serverSettingsFile -Append
    "CreateProspect=$env:CREATE_PROSPECT" | Out-File $serverSettingsFile -Append
    "ResumeProspect=$env:RESUME_PROSPECT" | Out-File $serverSettingsFile -Append
  }

  Write-Output "Updating server settings"
  sed -i "/SessionName=/c\SessionName=$env:SERVER_NAME" $serverSettingsFile
  sed -i "/JoinPassword=/c\JoinPassword=$env:SERVER_PASSWORD" $serverSettingsFile
  sed -i "/MaxPlayers=/c\MaxPlayers=$env:MAX_PLAYERS" $serverSettingsFile
  sed -i "/AdminPassword=/c\AdminPassword=$env:ADMIN_PASSWORD" $serverSettingsFile
  sed -i "/ShutdownIfNotJoinedFor=/c\ShutdownIfNotJoinedFor=$env:SHUTDOWN_IF_NOT_JOINED_FOR" $serverSettingsFile
  sed -i "/ShutdownIfEmptyFor=/c\ShutdownIfEmptyFor=$env:SHUTDOWN_IF_EMPTY_FOR" $serverSettingsFile
  sed -i "/AllowNonAdminsToLaunchProspects=/c\AllowNonAdminsToLaunchProspects=$env:ALLOW_NON_ADMINS_LAUNCH" $serverSettingsFile
  sed -i "/AllowNonAdminsToDeleteProspects=/c\AllowNonAdminsToDeleteProspects=$env:ALLOW_NON_ADMINS_DELETE" $serverSettingsFile
  sed -i "/LoadProspect=/c\LoadProspect=$env:LOAD_PROSPECT" $serverSettingsFile
  sed -i "/CreateProspect=/c\CreateProspect=$env:CREATE_PROSPECT" $serverSettingsFile
  sed -i "/ResumeProspect=/c\ResumeProspect=$env:RESUME_PROSPECT" $serverSettingsFile

}