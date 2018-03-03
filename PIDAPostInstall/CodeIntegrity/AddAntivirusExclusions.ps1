$ExclusionPaths = @(
                        "F:\Apps\PI\log\*.dat",
                        "F:\Apps\PI\dat\*.dat",
                        "G:\Archives\*.arc",
                        "G:\Archives\*.arc.ann",
                        "G:\Archives\future\*.arc",
                        "G:\Archives\future\*.arc.ann",
                        "H:\Queues\*.dat"
                    )

ForEach($ExclusionPath in $ExclusionPaths)
{ 
    Add-MpPreference -ExclusionPath $ExclusionPath
}