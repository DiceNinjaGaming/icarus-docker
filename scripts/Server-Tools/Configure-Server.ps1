$configFolder = '/app/saves/Saved/Config/WindowsServer/'
$serverSettingsFile = "ServerSettings.ini"

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

  $serverSettingsFilePath = Join-Path $configFolder $serverSettingsFile

  if (-Not (Test-Path $serverSettingsFilePath))
  {
    Write-Output "Server settings file doesn't exist, creating it now"
    New-Item $serverSettingsFilePath
  }
  if (-Not ((Get-Content $serverSettingsFilePath) -match '[/Script/Icarus.DedicatedServerSettings]'))
  {
    Write-Output "Server settings file does not include DedicatedServerSettings section, creating it now"

    "[/Script/Icarus.DedicatedServerSettings]" | Out-File $serverSettingsFilePath -Append
    "SessionName=$env:SERVER_NAME" | Out-File $serverSettingsFilePath -Append
    "JoinPassword=$env:SERVER_PASSWORD" | Out-File $serverSettingsFilePath -Append
    "MaxPlayers=$env:MAX_PLAYERS" | Out-File $serverSettingsFilePath -Append
    "AdminPassword=$env:ADMIN_PASSWORD" | Out-File $serverSettingsFilePath -Append
    "ShutdownIfNotJoinedFor=$env:SHUTDOWN_IF_NOT_JOINED_FOR" | Out-File $serverSettingsFilePath -Append
    "ShutdownIfEmptyFor=$env:SHUTDOWN_IF_EMPTY_FOR" | Out-File $serverSettingsFilePath -Append
    "AllowNonAdminsToLaunchProspects=$env:ALLOW_NON_ADMINS_LAUNCH" | Out-File $serverSettingsFilePath -Append
    "AllowNonAdminsToDeleteProspects=$ALLOW_NON_ADMINS_DELETE" | Out-File $serverSettingsFilePath -Append
    "LoadProspect=$env:LOAD_PROSPECT" | Out-File $serverSettingsFilePath -Append
    "CreateProspect=$env:CREATE_PROSPECT" | Out-File $serverSettingsFilePath -Append
    "ResumeProspect=$env:RESUME_PROSPECT" | Out-File $serverSettingsFilePath -Append
  }

  Write-Output "Updating server settings"
  sed -i "/SessionName=/c\SessionName=$env:SERVER_NAME" $serverSettingsFilePath
  sed -i "/JoinPassword=/c\JoinPassword=$env:SERVER_PASSWORD" $serverSettingsFilePath
  sed -i "/MaxPlayers=/c\MaxPlayers=$env:MAX_PLAYERS" $serverSettingsFilePath
  sed -i "/AdminPassword=/c\AdminPassword=$env:ADMIN_PASSWORD" $serverSettingsFilePath
  sed -i "/ShutdownIfNotJoinedFor=/c\ShutdownIfNotJoinedFor=$env:SHUTDOWN_IF_NOT_JOINED_FOR" $serverSettingsFilePath
  sed -i "/ShutdownIfEmptyFor=/c\ShutdownIfEmptyFor=$env:SHUTDOWN_IF_EMPTY_FOR" $serverSettingsFilePath
  sed -i "/AllowNonAdminsToLaunchProspects=/c\AllowNonAdminsToLaunchProspects=$env:ALLOW_NON_ADMINS_LAUNCH" $serverSettingsFilePath
  sed -i "/AllowNonAdminsToDeleteProspects=/c\AllowNonAdminsToDeleteProspects=$env:ALLOW_NON_ADMINS_DELETE" $serverSettingsFilePath
  sed -i "/LoadProspect=/c\LoadProspect=$env:LOAD_PROSPECT" $serverSettingsFilePath
  sed -i "/CreateProspect=/c\CreateProspect=$env:CREATE_PROSPECT" $serverSettingsFilePath
  sed -i "/ResumeProspect=/c\ResumeProspect=$env:RESUME_PROSPECT" $serverSettingsFilePath

}