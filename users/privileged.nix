config : 
  [ "wheel" ]
    ++ (if config.programs.adb.enable
      then [ "adbusers" ]
      else [ ])
