Configuration Disable_TZVariable
{
    param(
        [string]$NodeName="localhost"
    )
    
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node $NodeName
    {
        Environment "Disable_TZ"
        {
            Name = "TZ"
            Ensure = "Absent"
        }
    }
}