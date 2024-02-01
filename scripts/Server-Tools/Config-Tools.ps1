$defaultConfigDirectory='/app/configs/'
$destinationConfigDirectory=(Join-Path '/app/server' '/path/to/config/folder')
$configFiles=@{
  # 'Game.ini'=$destinationConfigDirectory
  # 'Engine.ini'=$destinationConfigDirectory
  # 'Server.ini'=$destinationConfigDirectory
}

function Copy-Configs
{
  if (($configFiles).Count -gt 0)
  {
    foreach ($file in $configFiles.GetEnumerator())
    {
      $sourceFile = (Join-Path $defaultConfigDirectory $file.Name)
      if (-Not (Test-Path $file.Value)) { mkdir -p $($file.Value) } # New-Item does really weird things in here
      Copy-Item $sourceFile $file.Value
    } # foreach ($file in $configFiles.GetEnumerator())
  } # if (($configFiles).Count -gt 0)
}

function Update-ConfigFile
{
  
}


  # ### Need to add the update portion to this