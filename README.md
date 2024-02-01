# Icarus Docker Dedicated Server
A Docker image for running an Icarus game server.

`THIS IS CURRENTLY WIP AND NOT READY FOR PRIMETIME USE`

# IMPORTANT INFO FOR FORKS
This section contains information related to creating forked repos for specific games. This section should be
removed after all the steps have been taken.

## Dockerfile Changes
1. Update the following environment variables:
    - STEAM_APPID
    - SERVER_PROCESS_NAME
    - SERVER_PORT
2. If using Wine, uncomment the section to install it
3. If not using mcRcon, remove the section that installs it

## Config-Tools.ps1 changes
1. Update the $destinationConfigDirectory variable to point to the config destination, if applicable
2. Update the $configFiles hash table to include the proper file names and paths
3. Update the `Copy-Configs` function to move the config file(s) to the proper location(s)

## Start-UpdateService.ps1 changes
1. If necessary, adjust the arguments in the `RunSteamCMD` function

## Update-ConfigFiles.ps1 changes
1. Update the config file updates as necessary

## Start-Server.ps1 changes
1. Update $serverLauncherPath to the correct path and file name

## Start-BackupService.ps1 changes
1. Update $saveLocation to point to the correct location of the save files

# System Requirements
| Name | Description |
| - | - |
| Processor | TBD |
| Memory | TBD |
| Storage | 20GB |
| Internet Connection | Broadband internet connection. Hosting from home will require the ability to configure port forwarding |

# Important folders
| Name | Description |
| - | - |
| /app/saves | Game Save files |
| /app/server | Game server files |
| /app/backups | Backup files |
| /app/logs | Logs for the various processes |
| /app/configs | Folder that contains the default configuration files. Custom configs can be placed here instead of defining settings changes in environment variables |

# Environment Variables
## General
| Name | Default | Description |
| ---------------- | ------- | ----------- |
| SERVER_NAME | Default Server Name | The name to be displayed in the server list |
| SERVER_PASSWORD | DefaultPassword | The password to be used for the server |
| ADMIN_PASSWORD | DefaultAdminPassword | The password to be used for admin access to the server (CHANGE THIS FROM THE DEFAULT) |
| SERVER_PORT | 17777 | The port to be used by the server |
| QUERY_PORT | 27015 | The query port to be used by the server browser |
| CREATE_PROSPECT | | Creates and launches a new prospect (Overrides RESUME_PROSPECT and LOAD_PROSPECT). [For more information on proper used, click here](https://github.com/RocketWerkz/IcarusDedicatedServer/wiki/Server-Config-&-Launch-Parameters)
| LOAD_PROSPECT | | Loads an already existing project on server start (Overrides RESUME_PROSPECT. See CREATE_PROSPECT entry for more information on use) |
| RESUME_PROSPECT | True | Loads the last active prospect on server start |
| MAX_PLAYERS | 8 | Maximum number of players on server |
| SHUTDOWN_IF_NOT_JOINED_FOR | 0 | When the server starts up, if no players join within this time, the server will shutdown and return to lobby. During this window the game will be paused. Values of < 0 will cause the server to run indefinitely. A value of 0 will cause the server to shutdown immediately. Values of > 0 will wait that time in seconds. NOTE: Only use low values if you want to use the lobby to start prospects each time. |
| SHUTDOWN_IF_EMPTY_FOR | 300 | When the server becomes empty the server will shutdown and return to lobby after this time (in seconds). During this window the game will be paused. Values of < 0 will cause the server to run indefinitely. A value of 0 will cause the server to shutdown immediately. Values of > 0 will wait that time in seconds. |
| ALLOW_NON_ADMINS_LAUNCH | True | If true anyone who joins the lobby can create a new prospect or load an existing one. If false players will be required to login as admin in order to create or load a prospect. |
| ALLOW_NON_ADMINS_DELETE | False | If true anyone who joins the lobby can delete prospects from the server. If false players will be required to login as admin in order to delete a prospect. |
| TZ | Etc/UTC | Time zone for the server. A full list can be [found here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)
| FILE_UMASK | 022 | umask value to use for configs, backups, and server files. [This article](https://www.digitalocean.com/community/tutorials/linux-permissions-basics-and-how-to-use-umask-on-a-vps) has a good explanation on permissions and how the umask works
| GROUP_ID | 1000 | The Group ID to use for file permissions |
| USER_ID | 1000 | The User ID to use for file permissions |
| STEAM_ASYNC_TIMEOUT | 60 | The timeout value to use when interacting with Steam |
| UPDATES_ENABLED | true | Whether to check for updates or not |
| UPDATES_INTERVAL | 15 | Number of minutes between update checks |
| UPDATES_WHILE_USERS_CONNECTED | false | Whether or not to run updates when users are connected. If set to true, it can cause connected users to lose progress |
| UPDATES_STEAMCMD_ARGS | | Additional arguments to be passed to the steamcmd command |
| RCON_PORT | 25575 | RCON port, if available for the server
| RCON_PASSWORD | ChangeThisPasswordIfUsingRCON | Password to use if exposing RCON |
| RCON_MAX_KARMA | 60 | |

## Backups
| Name | Default | Description |
| ---------------- | ------- | ----------- |
| BACKUPS_ENABLED | true | Whether or not backups should be enabled |
| BACKUPS_MAX_AGE | 3 | Backups more than this many days old will be removed |
| BACKUPS_MAX_COUNT | 0 | Maximum number of backups to keep. 0 keeps all backups |
| BACKUPS_INTERVAL | 360 | Number of minutes between backups |


