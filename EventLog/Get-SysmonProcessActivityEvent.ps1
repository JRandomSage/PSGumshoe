function Get-SysmonProcessActivityEvent {
    <#
    .SYNOPSIS
        Get all or a specific set of Sysmon events for a given Process GUID.
    .DESCRIPTION
        Get all or a specific set of Sysmon events for a given Process GUID.
    .EXAMPLE
        PS C:\> Get-SysmonProcessActivityEvent -ProcessGuid '{278123BE-DE0D-5BBD-0000-0010D45C5E32}'
        Find all events related to the specified process GUID.
    .INPUTS
        System.IO.FileInfo
    #>
    [CmdletBinding(DefaultParameterSetName = 'Local')]
    param (
        # Log name for where the events are stored.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [string]
        $LogName = 'Microsoft-Windows-Sysmon/Operational',

         # Process Guid
        [Parameter(Mandatory = $true,
        ValueFromPipelineByPropertyName = $true)]
        [string[]]
        $ProcessGuid,

        # Type of Activity to get.
        [Parameter(Mandatory = $false)]
        [ValidateSet('Create', 'Terminate', 'FileTime', 'NetworkConnect','ImageLoad','RawAccess', 'FileCreate', 'RegistryKey',
                     'RegistryVAlue','RegistryName', 'FileStream', 'NamedPipeCreate', 'NamedPipeConnect', 'CreateRemoteThread', 'AccessProcess', 'All')]
        [String[]]
        $ActivityType = 'All',

        # Specifies the path to the event log files that this cmdlet get events from. Enter the paths to the log files in a comma-separated list, or use wildcard characters to create file path patterns. Function supports files with the .evtx file name extension. You can include events from different files and file types in the same command.
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="file",
                   ValueFromPipelineByPropertyName=$true)]
        [Alias("FullName")]
        [ValidateNotNullOrEmpty()]
        [SupportsWildcards()]
        [string[]]
        $Path,


        # Gets events from the event logs on the specified computer. Type the NetBIOS name, an Internet Protocol (IP) address, or the fully qualified domain name of the computer.
        # The default value is the local computer.
        # To get events and event logs from remote computers, the firewall port for the event log service must be configured to allow remote access.
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true,
                   ParameterSetName = 'Remote')]
        [string[]]
        $ComputerName,

        # Specifies a user account that has permission to perform this action.
        #
        # Type a user name, such as User01 or Domain01\User01. Or, enter a PSCredential object, such as one generated by the Get-Credential cmdlet. If you type a user name, you will
        # be prompted for a password. If you type only the parameter name, you will be prompted for both a user name and a password.
        [Parameter(Mandatory = $false,
                   ParameterSetName = 'Remote')]
        [Management.Automation.PSCredential]
        [Management.Automation.CredentialAttribute()]
        $Credential,

        # Specifies the maximum number of events that are returned. Enter an integer. The default is to return all the events in the logs or files.
        [Parameter(Mandatory = $false,
                   ValueFromPipelineByPropertyName = $true)]
        [int64]
        $MaxEvents,

        # Stsrttime from where to pull events.
        [Parameter(Mandatory = $false)]
        [datetime]
        $StartTime,

        # Stsrttime from where to pull events.
        [Parameter(Mandatory = $false)]
        [datetime]
        $EndTime,

        # Changes the query action from inclusion to exclusion when fields are matched.
        [Parameter(Mandatory = $false)]
        [switch]
        $Suppress
    )

    begin {}

    process {
        $TypeIds = @()
        foreach ($Type in $ActivityType) {
            switch ($Type) {
                'Create'{ $TypeIds += 1 }
                'Terminate'{ $TypeIds += 5 }
                'FileTime' { $TypeIds += 2 }
                'NetworkConnect' { $TypeIds += 3 }
                'ImageLoad' { $TypeIds += 7 }
                'RawAccess' { $TypeIds += 9 }
                'FileCreate' {$TypeIds += 11 }
                'RegistryKey' {$TypeIds += 12 }
                'RegistryValue' {$TypeIds += 13 }
                'RegistryName' {$TypeIds += 14 }
                'FileStream' {$TypeIds += 15 }
                'NamedPipeCreate' {$TypeIds += 17 }
                'NamedPipeConnect' {$TypeIds += 18 }
                'CreateRemoteThread' {$TypeIds += 8}
                'AccessProcess' {$TypeIds += 10}
                'All' {
                    $TypeIds = 1,2,3,5,7,9,11,12,13,14,15,17,18
                    break
                }
                Default {$TypeIds = 1,2,3,5,7,9,11,12,13,14,15,17,18}
            }
        }
        write-verbose -Message "Events: $($typeIds)"
        $ParametersToSet = $MyInvocation.BoundParameters
        $ParametersToSet.Add('ChangeLogic',$true)
        $ParametersToSet.Add('SourceProcessGUID', $ProcessGuid)
        $ParametersToSet.Add('TargetProcessGUID', $ProcessGuid)

        Search-SysmonEvent -EventId $TypeIds -ParamHash $ParametersToSet
    }

    end {}
}